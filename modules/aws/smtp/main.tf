data "aws_region" "current" {}

# Random ID generator
resource "random_id" "username" {
  keepers = {
    zone_id = "${var.zone_id}"
  }

  byte_length = 6
}

# IAM user for SES SMTP
resource "aws_iam_user" "smtp_user" {
  name = "ses-smtp-${random_id.username.hex}"
}

# IAM policy to send emails via SMTP through SES
resource "aws_iam_user_policy" "smtp_policy" {
  name = "${aws_iam_user.smtp_user.name}-policy"
  user = "${aws_iam_user.smtp_user.name}"

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Action":[
        "ses:SendEmail",
        "ses:SendRawEmail"
      ],
      "Resource":"*",
      "Condition":{
        "StringLike":{
          "ses:FromAddress": "*@${var.domain}"
        }
      }
    }
  ]
}
EOF
}

# IAM access key for SES SMTP user
resource "aws_iam_access_key" "smtp_access_key" {
  user = "${aws_iam_user.smtp_user.name}"
}

# SES domain Identity
resource "aws_ses_domain_identity" "identity" {
  domain = "${var.domain}"
}

# SES domain DKIM
resource "aws_ses_domain_dkim" "dkim" {
  domain = "${aws_ses_domain_identity.identity.domain}"
}

# SES domain mail sender
resource "aws_ses_domain_mail_from" "mail_from" {
  domain           = "${aws_ses_domain_identity.identity.domain}"
  mail_from_domain = "${var.mx_subdomain}.${aws_ses_domain_identity.identity.domain}"
}

# Route53 TXT record for SES validation
resource "aws_route53_record" "ses_txt_record" {
  zone_id = "${var.zone_id}"
  name    = "_amazonses.${aws_ses_domain_identity.identity.domain}"
  type    = "TXT"
  ttl     = "600"
  records = ["${aws_ses_domain_identity.identity.verification_token}"]
}

# Route53 MX record
resource "aws_route53_record" "mx_record" {
  zone_id = "${var.zone_id}"
  name    = "${aws_ses_domain_mail_from.mail_from.mail_from_domain}"
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.${data.aws_region.current.name}.amazonses.com"]
}

# Route53 TXT record for SPF
resource "aws_route53_record" "spf_record" {
  zone_id = "${var.zone_id}"
  name    = "${aws_ses_domain_mail_from.mail_from.mail_from_domain}"
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

# Route53 CNAME records for DKIM
resource "aws_route53_record" "dkim_record" {
  count   = 3
  zone_id = "${var.zone_id}"
  name    = "${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}._domainkey.${aws_ses_domain_identity.identity.domain}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
