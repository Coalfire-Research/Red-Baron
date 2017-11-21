# phishing-server

Creates an instance in Linode to be used as a phishing server. SSH keys for each instance will be outputted to the ssh_keys folder.

# Example

```hcl
module "phishing_server" {
  source = "./modules/linode/phishing-server"
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`count`                    | No       | Integer    | Number of instances to launch. Defaults to 1.
|`size`                     | No       | Integer    | Linode size to launch. Defaults to 1024.
|`regions`                  | No       | List       | Regions to create Linode(s) in. Defaults to NJ. Accepted values are NJ, CA, TX, GA, UK, JP, JP2, SG and DE.
|`group`                    | No       | String     | Group name for created Linode(s). Defaults to "Red Baron"

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`ips`                      | List       | IPs of created instances.
