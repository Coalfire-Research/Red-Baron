terraform {
  required_version = ">= 0.10.0"
}

data "aws_region" "current" {}

resource "random_id" "server" {
  count = "${var.count}"
  byte_length = 4
}

resource "tls_private_key" "ssh" {
  count = "${var.count}"
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "http-c2" {
  count = "${var.count}"
  key_name = "http-c2-key-${count.index}"
  public_key = "${tls_private_key.ssh.*.public_key_openssh[count.index]}"
}

resource "aws_instance" "http-c2" {
  // Currently, variables in provider fields are not supported :(
  // This severely limits our ability to spin up instances in diffrent regions 
  // https://github.com/hashicorp/terraform/issues/11578

  //provider = "aws.${element(var.regions, count.index)}"

  count = "${var.count}"
  
  tags = {
    Name = "http-c2-${random_id.server.*.hex[count.index]}"
  }

  ami = "${var.amis[data.aws_region.current.name]}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.http-c2.*.key_name[count.index]}"
  vpc_security_group_ids = ["${aws_security_group.http-c2.id}"]
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  provisioner "remote-exec" {
    scripts = "${concat(list("./scripts/core_deps.sh"), var.install)}"

    connection {
        type = "ssh"
        user = "admin"
        private_key = "${tls_private_key.ssh.*.private_key_pem[count.index]}"
    }
  }

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.ssh.*.private_key_pem[count.index]}\" > ./ssh_keys/http_c2_${self.public_ip} && echo \"${tls_private_key.ssh.*.public_key_openssh[count.index]}\" > ./ssh_keys/http_c2_${self.public_ip}.pub" 
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "rm ./ssh_keys/http_c2_${self.public_ip}*"
  }

}