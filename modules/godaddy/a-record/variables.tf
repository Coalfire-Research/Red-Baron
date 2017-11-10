variable "count" {
  default = 1
}

variable "domains" {
  type = "list"
}

variable "data" {
  type = "list"
}

variable "nameservers" {
  type = "list"
  default = ["ns11.domaincontrol.com", "ns12.domaincontrol.com"]
}