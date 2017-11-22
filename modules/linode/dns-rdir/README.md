# dns-rdir

Creates a DNS Redirector server in Linode. SSH keys for each instance will be outputted to the ssh_keys folder.

# Example

```hcl
module "dns_rdir" {
  source = "./modules/linode/dns-rdir"

  redirect_to = ["192.168.0.1"]
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`redirect_to`              | Yes      | List       | List of IPs to redirect DNS traffic to.
|`count`                    | No       | Integer    | Number of instances to launch. Defaults to 1.
|`size`                     | No       | Integer    | Linode size to launch. Defaults to 1024.
|`regions`                  | No       | List       | Regions to create Linode(s) in. Defaults to NJ. Accepted values are NJ, CA, TX, GA, UK, JP, JP2, SG and DE.
|`group`                    | No       | String     | Group name for created Linode(s). Defaults to "Red Baron"

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`ips`                      | List       | IPs of created instances.
