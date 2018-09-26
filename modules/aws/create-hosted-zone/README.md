# create-hosted-zone

Creates a hosted zone for a domain in AWS Route53.

# Example

```hcl
module "create_hosted_zone" {
  source = "./modules/aws/create-hosted-zone"
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`domain`                   | Yes      | String     | The domain to create a hosted zone for.

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`zone_id`                  | String     | The created hosted zone ID.
|`name_servers`             | Array      | The name servers for this zone.
