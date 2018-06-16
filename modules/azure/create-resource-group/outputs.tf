output "resource_group_names" {
  value = "${azurerm_resource_group.rg.*.name}"
}

output "locations" {
  value = "${azurerm_resource_group.rg.*.location}"
}
