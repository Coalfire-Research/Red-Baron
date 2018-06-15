# create-resource-group

Creates a Resource Group in Azure.

# Example

```hcl
module "resource_group" {
  source = "./modules/azure/create-resource-group"
}
```

# Arguments
| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`count`                    | No       | Integer    | Number of VMs to launch. Defaults to 1.
|`resource_group_names`     | No       | List       | Names of the Resource Groups to create. Defaults to `redbaron`
|`locations`                | No       | List       | Locations to create Resource Groups in. Defaults to `eastus2`. A list of available locations can be found on the [Azure Website](https://azure.microsoft.com/en-us/global-infrastructure/services/).

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`resource_group_names`     | List       | List of Resource Group Names
|`locations`                | List       | List of Locations

