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
}

terraform {
    source = "../../../modules/private_dns_zone"
}

inputs = {
    
    
    ### private dns zone ###
    dns_zone_name = local.env_cfg.db_dns_zone_name
    resource_group_name = local.env_cfg.resource_group_name

    ### private dns zone vnet link ###
    create_prv_vnet_link = true
    prv_vnet_link_name = local.env_cfg.db_prv_vnet_link_name
    vnet_id = dependency.network.outputs.id
}