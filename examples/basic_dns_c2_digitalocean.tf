terraform {
  required_version = ">= 0.11.0"
}

module "dns_c2" {
  source = "./modules/digitalocean/dns-c2"

  // 1 dns C2 ha. ha. ha... 2 dns C2s ha. ha. ha... 3 dns C2s ha. ha. ha...
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

module "dns_rdir" {
  source = "./modules/digitalocean/dns-rdir"

  // 1 redirector ha. ha. ha... 2 redirectors ha. ha. ha... 3 redirectors ha. ha. ha..
  //count = 4

  redirect_to = "${module.dns_c2.ips}"

  //regions = ["NYC1", "SGP1"]
}

// print the c2 and redirector ips to the screen all perty like when everything's done
output "dns-c2-ips" {
  value = "${module.dns_c2.ips}"
}

output "dns-rdir-ips" {
  value = "${module.dns_rdir.ips}"
}