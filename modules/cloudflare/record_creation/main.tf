//setup our benign CNAME relay. No need to clone

//our overall domain
resource "cloudflare_record" "record" {
    zone_id = "${var.zone_id}"
    name = "${var.hostname}"
    type = "${var.type}"
    ttl = "1"
    proxied = "true"
    value = "${var.server}"
}
