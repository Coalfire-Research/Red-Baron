terraform {
  required_version = ">= 0.10.0"
}

resource "linode_linode" "http-rdir" {
  // Due to a current limitation the count parameter cannot be a dynamic value :(
  // https://github.com/hashicorp/terraform/issues/14677
  // count = "${length(var.http_c2_ips)}"

  count = "${var.count}"
  image = "Debian 9"
  kernel = "Latest 64 bit"
  name = "http-rdir-${count.index}"
  group = "${var.group}"
  region = "${var.region}"
  size = "${var.size}"
  ssh_key = "${file(var.ssh_public_key)}"
  root_password = "${var.root_password}"

  provisioner "remote-exec" {
    inline = [
        "apt-get update",
        "apt-get install -y tmux socat apache2",
        "systemctl stop apache2",
        "tmux new -d \"socat TCP4-LISTEN:80,fork TCP4:${element(var.http_c2_ips, count.index)}:80\" ';' split \"socat TCP4-LISTEN:443,fork TCP4:${element(var.http_c2_ips, count.index)}:443\""
    ]

    connection {
        type = "ssh"
        user = "root"
        private_key = "${file(var.ssh_private_key)}"
    }
  }
}
