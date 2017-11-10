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