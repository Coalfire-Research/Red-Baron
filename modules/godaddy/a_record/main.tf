terraform {
  required_version = ">= 0.10.0"
}

resource "godaddy_domain_record" "http-rdir-domain" {
  domain   = "${var.domain}"

  record {
    name = "@"
    type = "A"
    data = "${var.ip_address}"
    ttl = 600
  }

  record {
    name = "www"
    type = "CNAME"
    data = "@"
    ttl = 600
  }

  nameservers = "${var.nameservers}"
}