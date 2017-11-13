terraform {
  required_version = ">= 0.10.0"
}

data "aws_region" "current" {
  current = true
}

resource "aws_key_pair" "dns-rdir" {
  key_name = "dns-rdir-key"
  public_key = "${file(var.ssh_public_key)}"
}

resource "aws_instance" "dns-rdir" {
  // Currently, variables in provider fields are not supported :(
  // This severely limits our ability to spin up instances in diffrent regions 
  // https://github.com/hashicorp/terraform/issues/11578

  //provider = "aws.${element(var.regions, count.index)}"

  count = "${var.count}"

  tags = {
    Name = "dns-rdir-${count.index}"
  }

  ami = "${lookup(var.amis, data.aws_region.current.name)}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.dns-rdir.key_name}"
  vpc_security_group_ids = ["${aws_security_group.dns-rdir.id}"]
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  provisioner "remote-exec" {
    inline = [
        "apt-get update",
        "apt-get install -y tmux socat",
        "tmux new -d \"socat udp4-recvfrom:53,reuseaddr,fork udp4-sendto:${element(var.dns_c2_ips, count.index)}\""
    ]

    connection {
        type = "ssh"
        user = "admin"
        private_key = "${file(var.ssh_private_key)}"
    }
  }
}