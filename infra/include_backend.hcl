locals {
  cfg      = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl")).locals 
  env_cfg = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-${local.cfg.project}-${local.env_cfg.env}"
    storage_account_name = "${local.env_cfg.storage_account_name}"
    container_name       = "${local.env_cfg.container_name}"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}
EOF
}