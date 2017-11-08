terraform {
  required_version = ">= 0.10.0"
}

resource "godaddy_domain_record" "dns-rdir-domain" {
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

  record {
    name = "${var.a_record_name}"
    type = "A"
    data = "${var.ip_address}"
    ttl = 600
  }

  record {
    name = "${var.ns_record_name}"
    type = "NS"
    data = "${var.a_record_name}.${var.domain}"
    ttl = 600
  }

  nameservers = "${var.nameservers}"
}