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
  config_path = "../../network"
}

terraform {
  source = "../../../../modules/storage_account"
}

inputs = {
    tags = merge(
      local.cfg.default_tags,
      { Environment = local.env_cfg.env }
    )

    name = "app${local.cfg.project}${local.env_cfg.env}"
    resource_group_name = local.env_cfg.resource_group_name
    location = local.cfg.location
    account_tier = "Standard"
    account_replication_type = "ZRS"
    large_file_share_enabled      = "false"
    public_network_access_enabled = "true" # public network access is enabled as for testing environment

    identity_type = "SystemAssigned"
    ignore_changes = "customer_managed_key"

    create_container = true
    container_name = "appblobstorage"
    storage_account_name = "app${local.cfg.project}${local.env_cfg.env}"
    container_access_type = "blob"

    ##### Network Rules #####
    create_network_rules = true
    default_action = "Deny"
    ip_rules = ["153.20.116.46"]
    subnet_ids = values(dependency.network.outputs.subnet_ids)
    bypass = ["Metrics"]
}