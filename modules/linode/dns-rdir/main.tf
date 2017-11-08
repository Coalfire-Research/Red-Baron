terraform {
  required_version = ">= 0.10.0"
}

resource "linode_linode" "dns-rdir" {
  // Due to a current limitation the count parameter cannot be a dynamic value :(
  // https://github.com/hashicorp/terraform/issues/14677
  // count = "${length(var.dns_c2_ips)}"

  count = "${var.count}"
  image = "Debian 9"
  kernel = "Latest 64 bit"
  name = "dns-rdir-${count.index}"
  group = "${var.group}"
  region = "${var.region}"
  size = "${var.size}"
  ssh_key = "${file(var.ssh_public_key)}"
  root_password = "${var.root_password}"

  provisioner "remote-exec" {
    inline = [
        "apt-get update",
        "apt-get install -y tmux socat",
        "tmux new -d \"socat udp4-recvfrom:53,reuseaddr,fork udp4-sendto:${element(var.dns_c2_ips, count.index)}\""
    ]

    connection {
        type = "ssh"
        user = "root"
        private_key = "${file(var.ssh_private_key)}"
    }
  }
}