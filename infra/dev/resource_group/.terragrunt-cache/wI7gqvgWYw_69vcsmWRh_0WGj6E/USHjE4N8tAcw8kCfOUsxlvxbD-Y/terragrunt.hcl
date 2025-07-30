# File: infra/dev/resource_group/terragrunt.hcl
include "backend" {
  path = find_in_parent_folders("include_backend.hcl")
}

locals {
  cfg      = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl")).locals
  env_cfg  = read_terragrunt_config("${get_terragrunt_dir()}/../env.hcl").locals
}

terraform {
  source = "../../../modules/resource_group"
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
  name     = "rg-${local.cfg.project}-${local.env_cfg.env}"
  location = local.cfg.location
  tags     = merge(
    local.cfg.default_tags,
    { Environment = local.env_cfg.env
      Test-Variable = "hardcoded var" }
  )
}

