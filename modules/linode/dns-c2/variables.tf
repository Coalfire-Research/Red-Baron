variable "install" {
  type = "list"
  default = []
}

variable "count" {
  default = 1
}

variable "ansible_playbook" {
  default = ""
  description = "Ansible Playbook to run"
}

variable "ansible_arguments" {
  default = []
  type    = "list"
  description = "Additional Ansible Arguments"
}

variable "ansible_vars" {
  default = []
  type    = "list"
  description = "Environment variables"
}

variable "size" {
  default = 1024
}

variable "regions" {
  type = "list"
  default = ["NJ"]
}

variable "available_regions" {
  type = "map"
  default = {
    "NJ" = "Newark, NJ, USA"
    "CA" = "Freemont, CA, USA"
    "TX" = "Dallas, TX, USA"
    "GA" = "Atlanta, GA, USA"
    "UK" = "London, England, UK"
    "JP" = "Tokyo, JP"
    "JP2" = "Tokyo 2, JP"
    "SG" = "Singapore, SG"
    "DE" = "Frankfurt, DE"
  }
}

variable "group" {
  default = "Red Baron"
}