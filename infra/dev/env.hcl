locals {
  cfg      = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals

  env               = "dev"
  storage_account_name = "nhbstfstatestorage"
  vnet_address_space = ["10.0.0.0/16"]
  db_subnet_cidr = ["10.0.4.0/24"]
  storage_subnet_cidr = ["10.0.3.0/24"]
  node_subnet_cidr = ["10.0.1.0/24"]
  service_endpoints = ["Microsoft.Storage"]
  nsg_name_mysql = "nsg-MySQL"
  resource_group_name  = "rg-nhbs-dev"
  storage_account_tfstate = "nhbstfstatedev"
  tfstate_container       = "tfstate"
  db_dns_zone_name = "${local.cfg.project}.dev.mysql.database.azure.com"
  db_prv_vnet_link_name = "${local.cfg.project}-dev.com"
}

remote_state {
  backend = "azurerm"
  
  config = {
    resource_group_name  = local.resource_group_name
    storage_account_name = local.storage_account_tfstate
    container_name       = local.tfstate_container
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
  
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
  subscription_id = "${get_env("subscription_id", "00000000-0000-0000-0000-000000000000")}"
}
terraform {
  required_providers {
    azurerm = {

    }
  }
}
EOF
}