terraform {
  required_version = ">= 0.11.0"
}

module "http_c2" {
  source = "./modules/google/http-c2"
  count = 1
}

module "http_rdir" {
  source = "./modules/google/http-rdir"
  count = 2
  redirect_to = "${module.http_c2.ips}"
  zones = ["Canada-1", "Brazil-2"]
}
