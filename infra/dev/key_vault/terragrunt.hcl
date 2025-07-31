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
  source = "../../../modules/key_vault"
}

inputs = {
    tags = merge(
      local.cfg.default_tags,
      { Environment = local.env_cfg.env }
    )

    vault_name                  = "vault-${local.cfg.project}-${local.env_cfg.env}"
    location                    = local.cfg.location
    resource_group_name         = local.env_cfg.resource_group_name
    soft_delete_retention_days  = 90    # value can be between 7 and 90 (the default) days   
}