# http-rdir

Creates a HTTP Redirector server in AWS. SSH keys for each instance will be outputted to the ssh_keys folder.

# Example

```hcl
module "http_rdir" {
  source = "./modules/aws/http-rdir"

  vpc_id    = "<VPC ID>"
  subnet_id = "<Subnet ID>"
  redirect_to = ["192.168.0.1"]
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`vpc_id`                   | Yes      | String     | ID of VPC to create instance in.
|`subnet_id`                | Yes      | String     | Subnet ID to create instance in.
|`redirect_to`              | Yes      | List       | List of IPs to redirect HTTP traffic to.
|`count`                    | No       | Integer    | Number of instances to launch. Defaults to 1.
|`instance_type`            | No       | String     | Instance type to launch. Defaults to "t2.medium".

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`ips`                      | List       | IPs of created instances.
