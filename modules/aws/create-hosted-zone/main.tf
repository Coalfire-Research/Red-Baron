resource "aws_route53_zone" "new_zone" {
  name = "${var.domain}"
}