terraform {
  required_version = ">= 0.11.0"
}

resource "godaddy_domain_record" "record" {
  count = "${var.count}"
  domain   = "${var.domain}"

  record {
    name = "${element(keys(var.records), count.index)}"
    type = "${var.type}"
    data = "${lookup(var.records, element(keys(var.records), count.index))}"
    ttl = "${var.ttl}"
  }
}
