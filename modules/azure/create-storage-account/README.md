# create-storage-account

Creates a Storage Account and Storage Container in Azure.

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
|`resource_group_names`     | Yes      | List       | Names of the Resource Groups to create VMs under.
|`locations`                | No       | List       | Locations to create VM(s) in. Defaults to `eastus2`. A list of available locations can be found on the [Azure Website](https://azure.microsoft.com/en-us/global-infrastructure/services/).

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`primary_blob_endpoints`    | List       | List of primary blob endpoints
|`storage_container_names`   | List       | List of storage container names