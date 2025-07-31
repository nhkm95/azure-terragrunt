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

dependency "kv" {
    config_path = "../key_vault"
}

dependency "uai" {
    config_path = "../user_assigned_identity"
}

dependency "storage" {
    config_path = "../storage_account/app"
}

terraform {
  source = "../../../modules/keys"
}

inputs = {
    tags = merge(
        local.cfg.default_tags,
        { Environment = local.env_cfg.env }
    )

    key_vault_id = dependency.kv.outputs.id
    keys = {
        "db" = {
            name = "key-db-${local.cfg.project}-${local.env_cfg.env}"
            key_type = "RSA"
            key_size = 2048
            key_opts = [
                "decrypt",
                "encrypt",
                "sign",
                "unwrapKey",
                "verify",
                "wrapKey",
            ]

            rotation = {
                automatic =  {
                    time_before_expiry = "P30D"
                }
                expire_after = "P3Y"
                notify_before_expiry = "P29D"
            }
        },
      "storage" = {
            name = "key-storage-${local.cfg.project}-${local.env_cfg.env}"
            key_type = "RSA"
            key_size = 2048
            key_opts = [
                "decrypt",
                "encrypt",
                "sign",
                "unwrapKey",
                "verify",
                "wrapKey",
            ]

            rotation = {
                automatic =  {
                    time_before_expiry = "P30D"
                }
                expire_after = "P3Y"
                notify_before_expiry = "P29D"
            }        
      }
    }

    create_cmk = true
    storage_account_id = dependency.storage.outputs.id
    key_vault_id = dependency.kv.outputs.id
    key_name = "key-storage-${local.cfg.project}-${local.env_cfg.env}"
}