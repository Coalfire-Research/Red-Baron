# phishing-server

Creates an instance in AWS to be used as a phishing server. SSH keys for each instance will be outputted to the ssh_keys folder.

# Example

```hcl
module "phishing_server" {
  source = "./modules/aws/phishing-server"

  vpc_id = "<VPC ID>"
  subnet_id = "<Subnet ID>"
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`vpc_id`                   | Yes      | String     | ID of VPC to create instance in.
|`subnet_id`                | Yes      | String     | Subnet ID to create instance in.
|`count`                    | No       | Integer    | Number of instances to launch. Defaults to 1.
|`instance_type`            | No       | String     | Instance type to launch. Defaults to "t2.medium"

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`ips`                      | List       | IPs of created instances.
