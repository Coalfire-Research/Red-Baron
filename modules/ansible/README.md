# ansible

Runs an ansible playbook on a specific resource

# Example

```hcl
module "ansible" {
  source    = "./modules/ansible"

  user      = "${http_c2.ssh_user}"
  ip        = "${http_c2.ips[0]}"
  playbook  = "/path/to/playbook.yml"
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`user`                     | Yes      | String     | User to authenticate as over SSH
|`ip`                       | Yes      | String     | Host to run playbook on
|`playbook`                 | Yes      | String     | Playbook to run
|`arguments`                | No       | List       | Additional Ansible arguments
|`envs`                     | No       | List       | Environment variable to pass to Ansible


# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`arguments`                | List       | Additional Ansible arguments
|`envs`                     | List       | Environment variable to pass to Ansible


# Credits

Most of the code for this module was stolen from https://github.com/cloudposse/terraform-null-ansible
