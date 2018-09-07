// Minimum required TF version is 0.10.0

terraform {
  required_version = ">= 0.11.0"
}

module "http_c2" {
  source = "./modules/linode/http-c2"

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
  source = "./modules/linode/http-rdir"

  // 1 redirector ha. ha. ha... 2 redirectors ha. ha. ha... 3 redirectors ha. ha. ha..
  //count = 4
  redirect_to = "${module.http_c2.ips}"

  //regions = ["TX", "SG"]
}
