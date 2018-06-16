provider "azure" {}

resource "random_id" "rand" {
  byte_length = 4
}

resource "azurerm_resource_group" "rg" {
  count    = "${var.count}"
  location = "${element(var.locations, count.index)}"
  name     = "${var.resource_group_name}-${count.index}-${random_id.rand.hex}"
}
