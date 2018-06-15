# create-storage-account

Creates a Storage Account and Storage Container in Azure.

# Example

```hcl
module "storage_accounts" {
  source               = "./modules/azure/create-storage-account"
  resource_group_names = ["<Resource Group Names>"]
}
```

# Arguments
| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`count`                    | No       | Integer    | Number of VMs to launch. Defaults to 1.
|`resource_group_names`     | Yes      | List       | Names of the Resource Groups to create storage acounts under.
|`locations`                | No       | List       | Locations to create Storage Accounts in. Defaults to `eastus2`. A list of available locations can be found on the [Azure Website](https://azure.microsoft.com/en-us/global-infrastructure/services/).

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`primary_blob_endpoints`    | List       | List of primary blob endpoints
|`storage_container_names`   | List       | List of storage container names