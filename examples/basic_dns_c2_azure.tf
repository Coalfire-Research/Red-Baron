terraform {
  required_version = ">= 0.11.0"
}

module "resource_group" {
  source = "./modules/azure/create-resource-group"
}

module "storage_account" {
  source               = "./modules/azure/create-storage-account"
  resource_group_names = "${module.resource_group.resource_group_names}"
  locations            = "${module.resource_group.locations}"
}

module "dns_c2" {
  source                  = "./modules/azure/dns-c2"
  resource_group_names    = "${module.resource_group.resource_group_names}"
  locations               = "${module.resource_group.locations}"
  primary_blob_endpoints  = "${module.storage_account.primary_blob_endpoints}"
  storage_container_names = "${module.storage_account.storage_container_names}"
}

module "dns_rdir" {
  source                  = "./modules/azure/dns-rdir"
  redirect_to             = "${module.dns_c2.ips}"
  resource_group_names    = "${module.resource_group.resource_group_names}"
  locations               = "${module.resource_group.locations}"
  primary_blob_endpoints  = "${module.storage_account.primary_blob_endpoints}"
  storage_container_names = "${module.storage_account.storage_container_names}"
}
