variable "root_password" {}

variable "ssh_private_key" {
  default = "./ssh_keys/dns_rdir"
}

variable "ssh_public_key" {
  default = "./ssh_keys/dns_rdir.pub"
}

variable "dns_c2_ips" {
  type = "list"
}

variable "count" {
  default = 1
}

variable "size" {
  default = 1024
}

variable "region" {
  default = "Newark, NJ, USA"
}

variable "group" {
  default = "Red Baron"
}