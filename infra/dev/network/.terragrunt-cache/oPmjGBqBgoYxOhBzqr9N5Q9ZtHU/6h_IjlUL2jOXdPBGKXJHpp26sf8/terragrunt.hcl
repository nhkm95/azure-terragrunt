include "backend" {
  path = find_in_parent_folders("include_backend.hcl")
}

locals {
  cfg      = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl")).locals
  env_cfg  = read_terragrunt_config("${get_terragrunt_dir()}/../env.hcl").locals
}

terraform {
  source = "../../../modules/network"
}

dependency "rg" {
  config_path = "../resource_group"
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
  vnet_name          = local.env_cfg.vnet_name
  location           = local.cfg.location
  resource_group_name = dependency.rg.outputs.name
  vnet_address_space = local.env_cfg.vnet_address_space

  tags = merge(
    local.cfg.default_tags,
    { Environment = local.env_cfg.env }
  )

  subnets = {
    "subnet-db" = {
      address_prefixes  = local.env_cfg.db_subnet_cidr
      service_endpoints = local.env_cfg.service_endpoints

      delegation = [
        {
            name = "delegation"
            service_delegation = {
                name = "Microsoft.ContainerInstance/containerGroups"
                actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
        }
      ]
    }
    "subnet-storage" = {
      address_prefixes  = local.env_cfg.storage_subnet_cidr
      service_endpoints = local.env_cfg.service_endpoints
    }
    "subnet-node" = {
      address_prefixes = local.env_cfg.node_subnet_cidr
      service_endpoints = local.env_cfg.service_endpoints
    }
  }
}
