output "ips" {
  value = ["${azurerm_public_ip.pip.*.ip_address}"]
}

output "ssh_user" {
  value = "${var.username}"
}