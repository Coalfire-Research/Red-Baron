# create-cert-TLS

Creates a Let's Encrypt TLS certificate for the specfied domain using the TLS challenge.

This module currently does **not** work due to the terraform-acme third-party plugin implementation.

# Example

```hcl
module "create_certs" {
  source = "./modules/letsencrypt/create-cert-tls"

  domains = ["domain.com"]

  subject_alternative_names = {
    "domain.com" = ["www2.domain.com"]
  }
}
```