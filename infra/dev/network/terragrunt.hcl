include "root" {
  path = find_in_parent_folders("common.hcl")
}

include "env" {
  path = find_in_parent_folders("env.hcl")
}

locals {
  cfg      = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
  env_cfg  = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "../../../modules/network"
}

inputs = {
  location            = local.cfg.location
  vnet_name           = "vnet-${local.cfg.project}-${local.env_cfg.env}"
  resource_group_name = local.env_cfg.resource_group_name
  vnet_address_space  = local.env_cfg.vnet_address_space

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
            name    = "Microsoft.ContainerInstance/containerGroups"
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
      address_prefixes  = local.env_cfg.node_subnet_cidr
      service_endpoints = local.env_cfg.service_endpoints
    }
  }
}