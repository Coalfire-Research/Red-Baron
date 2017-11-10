terraform {
  required_version = ">= 0.10.0"
}

data "aws_region" "current" {
  current = true
}

resource "aws_key_pair" "dns-c2" {
  key_name = "dns-c2-key"
  public_key = "${file(var.ssh_public_key)}"
}

resource "aws_instance" "dns-c2" {
  // Currently, variables in provider fields are not supported :(
  // This severely limits our ability to spin up instances in diffrent regions 
  // https://github.com/hashicorp/terraform/issues/11578

  //provider = "aws.${element(var.regions, count.index)}"

  count = "${var.count}"

  tags = {
    Name = "dns-c2-${count.index}"
  }

  ami = "${lookup(var.amis, data.aws_region.current.name)}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.dns-c2.key_name}"
  vpc_security_group_ids = ["${aws_security_group.dns-c2.id}"]
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  provisioner "remote-exec" {
    scripts = "${var.install}"

    connection {
        type = "ssh"
        user = "admin"
        private_key = "${file(var.ssh_private_key)}"
    }
  }
}