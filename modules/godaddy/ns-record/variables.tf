variable "count" {
  default = 1
}

variable "domains" {
  type = "list"
}

variable "data" {
  type = "list"
}

variable ns_record_name {
  default = "dns"
}

variable a_record_name {
  default = "ns1"
}

variable "nameservers" {
  type = "list"
  default = ["ns11.domaincontrol.com", "ns12.domaincontrol.com"]
}