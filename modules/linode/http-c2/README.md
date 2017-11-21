# http-c2

Creates a HTTP C2 server in Linode. SSH keys for each instance will be outputted to the ssh_keys folder.

# Example

```hcl
module "http_c2" {
  source = "./modules/linode/http-c2"
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`count`                    | No       | Integer    | Number of instances to launch. Defaults to 1.
|`size`                     | No       | Integer    | Linode size to launch. Defaults to 1024.
|`install`                  | No       | List       | Scripts to run on instance creation. Defaults to "./scripts/core_deps.sh".
|`regions`                  | No       | List       | Regions to create Linode(s) in. Defaults to NJ. Accepted values are NJ, CA, TX, GA, UK, JP, JP2, SG and DE.
|`group`                    | No       | String     | Group name for created Linode(s). Defaults to "Red Baron"

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`ips`                      | List       | IPs of created instances.
