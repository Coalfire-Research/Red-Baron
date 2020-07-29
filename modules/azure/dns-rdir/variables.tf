variable "resource_group_names" {
  type = list(string)
}

variable "primary_blob_endpoints" {
  type = list(string)
}

variable "storage_container_names" {
  type = list(string)
}

variable "locations" {
  type    = list(string)
  default = ["eastus2"]
}

variable "count_vm" {
  default = 1
}

variable "ansible_playbook" {
  default = ""
  description = "Ansible Playbook to run"
}

variable "ansible_arguments" {
  default = []
  type    = list(string)
  description = "Additional Ansible Arguments"
}

variable "ansible_vars" {
  default = []
  type    = list(string)
  description = "Environment variables"
}

variable "redirect_to" {
  type = list(string)
}

variable "username" {
  default = "c2user"
}

variable "install" {
  type    = list(string)
  default = []
}

variable "size" {
  default = "Standard_D2"
}
