# create-dns-record

Adds records to a domain using DigitalOcean

# Example

```hcl
module "create_a_record" {
  source = "./modules/digitalocean/create-dns-record"

  domain = "domain.com"
  type = "A"
  records = {
    "domain.com" = "192.168.0.1"
    "test.domain.com" = "192.168.0.2"
  }
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`domain`                   | Yes      | String     | The domain to add records to
|`type`                     | Yes      | String     | The record type to add. Valid values are A, AAAA, CAA, CNAME, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT.
|`records`                  | Yes      | Map        | A map of records to add. Domains as keys and IPs as values.
|`count`                    | No       | Integer    | Number of records to add. Default value is 1
|`ttl`                      | No       | Integer    | The TTL of the record(s). Default value is 300

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`records`                  | Map        | Map containing the records added to the domain. Domains as keys and IPs as values.

