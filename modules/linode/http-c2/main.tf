terraform {
  required_version = ">= 0.10.0"
}

resource "linode_linode" "http-c2" {
  // Due to a current limitation the count parameter cannot be a dynamic value :(
  // https://github.com/hashicorp/terraform/issues/14677
  // count = "${length(var.http_c2_ips)}"

  count = "${var.count}"
  image = "Debian 9"
  kernel = "Latest 64 bit"
  name = "http-c2-${count.index}"
  group = "${var.group}"
  region = "${lookup(var.available_regions, element(var.regions, count.index))}"
  size = "${var.size}"
  ssh_key = "${file(var.ssh_public_key)}"
  root_password = "${var.root_password}"

  provisioner "remote-exec" {
    scripts = "${var.install}"

    connection {
        type = "ssh"
        user = "root"
        private_key = "${file(var.ssh_private_key)}"
    }
  }
}
