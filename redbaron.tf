// Minimum required TF version is 0.10.0

terraform {
  required_version = ">= 0.10.0"
}

// Create VPC for AWS instances

module "create_vpc" {
  source = "./modules/aws/create-vpc"
}

// -------------------------------------

module "http_c2" {
  source = "./modules/aws/http-c2"

  vpc_id = "${module.create_vpc.vpc_id}"
  subnet_id = "${module.create_vpc.subnet_id}"
  my_ip = "116.87.3.233"
}

module "dns_c2" {
  source = "./modules/aws/dns-c2"

  vpc_id = "${module.create_vpc.vpc_id}"
  subnet_id = "${module.create_vpc.subnet_id}"
  my_ip = "116.87.3.233"
}

module "http_rdir" {
  source = "./modules/linode/http-rdir"

  root_password = "${var.linode_root_password}"
  http_c2_ips = "${module.http_c2.ips}"
}

module "dns_rdir" {
  source = "./modules/linode/dns-rdir"

  root_password = "${var.linode_root_password}"
  dns_c2_ips = "${module.dns_c2.ips}"
}

output "http-c2-ips" {
  value = "${module.http_c2.ips}"
}

output "dns-c2-ips" {
  value = "${module.dns_c2.ips}"
}

output "http-rdir-ips" {
  value = "${module.http_rdir.ips}"
}

output "dns-rdir-ips" {
  value = "${module.dns_rdir.ips}"
}