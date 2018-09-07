terraform {
  required_version = ">= 0.11.0"
}

resource "aws_cloudfront_distribution" "http-c2" {
    enabled = true
    is_ipv6_enabled = false

    origin {
        domain_name = "${var.domain}"
        origin_id = "domain-front"

        custom_origin_config {
            http_port = 80
            https_port = 443
            origin_protocol_policy = "match-viewer"
            origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
        }
    }

    default_cache_behavior {
        target_origin_id = "domain-front"
        allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
        cached_methods = ["GET", "HEAD"]
        viewer_protocol_policy = "allow-all"
        min_ttl = 0
        default_ttl = 86400
        max_ttl = 31536000

        forwarded_values {
            query_string = true
            headers = ["*"]

            cookies {
                forward = "all"
            }
        }

    }

    restrictions {
        geo_restriction {
            restriction_type = "whitelist"
            locations = ["US"]
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }
}
