output "cf-domain" {
    value = "${aws_cloudfront_distribution.http-c2.domain_name}"
}