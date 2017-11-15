terraform {
  required_version = ">= 0.10.0"
}

# Create the private key for the registration (not the certificate)
resource "tls_private_key" "private_key" {
  count = "${var.count}"
  algorithm = "RSA"
  rsa_bits = "4096"
}

# Set up a registration using a private key from tls_private_key
resource "acme_registration" "reg" {
  count = "${var.count}"
  server_url      = "${lookup(var.server_urls, var.server_url)}"
  account_key_pem = "${element(tls_private_key.private_key.*.private_key_pem, count.index)}"
  email_address   = "${var.reg_email}"
}

# Create a certificate
resource "acme_certificate" "certificate" {
  count                     = "${var.count}"
  server_url                = "${lookup(var.server_urls, var.server_url)}"
  account_key_pem           = "${element(tls_private_key.private_key.*.private_key_pem, count.index)}"
  common_name               = "${element(var.domains, count.index)}"
  subject_alternative_names = "${var.subject_alternative_names[element(var.domains, count.index)]}"
  key_type                  = "${var.key_type}"

  dns_challenge {
    provider = "${var.provider}"
  }

  registration_url = "${element(acme_registration.reg.*.id, count.index)}"

  provisioner "local-exec" {
    command = "echo \"${self.private_key_pem}\" > ./certificates/${self.common_name}_privkey.pem && echo \"${self.certificate_pem}\" > ./certificates/${self.common_name}_cert.pem"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "rm ./certificates/${self.common_name}*"
  }
}