terraform {
  required_version = ">= 0.10.0"
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

resource "linode_linode" "dns-c2" {
  // Due to a current limitation the count parameter cannot be a dynamic value :(
  // https://github.com/hashicorp/terraform/issues/14677
  // count = "${length(var.dns_c2_ips)}"

  count = "${var.count}"
  image = "Debian 9"
  kernel = "Latest 64 bit"
  name = "dns-c2-${random_id.server.*.hex[count.index]}"
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
    command = "echo \"${tls_private_key.ssh.*.private_key_pem[count.index]}\" > ./ssh_keys/dns_c2_${self.ip_address} && echo \"${tls_private_key.ssh.*.public_key_openssh[count.index]}\" > ./ssh_keys/dns_c2_${self.ip_address}.pub" 
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "rm ./ssh_keys/dns_c2_${self.ip_address}*"
  }
}