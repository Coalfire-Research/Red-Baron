terraform {
  required_version = ">= 0.11.0"
}

resource "random_id" "server" {
  count = var.count_vm
  byte_length = 4
}

resource "tls_private_key" "ssh" {
  count = var.count_vm
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "digitalocean_ssh_key" "ssh_key" {
  count = var.count_vm
  name  = "phishing-server-key-${random_id.server.*.hex[count.index]}"
  public_key = tls_private_key.ssh.*.public_key_openssh[count.index]
}

resource "digitalocean_droplet" "phishing-server" {
  count = var.count_vm
  image = "debian-9-x64"
  name = "phishing-server-${random_id.server.*.hex[count.index]}"
  region = var.available_regions[element(var.regions, count.index)]
  ssh_keys = ["${digitalocean_ssh_key.ssh_key.*.id[count.index]}"]
  size = var.size

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y tmux apache2 certbot mosh",
      "a2enmod ssl",
      "systemctl stop apache2"
    ]

    connection {
        type = "ssh"
        user = "root"
        private_key = tls_private_key.ssh.*.private_key_pem[count.index]
    }
  }

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.ssh.*.private_key_pem[count.index]}\" > ./ssh_keys/${self.ipv4_address} && echo \"${tls_private_key.ssh.*.public_key_openssh[count.index]}\" > ./ssh_keys/${self.ipv4_address}.pub && chmod 600 ./data/ssh_keys/*" 
  }

  provisioner "local-exec" {
    when = destroy
    command = "rm ./ssh_keys/${self.ipv4_address}*"
  }

}

resource "null_resource" "ansible_provisioner" {
  count = signum(length(var.ansible_playbook)) == 1 ? var.count_vm : 0

  depends_on = [digitalocean_droplet.phishing-server]

  triggers = {
    droplet_creation = join("," , digitalocean_droplet.phishing-server.*.id)
    policy_sha1 = sha1(file(var.ansible_playbook))
  }

  provisioner "local-exec" {
    command = "ansible-playbook ${join(" ", compact(var.ansible_arguments))} --user=root --private-key=./data/ssh_keys/${digitalocean_droplet.phishing-server.*.ipv4_address[count.index]} -e host=${digitalocean_droplet.phishing-server.*.ipv4_address[count.index]} ${var.ansible_playbook}"

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

  depends_on = [digitalocean_droplet.phishing-server]

  vars = {
    name = "phishing_server_${digitalocean_droplet.phishing-server.*.ipv4_address[count.index]}"
    hostname = digitalocean_droplet.phishing-server.*.ipv4_address[count.index]
    user = "root"
    identityfile = path.root}/data/ssh_keys/${digitalocean_droplet.phishing-server.*.ipv4_address[count.index]
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