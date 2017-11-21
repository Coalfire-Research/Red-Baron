# http-c2

Creates a HTTP C2 server in AWS. SSH keys for each instance will be outputted to the ssh_keys folder.

# Example

```hcl
module "http_c2" {
  source = "./modules/aws/http-c2"

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
|`install`                  | No       | List       | Scripts to run on instance creation. Defaults to "./scripts/core_deps.sh".

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`ips`                      | List       | IPs of created instances.
