variable "count" {
  default = 1
}

variable "resource_group_names" {
  type = "list"
}

variable "locations" {
  type    = "list"
  default = ["eastus2"]
}
