// Minimum required TF version is 0.10.0

terraform {
  required_version = ">= 0.11.0"
}

module "phishing_server" {
  source = "./modules/linode/phishing-server"

  // 1 phishing server ha. ha. ha... 2 phishing servers ha. ha. ha... 3 phishing servers ha. ha. ha...
  //count = 2
}


module "http_rdir" {
  source = "./modules/linode/http-rdir"

  // 1 redirector ha. ha. ha... 2 redirectors ha. ha. ha... 3 redirectors ha. ha. ha...
  //count = 4
  redirect_to = "${module.phishing_server.ips}"

  // 1337 APT's all come from Texas and Singapore
  //regions = ["TX", "SG"]
}
