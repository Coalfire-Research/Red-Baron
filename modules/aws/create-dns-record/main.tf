terraform {
  required_version = ">= 0.10.0"
}

data "aws_route53_zone" "selected" {
  name  = "${var.domain}"
}

resource "aws_route53_record" "record" {
  count = "${var.count}"

  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name = "${element(keys(var.records), count.index)}"
  type = "${var.type}"
  ttl = "${var.ttl}"
  records = ["${lookup(var.records, element(keys(var.records), count.index))}"]
}