terraform {
  required_version = ">= 0.11.0"
}

module "resource_group" {
  source = "./modules/azure/create-resource-group"
  count  = 2
}

module "storage_account" {
  source               = "./modules/azure/create-storage-account"
  resource_group_names = "${module.resource_group.resource_group_names}"
  locations            = "${module.resource_group.locations}"
  count                = 2
}

module "http_c2" {
  source                  = "./modules/azure/http-c2"
  resource_group_names    = "${module.resource_group.resource_group_names}"
  locations               = "${module.resource_group.locations}"
  primary_blob_endpoints  = "${module.storage_account.primary_blob_endpoints}"
  storage_container_names = "${module.storage_account.storage_container_names}"

  // 1 http C2 ha. ha. ha... 2 http C2s ha. ha. ha... 3 http C2s ha. ha. ha...
  //count = 2

  // Wanna install empire?
  //install = ["./scripts/empire.sh"]

  // Wanna install metasploit?
  //install = ["./scripts/metasploit.sh"]

  // Wanna install CS?
  //install = ["./scripts/cobaltstrike.sh"]

  // I WANT EVERYTHING
  //install = ["./scripts/empire.sh", "./scripts/metasploit.sh", "./scripts/cobaltstrike.sh"]
}

module "http_rdir" {
  source                  = "./modules/azure/http-rdir"
  redirect_to             = "${module.http_c2.ips}"
  resource_group_names    = "${module.resource_group.resource_group_names}"
  locations               = "${module.resource_group.locations}"
  primary_blob_endpoints  = "${module.storage_account.primary_blob_endpoints}"
  storage_container_names = "${module.storage_account.storage_container_names}"
  count                   = 2
}
