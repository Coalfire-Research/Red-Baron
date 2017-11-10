// Create the private key for the registration (not the certificate)
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

// Set up a registration using a private key from tls_private_key
resource "acme_registration" "reg" {
  server_url      = "https://acme-staging.api.letsencrypt.org/directory"
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "${var.reg_email}"
}

// Create a certificate
resource "acme_certificate" "certificate" {
  server_url                = "https://acme-staging.api.letsencrypt.org/directory"
  account_key_pem           = "${tls_private_key.private_key.private_key_pem}"
  common_name               = "${var.domain}"
  subject_alternative_names = "${var.subject_alternative_names}"


  // The docs say GoDaddy is a supported DNS provider but TF agrees to disagree.
  // Gonna have to figure out a way to either use the HTTP/TLS challenge or just hack the provider itself and add support for GoDaddy
/*
  dns_challenge {
    provider = "godaddy"
    config {
      GODADDY_API_KEY = "${var.godaddy_key}"
      GODADDY_API_SECRET = "${var.godaddy_secret}"
    }
  }
*/

  http_challenge_port = 8080
  tls_challenge_port = 8443 

  registration_url = "${acme_registration.reg.id}"
}