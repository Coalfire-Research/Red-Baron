variable "count_vm" {
  default = 1
}

variable "resource_group_names" {
  type = list(string)
}

variable "locations" {
  type    = list(string)
  default = ["eastus2"]
}
