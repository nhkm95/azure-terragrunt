locals {
  env                = "dev"
  location           = "southeastasia"
  subscription_id    = "d7079090-d7fe-4e89-b4aa-68181f4a241f"
  resource_group     = "rg-${local.env}-core"
  storage_account    = "nhbstfstate${local.env}"
  container_name     = "tfstate"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "azurerm" {
  features  {}
  subscription_id = "${local.subscription_id}"
}
EOF
}

# generate "backend" {
#   path      = "backend.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "${local.resource_group}"
#     storage_account_name = "${local.storage_account}"
#     container_name       = "${local.container_name}"
#     key                  = "${local.env}/${path_relative_to_include()}/terraform.tfstate"
#   }
# }
# EOF
# }