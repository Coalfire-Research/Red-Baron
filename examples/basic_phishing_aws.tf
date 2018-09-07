// Minimum required TF version is 0.10.0

terraform {
  required_version = ">= 0.11.0"
}

// Create VPC for AWS instances

module "create_vpc" {
  source = "./modules/aws/create-vpc"
}

// -------------------------------------

module "phishing_server" {
  source = "./modules/aws/phishing-server"

  // 1 phishing server ha. ha. ha... 2 phishing servers ha. ha. ha... 3 phishing servers ha. ha. ha...
  //count = 2
  vpc_id = "${module.create_vpc.vpc_id}"
  subnet_id = "${module.create_vpc.subnet_id}"

}

module "http_rdir" {
  source = "./modules/aws/http-rdir"

  // 1 redirector ha. ha. ha... 2 redirectors ha. ha. ha... 3 redirectors ha. ha. ha...
  //count = 4
  vpc_id = "${module.create_vpc.vpc_id}"
  subnet_id = "${module.create_vpc.subnet_id}"

  redirect_to = "${module.phishing_server.ips}"

}
