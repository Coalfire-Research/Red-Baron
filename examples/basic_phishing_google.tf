// Minimum required TF version is 0.10.0

terraform {
  required_version = ">= 0.11.0"
}

module "phishing_server" {
  source = "./modules/google/phishing-server"
  count = 1
}


module "http_rdir" {
  source = "./modules/linode/http-rdir"
  count = 4
  redirect_to = "${module.phishing_server.ips}"

  regions = ["Oregon-1", "Singapore-1", "Australia-2", "Japan-1"]
}
