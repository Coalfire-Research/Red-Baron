variable "godaddy_key" {}
variable "godaddy_secret" {}

variable domain {}
variable ip_address {}
variable nameservers {
  default = ["ns11.domaincontrol.com", "ns12.domaincontrol.com"]
}