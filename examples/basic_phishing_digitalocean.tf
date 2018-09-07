terraform {
  required_version = ">= 0.11.0"
}

module "phishing_server" {
  source = "./modules/digitalocean/phishing-server"
}

module "http_rdir" {
  source = "./modules/digitalocean/http-rdir"

  redirect_to = "${module.phishing_server.ips}"
}
