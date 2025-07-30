locals {
  location        = "southeastasia"
  project         = "nhbs"
  terragrunt_version = "0.83.2"

  default_tags = {
    Project     = local.project
    ManagedBy   = "Terragrunt v${local.terragrunt_version}"
  }
}


## Comment out for local state file generation ###
# generate "backend" {
#   path      = "backend.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "rg-${local.env}-core"
#     storage_account_name = "nhbstfstate${local.env}"
#     container_name       = "${local.container_name}"
#     key                  = "${local.env}/${path_relative_to_include()}/terraform.tfstate"
#   }
# }
# EOF
# }