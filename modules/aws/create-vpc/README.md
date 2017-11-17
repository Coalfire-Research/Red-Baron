# create-vpc

Creates a VPC, Subnet, Internet Gateway, Route Table and a Route Table association.

# Example

```hcl
module "create_a_record" {
  source = "./modules/aws/create-vpc"
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`subnet_id`                | String     | ID of created subnet
|`vpc_id`                   | String     | ID of created VPC

