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

resource "linode_linode" "dns-rdir" {
  // Due to a current limitation the count parameter cannot be a dynamic value :(
  // https://github.com/hashicorp/terraform/issues/14677
  // count = "${length(var.redirect_to)}"

  count = "${var.count}"
  image = "Debian 9"
  kernel = "Latest 64 bit"
  name = "dns-rdir-${random_id.server.*.hex[count.index]}"
  group = "${var.group}"
  region = "${var.available_regions[element(var.regions, count.index)]}"
  size = "${var.size}"
  ssh_key = "${tls_private_key.ssh.*.public_key_openssh[count.index]}"
  root_password = "${random_string.password.*.result[count.index]}"

  provisioner "remote-exec" {
    inline = [
        "apt-get update",
        "apt-get install -y tmux socat",
        "tmux new -d \"socat udp4-recvfrom:53,reuseaddr,fork udp4-sendto:${element(var.redirect_to, count.index)}\""
    ]

    connection {
        type = "ssh"
        user = "root"
        private_key = "${tls_private_key.ssh.*.private_key_pem[count.index]}"
    }
  }

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.ssh.*.private_key_pem[count.index]}\" > ./ssh_keys/dns_rdir_${self.ip_address} && echo \"${tls_private_key.ssh.*.public_key_openssh[count.index]}\" > ./ssh_keys/dns_rdir_${self.ip_address}.pub" 
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "rm ./ssh_keys/dns_rdir_${self.ip_address}*"
  }

}