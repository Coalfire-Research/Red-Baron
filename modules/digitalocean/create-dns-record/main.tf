terraform {
  required_version = ">= 0.11.0"
}

# Add a record to the domain
resource "digitalocean_record" "record" {
  count  = "${var.count}"
  domain = "${element(keys(var.records), count.index)}"
  type   = "${var.type}"
  value  = "${lookup(var.records, element(keys(var.records), count.index))}"
  ttl    = "${var.ttl}"
}
