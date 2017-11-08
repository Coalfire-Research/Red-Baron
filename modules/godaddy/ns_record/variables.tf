variable domain {}
variable ip_address {}
variable nameservers {
  default = ["ns11.domaincontrol.com", "ns12.domaincontrol.com"]
}
variable ns_record_name {
  default = "dns"
}
variable a_record_name {
  default = "ns1"
}