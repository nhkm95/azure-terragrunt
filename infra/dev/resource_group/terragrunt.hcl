# live/dev/resource_group/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/resource_group"
}

locals {
  cfg = read_terragrunt_config(find_in_parent_folders()).locals
}

inputs = {
  name     = local.cfg.resource_group
  location = local.cfg.location
}
