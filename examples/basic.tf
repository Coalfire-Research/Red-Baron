/*
The simplest and most common scenario:

- 1 HTTP C2
- 2 HTTP Redirectors

- 1 DNS C2
- 1 DNS Redirector

- 3 Domains

- C2s hosted on AWS
- Redirectors hosted on Linode
- Domains managed by GoDaddy

                   +----------------------+                            +----------------------+
                   |                      |                            |                      |
                   |                      |                            |                      |
                   |       HTTP C2        |                            |        DNS C2        |
                   |                      |                            |                      |
                   |                      |                            |                      |
                   +----------+-----------+                            +-----------+----------+
                              ^                                                    ^
                              |                                                    |
                              |                                                    |
                              |                                                    |
                              |                                                    |
                       +------+-------+                                            |
                       |              |                                            |
                       |              |                                            |
+----------------------+              +----------------------+          +----------+-----------+
|                      |              |                      |          |                      |
|                      |              |                      |          |                      |
|   HTTP REDIRECTOR    |              |    HTTP REDIRECTOR   |          |    DNS REDIRECTOR    |
|                      |              |                      |          |                      |
|                      |              |                      |          |                      |
+----------+-----------+              +----------+-----------+          +----------+-----------+
           ^                                     ^                                 ^
           |                                     |                                 |
           |                                     |                                 |
           +                                     +                                 +

      domain.com                            domain2.com                      dns.domain3.com
*/

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

  //install = ["./scripts/c2_core_deps.sh", "./scripts/empire.sh"]
}

module "dns_c2" {
  source = "./modules/aws/dns-c2"

  vpc_id = "${module.create_vpc.vpc_id}"
  subnet_id = "${module.create_vpc.subnet_id}"
}

module "http_rdir" {
  source = "./modules/linode/http-rdir"

  count = 2
  root_password = "${var.linode_root_password}"
  http_c2_ips = "${module.http_c2.ips}"
  regions = ["UK", "SG"]
}

module "dns_rdir" {
  source = "./modules/linode/dns-rdir"

  root_password = "${var.linode_root_password}"
  dns_c2_ips = "${module.dns_c2.ips}"
}

module "a_record" {
  source = "./modules/godaddy/a-record"

  count = 2
  domains = ["domain.com", "domain2.com"]
  data = "${module.http_rdir.ips}"
}

module "ns_record" {
  source = "./modules/godaddy/ns-record"

  domains = ["domain3.com"]
  data = "${module.dns_rdir.ips}"
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

output "http_rdir_domains" {
  value = "${module.a_record.records}"
}

output "dns_rdir_domains" {
  value = "${module.ns_record.records}"
}