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
  source = "../../../modules/user_assigned_identity"
}

inputs = {
    name = "standalone-uai-${local.cfg.project}-${local.env_cfg.env}"
    resource_group_name = local.env_cfg.resource_group_name
    location = local.cfg.location

    tags = merge(
      local.cfg.default_tags,
      { Environment = local.env_cfg.env }
    )
}