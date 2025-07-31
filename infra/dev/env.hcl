locals {
  env             = "dev"
  subscription_id = get_env("subscription_id", "00000000-0000-0000-0000-000000000000")
  storage_account_name = "nhbstfstatestorage"
  container_name = "tfstate"
  vnet_name = "vnet-dev"
  vnet_address_space = ["10.0.0.0/16"]
  db_subnet_cidr = ["10.0.4.0/24"]
  storage_subnet_cidr = ["10.0.3.0/24"]
  node_subnet_cidr = ["10.0.1.0/24"]
  service_endpoints = ["Microsoft.Storage"]
  nsg_name_mysql = "nsg-MySQL"
}