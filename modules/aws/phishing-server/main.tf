terraform {
  required_version = ">= 0.11.0"
}

data "aws_region" "current" {}

resource "random_id" "server" {
  count = var.count_vm
  byte_length = 4
}

resource "tls_private_key" "ssh" {
  count = var.count_vm
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "phishing-server" {
  count = var.count_vm
  key_name = "phishing-server-key-${count.index}"
  public_key = tls_private_key.ssh.*.public_key_openssh[count.index]
}

resource "aws_instance" "phishing-server" {
  // Currently, variables in provider fields are not supported :(
  // This severely limits our ability to spin up instances in diffrent regions 
  // https://github.com/hashicorp/terraform/issues/11578

  //provider = "aws.${element(var.regions, count.index)}"

  count = var.count_vm
  
  tags = {
    Name = "phishing-server-${random_id.server.*.hex[count.index]}"
  }

  ami = var.amis[data.aws_region.current.name]
  instance_type = var.instance_type
  key_name = aws_key_pair.phishing-server.*.key_name[count.index]
  vpc_security_group_ids = ["${aws_security_group.phishing-server.id}"]
  subnet_id = var.subnet_id
  associate_public_ip_address = true

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y tmux apache2 certbot mosh",
      "sudo a2enmod ssl",
      "sudo systemctl stop apache2"
    ]

    connection {
        type = "ssh"
        user = "admin"
        private_key = tls_private_key.ssh.*.private_key_pem[count.index]
    }
  }

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.ssh.*.private_key_pem[count.index]}\" > ./data/ssh_keys/${self.public_ip} && echo \"${tls_private_key.ssh.*.public_key_openssh[count.index]}\" > ./data/ssh_keys/${self.public_ip}.pub && chmod 600 ./data/ssh_keys/*" 
  }

  provisioner "local-exec" {
    when = destroy
    command = "rm ./data/ssh_keys/${self.public_ip}*"
  }

}

resource "null_resource" "ansible_provisioner" {
  count = signum(length(var.ansible_playbook)) == 1 ? var.count_vm : 0

  depends_on = [aws_instance.phishing-server]

  triggers = {
    droplet_creation = join("," , aws_instance.phishing-server.*.id)
    policy_sha1 = sha1(file(var.ansible_playbook))
  }

  provisioner "local-exec" {
    command = "ansible-playbook ${join(" ", compact(var.ansible_arguments))} --user=admin --private-key=./data/ssh_keys/${aws_instance.phishing-server.*.public_ip[count.index]} -e host=${aws_instance.phishing-server.*.public_ip[count.index]} ${var.ansible_playbook}"

    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "ssh_config" {

  count    = var.count_vm

  template = file("./data/templates/ssh_config.tpl")

  depends_on = [aws_instance.phishing-server]

  vars = {
    name = "dns_rdir_${aws_instance.phishing-server.*.public_ip[count.index]}"
    hostname = aws_instance.phishing-server.*.public_ip[count.index]
    user = "admin"
    identityfile = path.root}/data/ssh_keys/${aws_instance.phishing-server.*.public_ip[count.index]
  }

}

resource "null_resource" "gen_ssh_config" {

  count = var.count_vm

  triggers = {
    template_rendered = data.template_file.ssh_config.*.rendered[count.index]
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.ssh_config.*.rendered[count.index]}' > ./data/ssh_configs/config_${random_id.server.*.hex[count.index]}"
  }

  provisioner "local-exec" {
    when = destroy
    command = "rm ./data/ssh_configs/config_${random_id.server.*.hex[count.index]}"
  }

}