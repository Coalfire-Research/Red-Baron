# http-c2

Creates an HTTP C2 server in Azure. SSH keys for each virtual machine will be outputted to the ssh_keys folder.

# Example

```hcl
module "http_c2" {
  source                  = "./modules/azure/http-c2"
  resource_group_names    = ["<Resource Group Names>"]
  primary_blob_endpoints  = ["<Primary Blob Endpoints>"]
  storage_container_names = ["<Storage Container Names>"]
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`count`                    | No       | Integer    | Number of VMs to launch. Defaults to 1.
|`resource_group_names`     | Yes      | List       | Names of the Resource Groups to create VMs under
|`storage_container_names`  | Yes      | List       | Names of the Storage Containers for VM hard drives
|`primary_blob_endpoints`   | Yes      | List       | Names of the Storage Endpoints for VM hard drives
|`size`                     | No       | String     | VM size to launch. Defaults to `Standard_D2`.
|`install`                  | No       | List       | Scripts to run on VM creation. Defaults to "./scripts/core_deps.sh".
|`locations`                | No       | List       | Locations to create VM(s) in. Defaults to `eastus2`. A list of available locations can be found on the [Azure Website](https://azure.microsoft.com/en-us/global-infrastructure/services/).
|`username`                 | No       | String     | Name of the user account to create. Defaults to `c2user`.

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`ips`                      | List       | IPs of created VMs.
