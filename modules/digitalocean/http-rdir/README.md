# http-rdir

Creates a HTTP Redirector droplet in DigitalOcean. SSH keys for each droplet will be outputted to the ssh_keys folder.

# Example

```hcl
module "http_rdir" {
  source = "./modules/digitalocean/http-rdir"

  redirect_to = ["192.168.0.1"]
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`redirect_to`              | Yes      | List       | List of IPs to redirect HTTP traffic to.
|`count`                    | No       | Integer    | Number of droplets to launch. Defaults to `1`.
|`size`                     | No       | Integer    | Droplet size to launch. Defaults to `1gb`.
|`regions`                  | No       | List       | Regions to create Droplet(s) in. Defaults to `NYC1`. Accepted values are NYC1/2/3, SFO1/2, AMS2/3, SGP1, LON1, FRA1, TOR1, BLR1.

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`ips`                      | List       | IPs of created droplets.