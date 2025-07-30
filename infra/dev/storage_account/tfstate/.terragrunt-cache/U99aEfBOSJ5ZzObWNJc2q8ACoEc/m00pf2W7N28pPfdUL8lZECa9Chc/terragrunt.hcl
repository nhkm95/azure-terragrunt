# File: infra/dev/resource_group/terragrunt.hcl
include "backend" {
  path = find_in_parent_folders("include_backend.hcl")
}

locals {
  cfg      = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl")).locals
  env_cfg  = read_terragrunt_config("${get_terragrunt_dir()}/../../env.hcl").locals
}

dependency "rg" {
  config_path = "../../resource_group"
}

terraform {
  source = "../../../../modules/storage_account"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features        {}
  subscription_id = "${local.env_cfg.subscription_id}"
}
EOF
}

inputs = {
  name     = local.env_cfg.storage_account_name
  location = local.cfg.location
  resource_group_name = dependency.rg.outputs.name
  container_name = local.env_cfg.container_name
  account_tier = "Standard"
  replication_type = "GRS"
  min_tls_version = "TLS1_2"
  tags     = merge(
    local.cfg.default_tags,
    { Environment = local.env_cfg.env
      Test-Variable = "hardcoded var" }
  )
}


/*
  name                     = var.name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  min_tls_version          = var.min_tls_version
*/