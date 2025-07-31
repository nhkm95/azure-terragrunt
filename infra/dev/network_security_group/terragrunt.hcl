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

dependency "network" {
  config_path = "../network"
  # mock_outputs = {
  #   subnet_ids = {
  #     "subnet-db" = "/mock/subnet/id" # Used for `terragrunt plan` when network hasn't been applied
  #   }
  # }
}

terraform {
  source = "../../../modules/network_security_group"
}

inputs = {
  location              = local.cfg.location
  resource_group_name   = local.env_cfg.resource_group_name
  tags = merge(
    local.cfg.default_tags,{
      Environment = local.env_cfg.env
    }
  )

  nsgs = {
    # "nsg-web" = {
    #   location              = local.cfg.location
    #   resource_group_name   = "rg-${local.cfg.project}-${local.env_cfg.env}"
    #   tags                  = local.cfg.default_tags
    #   create_inbound_rules  = true
    #   create_outbound_rules = false

    #   inbound_rules = [
    #     {
    #       name                       = "allow_https"
    #       priority                   = 100
    #       access                     = "Allow"
    #       protocol                   = "Tcp"
    #       source_address_prefix      = "*"
    #       destination_address_prefix = "*"
    #       source_port_range          = "*"
    #       destination_port_range     = "443"
    #       description                = "Allow HTTPS inbound"
    #     }
    #   ]
    # },
    "nsg-db" = {
      nsg_name              = "nsg-allow-mysql"
      location              = local.cfg.location
      resource_group_name   = local.env_cfg.resource_group_name
      tags = merge(
        local.cfg.default_tags,{
          Environment = local.env_cfg.env
        }
      )
      create_inbound_rules  = true
      create_outbound_rules = false

      inbound_rules = [
        {
          name                       = "AllowMySQL"
          priority                   = 100
          access                     = "Allow"
          protocol                   = "Tcp"
          source_address_prefix      = "10.0.2.0/24"
          destination_address_prefix = "10.0.4.0/24"
          source_port_range          = "*"
          destination_port_range     = "3306"
          description                = "Allow SQL inbound"
        }
      ]

      outbound_rules = []
    }
  }
   subnet_ids = {
    "nsg-db" = dependency.network.outputs.subnet_ids["subnet-db"]
  }
}
