# dns-c2

Creates a DNS C2 server in DigitalOcean. SSH keys for each droplet will be outputted to the ssh_keys folder.

# Example

```hcl
module "dns_c2" {
  source = "./modules/digitalocean/dns-c2"
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`count`                    | No       | Integer    | Number of droplets to launch. Defaults to 1.
|`size`                     | No       | Integer    | Droplet size to launch. Defaults to `1gb`.
|`install`                  | No       | List       | Scripts to run on droplet creation. Defaults to "./scripts/core_deps.sh".
|`regions`                  | No       | List       | Regions to create Droplet(s) in. Defaults to `NYC1`. Accepted values are NYC1/2/3, SFO1/2, AMS2/3, SGP1, LON1, FRA1, TOR1, BLR1.

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`ips`                      | List       | IPs of created droplets.