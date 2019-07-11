terraform {
  required_version = ">= 0.11.0"
}

resource "random_id" "server" {
  count = "${var.count}"
  byte_length = 4
}

resource "random_string" "password" {
  count = "${var.count}"
  length = 16
  special = true
}

resource "tls_private_key" "ssh" {
  count = "${var.count}"
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "linode_linode" "http-c2" {
  // Due to a current limitation the count parameter cannot be a dynamic value :(
  // https://github.com/hashicorp/terraform/issues/14677
  // count = "${length(var.http_c2_ips)}"

  count = "${var.count}"
  image = "Debian 9"
  kernel = "Latest 64 bit"
  name = "http-c2-${random_id.server.*.hex[count.index]}"
  group = "${var.group}"
  region = "${var.available_regions[element(var.regions, count.index)]}"
  size = "${var.size}"
  ssh_key = "${tls_private_key.ssh.*.public_key_openssh[count.index]}"
  root_password = "${random_string.password.*.result[count.index]}"

  provisioner "remote-exec" {
    scripts = "${concat(list("./scripts/core_deps.sh"), var.install)}"

    connection {
        type = "ssh"
        user = "root"
        private_key = "${tls_private_key.ssh.*.private_key_pem[count.index]}"
    }
  }

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.ssh.*.private_key_pem[count.index]}\" > ./data/ssh_keys/${self.ip_address} && echo \"${tls_private_key.ssh.*.public_key_openssh[count.index]}\" > ./data/ssh_keys/${self.ip_address}.pub && chmod 600 ./data/ssh_keys/*" 
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "rm ./data/ssh_keys/${self.ip_address}*"
  }

}

resource "null_resource" "ansible_provisioner" {
  count = "${signum(length(var.ansible_playbook)) == 1 ? var.count : 0}"

  depends_on = ["linode_linode.http-c2"]

  triggers {
    droplet_creation = "${join("," , linode_linode.http-c2.*.id)}"
    policy_sha1 = "${sha1(file(var.ansible_playbook))}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook ${join(" ", compact(var.ansible_arguments))} --user=root --private-key=./data/ssh_keys/${linode_linode.http-c2.*.ip_address[count.index]} -e host=${linode_linode.http-c2.*.ip_address[count.index]} ${var.ansible_playbook}"

    environment {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "ssh_config" {

  count    = "${var.count}"

  template = "${file("./data/templates/ssh_config.tpl")}"

  depends_on = ["linode_linode.http-c2"]

  vars {
    name = "http_c2_${linode_linode.http-c2.*.ip_address[count.index]}"
    hostname = "${linode_linode.http-c2.*.ip_address[count.index]}"
    user = "root"
    identityfile = "${path.root}/data/ssh_keys/${linode_linode.http-c2.*.ip_address[count.index]}"
  }

}

resource "null_resource" "gen_ssh_config" {

  count = "${var.count}"

  triggers {
    template_rendered = "${data.template_file.ssh_config.*.rendered[count.index]}"
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.ssh_config.*.rendered[count.index]}' > ./data/ssh_configs/config_${random_id.server.*.hex[count.index]}"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "rm ./data/ssh_configs/config_${random_id.server.*.hex[count.index]}"
  }

}