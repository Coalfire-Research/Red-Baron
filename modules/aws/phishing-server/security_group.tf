terraform {
  required_version = ">= 0.11.0"
}

data "external" "get_public_ip" {
  program = ["bash", "./scripts/get_public_ip.sh" ]
}

resource "aws_security_group" "phishing-server" {
  name = "phishing-server"
  description = "Security group created by Red Baron"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${data.external.get_public_ip.result["ip"]}/32"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    /*
    cidr_blocks = ["${linode_linode.http-rdir-1.ip_address}/32",
                   "${linode_linode.http-rdir-2.ip_address}/32", 
                   "${linode_linode.http-rdir-3.ip_address}/32", 
                   "${var.my_ip}/32"]
    */
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    /*
    cidr_blocks = ["${linode_linode.http-rdir-1.ip_address}/32",
                   "${linode_linode.http-rdir-2.ip_address}/32", 
                   "${linode_linode.http-rdir-3.ip_address}/32", 
                   "${var.my_ip}/32"]
    */

    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 60000
    to_port = 61000
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 53
    to_port = 53
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
