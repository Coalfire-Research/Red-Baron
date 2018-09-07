/*

- 1 HTTP C2
- 2 HTTP Redirectors

- 1 DNS C2
- 1 DNS Redirector

- 3 Domains

- C2s hosted on AWS
- Redirectors hosted on Linode
- Domains managed by Route53

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

    theredbaroness.com                 pizzapastalasagna.com              dns.goodyearbook.com
*/

// Minimum required TF version is 0.10.0

terraform {
  required_version = ">= 0.11.0"
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

  //install = ["./scripts/empire.sh"]
}

module "dns_c2" {
  source = "./modules/aws/dns-c2"

  vpc_id = "${module.create_vpc.vpc_id}"
  subnet_id = "${module.create_vpc.subnet_id}"
}

module "http_rdir" {
  source = "./modules/linode/http-rdir"

  count = 2
  redirect_to = "${module.http_c2.ips}"
  regions = ["UK", "SG"]
}

module "dns_rdir" {
  source = "./modules/linode/dns-rdir"

  redirect_to = "${module.dns_c2.ips}"
}

module "http_rdir1_records" {
  source = "./modules/aws/create-dns-record"
  domain = "theredbaroness.com"
  type = "A"
  records = {
    "theredbaroness.com" = "${module.http_rdir.ips[0]}"
  }
}

module "http_rdir2_records" {
  source = "./modules/aws/create-dns-record"
  domain = "pizzapastalasagna.com"
  type = "A"
  records = {
    "pizzapastalasagna.com" = "${module.http_rdir.ips[1]}"
  }
}

module "dns_rdir_records" {
  source = "./modules/aws/create-dns-record"
  count = 2
  domain = "goodyearbook.com"
  type = "A"
  records = {
    "goodyearbook.com"     = "${module.dns_rdir.ips[0]}"
    "ns1.goodyearbook.com" = "${module.dns_rdir.ips[0]}"
  }
}

module "dns_rdir_ns_record" {
  source = "./modules/aws/create-dns-record"
  domain = "goodyearbook.com"
  type = "NS"
  records = {
    "dns.goodyearbook.com" = "ns1.goodyearbook.com"
  }
}

module "create_certs" {
  source = "./modules/letsencrypt/create-cert-dns"

  count = 2
  domains = ["theredbaroness.com", "pizzapastalasagna.com"]

  subject_alternative_names = {
    "theredbaroness.com" = []
    "pizzapastalasagna.com" = []
  }
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
  value = "${merge(module.http_rdir1_records.records, module.http_rdir2_records.records)}"
}

output "dns_rdir_domains" {
  value = "${merge(module.dns_rdir_records.records, module.dns_rdir_ns_record.records)}"
}
