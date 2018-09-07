terraform {
  required_version = ">= 0.11.0"
}

module "http_c2" {
  source = "./modules/digitalocean/http-c2"

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
  source = "./modules/digitalocean/http-rdir"

  // 1 redirector ha. ha. ha... 2 redirectors ha. ha. ha... 3 redirectors ha. ha. ha..
  //count = 4

  redirect_to = "${module.http_c2.ips}"

  //regions = ["NYC1", "SGP1"]
}

// print the c2 and redirector ips to the screen all perty like when everything's done
output "http-c2-ips" {
  value = "${module.http_c2.ips}"
}

output "http-rdir-ips" {
  value = "${module.http_rdir.ips}"
}