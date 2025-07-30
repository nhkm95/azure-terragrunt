include "backend" {
  path = find_in_parent_folders("include_backend.hcl")
}

locals {
  cfg      = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl")).locals
  env_cfg  = read_terragrunt_config("${get_terragrunt_dir()}/../env.hcl").locals
}

terraform {
  source = "../../../modules/network_security_group"
}

dependency "rg" {
  config_path = "../resource_group"
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    subnet_ids = {
      "subnet-db" = "/mock/subnet/id" # Used for `terragrunt plan` when network hasn't been applied
    }
  }
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
  location              = local.cfg.location
  resource_group_name   = dependency.rg.outputs.name
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
      resource_group_name   = dependency.rg.outputs.name
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
