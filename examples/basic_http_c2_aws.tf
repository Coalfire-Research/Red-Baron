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

  // 1 http C2 ha. ha. ha... 2 http C2s ha. ha. ha... 3 http C2s ha. ha. ha...
  //count = 2

  // Wanna install empire?
  //install = ["./scripts/empire.sh"]

  // Wanna install metasploit?
  //install = ["./scripts/metasploit.sh"]

  // Wanna install CS?
  //install = ["./scripts/cobaltstrike.sh"]

  // I WANT EVERYTHING
  //install = ["./scripts/empire.sh", "./scripts/metasploit.sh", "./scripts/cobaltstrike.sh"]
}


module "http_rdir" {
  source = "./modules/aws/http-rdir"

  //count = 4
  vpc_id = "${module.create_vpc.vpc_id}"
  subnet_id = "${module.create_vpc.subnet_id}"

  redirect_to = "${module.http_c2.ips}"

  //regions = ["TX", "SG"]
}
