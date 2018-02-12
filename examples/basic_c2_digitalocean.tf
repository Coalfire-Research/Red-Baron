terraform {
  required_version = ">= 0.10.0"
}

module "http_c2" {
  source = "./modules/digitalocean/http-c2"
}

module "http_rdir" {
  source = "./modules/digitalocean/http-rdir"

  redirect_to = "${module.http_c2.ips}"
}

module "dns_c2" {
  source = "./modules/digitalocean/dns-c2"
}

module "dns_rdir" {
  source = "./modules/digitalocean/dns-rdir"

  redirect_to = "${module.dns_c2.ips}"
}
