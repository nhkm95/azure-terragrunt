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
  source = "../../../modules/key_vault_policies"
}

inputs = {
    key_vault_id = dependency.kv.outputs.id

    access_policies = [
        {
            tenant_id = "626abcfe-3ee1-44bc-b0ad-1e36b7c66efd" # current terraform user
            object_id = "0026ec62-ee80-4b34-830f-8d6d3e5e0ea8" # current terraform user
            
            key_permissions = [
                "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore",
                "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge",
                "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"
            ]

            secret_permissions = [
                "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
            ]

            storage_permissions = [
                "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge",
                "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"
            ]
        },
        {
            tenant_id = dependency.uai.outputs.tenant_id
            object_id = dependency.uai.outputs.principal_id

            key_permissions = [
                "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore",
                "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge",
                "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"
            ]

            secret_permissions = [
                "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
            ]

            storage_permissions = [
                "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge",
                "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"
            ]
        },
        {
            tenant_id = "626abcfe-3ee1-44bc-b0ad-1e36b7c66efd" # current terraform user
            object_id = dependency.storage.outputs.principal_id # Principal ID for the Service Principal associated with Identity of Storage Account

            secret_permissions = [
                "Get"
            ]

            key_permissions = [
                "Get", "Create", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"
            ]
        }
    ]
}


# resource "azurerm_key_vault_access_policy" "storage" {
#   key_vault_id = azurerm_key_vault.key.id
#   tenant_id = data.azurerm_client_config.current.tenant_id
#   object_id = azurerm_storage_account.project.identity.0.principal_id # Principal ID for the Service Principal associated with Identity of Storage Account

#   secret_permissions = ["Get"]
#   key_permissions    = ["Get", "Create", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"]
# }
/*
  for_each    = { for policy in var.access_policies : "${policy.object_id}" => policy }

  key_vault_id = var.key_vault_id
  tenant_id    = each.value.tenant_id
  object_id    = each.value.object_id

  key_permissions     = each.value.key_permissions
  secret_permissions  = each.value.secret_permissions
  storage_permissions = each.value.storage_permissions
*/