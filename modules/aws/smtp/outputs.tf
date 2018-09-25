output "smtp_server" {
  value = "email-smtp.${data.aws_region.current.name}.amazonaws.com"
}

output "smtp_username" {
  value = "${aws_iam_access_key.smtp_access_key.id}"
}

output "smtp_password" {
  value = "${aws_iam_access_key.smtp_access_key.ses_smtp_password}"
}
