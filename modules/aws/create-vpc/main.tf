terraform {
  required_version = ">= 0.11.0"
}

// Currently, variables in provider fields are not supported :(
// This severely limits our ability to spin up instances in diffrent regions 
// https://github.com/hashicorp/terraform/issues/11578

resource "aws_vpc" "default" {
  //count = "${var.count}"
  //provider = "aws.${element(var.regions, count.index)}"

  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "default" {
  //count = "${var.count}"
  //provider = "aws.${element(var.regions, count.index)}"

  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "default" {
  //count = "${var.count}"
  //provider = "aws.${element(var.regions, count.index)}"

  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "default" {
  //count = "${var.count}"
  //provider = "aws.${element(var.regions, count.index)}"

  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

resource "aws_route_table_association" "default" {
  //count = "${var.count}"
  //provider = "aws.${element(var.regions, count.index)}"

  subnet_id = "${aws_subnet.default.id}"
  route_table_id = "${aws_route_table.default.id}"
}
