variable "count_vm" {
  default = 1
}

variable "resource_group_name" {
  type    = "string"
  default = "redbaron"
}

variable "locations" {
  type    = list(string)
  default = ["eastus2"]
}
