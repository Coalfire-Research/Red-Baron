# smtp

Configures AWS SES to send e-mails via SMTP. Handles SPF and DKIM configuration.

# Example

```hcl
module "zone" {
    source = "./modules/aws/create-hosted-zone"
    domain = "example.com"
}

module "mail" {
    source = "./modules/aws/smtp"
    domain = "example.com"
    mx_subdomain = "mail"
    zone_id = "${module.zone.zone_id}"
}

output "smtp_name_servers" {
    value = ["${module.zone.name_servers}"]
}

output "smtp_server" {
    value = "${module.smtp.smtp_server}"
}

output "smtp_user" {
    value = "${module.smtp.smtp_username}"
}

output "smtp_password" {
    value = "${module.smtp.smtp_password}"
}
```

Note: Once the AWS name servers have been set in the domain registrar configuration, it can
take up to 72 for Amazon to verify the SES domain. Once the domain is verified, a service
limit increase request must be done to disable the SES sandbox and be able to send e-mails
to unverified recipients, this process is documented in the [AWS SES sandbox documentation](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/request-production-access.html).

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`zone_id`                  | Yes      | String     | Zone in which the DNS records should be created.
|`domain`                   | Yes      | String     | Sender domain name.
|`mx_subdomain`             | No       | String     | MX record subdomain (default: mx).

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`smtp_server`              | String     | Hostname of the SMTP server to use for sending e-mails.
|`smtp_username`            | String     | User name to connect to the SMTP server.
|`smtp_password`            | String     | Password to connect to the SMTP server.
