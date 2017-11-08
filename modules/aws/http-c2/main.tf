terraform {
  required_version = ">= 0.10.0"
}

resource "aws_key_pair" "http-c2" {
  key_name = "http-c2-key"
  public_key = "${file(var.ssh_public_key)}"
}

resource "aws_instance" "http-c2" {
  count = "${var.count}"
  tags = {
    Name = "http-c2-${count.index}"
  }

  ami = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.http-c2.key_name}"
  vpc_security_group_ids = ["${aws_security_group.http-c2.id}"]
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