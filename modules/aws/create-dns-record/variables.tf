variable "domain" {}

variable "type" {}

variable "count" {
  default = 1
}

variable "ttl" {
  default = 300
}

variable "records" {
  type = "map"
}