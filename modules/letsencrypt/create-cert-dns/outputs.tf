output "certificate_domain" {
  value = ["${acme_certificate.certificate.*.certificate_domain}"]
}
output "certificate_url" {
  value = ["${acme_certificate.certificate.*.certificate_url}"]
}
output "certificate_pem" {
  value = ["${acme_certificate.certificate.*.certificate_pem}"]
}
output "certificate_private_key_pem" {
  sensitive = true
  value = ["${acme_certificate.certificate.*.private_key_pem}"]
}
output "certificate_issuer_pem" {
  value = ["${acme_certificate.certificate.*.issuer_pem}"]
}