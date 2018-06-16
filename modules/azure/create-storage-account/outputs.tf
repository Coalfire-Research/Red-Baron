output "primary_blob_endpoints" {
  value = "${azurerm_storage_account.sa.*.primary_blob_endpoint}"
}

output "storage_container_names" {
  value = "${azurerm_storage_container.sc.*.name}"
}
