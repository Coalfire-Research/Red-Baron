# filter

Creates a CloudFlare Worker Zone for managing a domain name. Prerequisite for any CF modules.

Note: Currently, there is no module for changing your domain name NS records to CloudFlare's. Usually CloudFlare instructs you to configure `angela.cloudflare.com` and `gannon.cloudflare.com` as authoritative nameservers for your domain. You will need to do this to use these modules.

# Example

```hcl
module "record" {
  source = "./modules/cloudflare/record_creation"
  my_domain_name = "DOMAINNAME"        //our frontend domain
  hostname = "www"         //the benign domain where non-agents, targets, should be redirected
  type = "A"
  server = "1.1.1.1"
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`my_domain_name`           | Yes      | String     | The domain that CloudFlare should handle
|`hostname`                 | Yes      | String     | Benign domain to send any unmatched requests
|`type`                     | Yes      | String     | Type of record (A, CNAME, etc.)
|`server`                   | Yes      | String     | The backend server this record points to
