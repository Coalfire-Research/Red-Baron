# filter

Creates a CloudFlare Worker Zone for managing a domain name. Prerequisite for any CF modules.

Note: Currently, there is no module for changing your domain name NS records to CloudFlare's. Usually CloudFlare instructs you to configure `angela.cloudflare.com` and `gannon.cloudflare.com` as authoritative nameservers for your domain. You will need to do this to use these modules.

# Example

```hcl
module "zone" {
  source = "./modules/cloudflare/zone_creation"
  my_domain_name = "DOMAINNAME"        //our frontend domain
  benign_domain = "google.com"         //the benign domain where non-agents, targets, should be redirected
  a_record = "www"
  //you'll need this: ${module.zone.zone_id}
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`my_domain_name`           | Yes      | String     | The domain that CloudFlare should handle
|`benign_domain`            | Yes      | String     | Benign domain to send any unmatched requests
|`cname_record`             | No       | String     | Override additional CNAME record entry that should be added, defaults to `www`
