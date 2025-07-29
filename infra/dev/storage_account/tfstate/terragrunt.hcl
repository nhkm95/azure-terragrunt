include {
  path = find_in_parent_folders()
}

# This assumes resource_group was already applied
dependency "rg" {
  config_path = "../../resource_group"
}

terraform {
  source = "../../../../modules/storage_account"
}

locals {
  cfg = read_terragrunt_config(find_in_parent_folders()).locals
}

inputs = {
  name                = local.cfg.storage_account # or local.cfg.storage_account_name if you set it
  location            = local.cfg.location
  resource_group_name = dependency.rg.outputs.name
  container_name      = local.cfg.container_name
  account_tier        = "Standard"
  replication_type    = "GRS"
  min_tls_version     = "TLS1_2"
}