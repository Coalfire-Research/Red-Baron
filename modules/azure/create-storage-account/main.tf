resource "random_id" "rand" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    storage_account = "${var.resource_group_names[count.index]}"
  }

  byte_length = 6
}

resource "azurerm_storage_account" "sa" {
  count                    = "${var.count}"
  name                     = "redbaron${count.index}${random_id.rand.hex}"
  resource_group_name      = "${var.resource_group_names[count.index]}"
  location                 = "${var.locations[count.index]}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc" {
  count                 = "${var.count}"
  name                  = "vhds"
  storage_account_name  = "${element(azurerm_storage_account.sa.*.name, count.index)}"
  resource_group_name   = "${var.resource_group_names[count.index]}"
  container_access_type = "private"
}
