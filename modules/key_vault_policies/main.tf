# Access Policy for yourself
resource "azurerm_key_vault_access_policy" "this" {
  for_each = { for policy in var.access_policies : "${policy.object_id}" => policy }

  key_vault_id         = var.key_vault_id
  tenant_id            = each.value.tenant_id
  object_id            = each.value.object_id
  key_permissions      = each.value.key_permissions
  secret_permissions   = each.value.secret_permissions
  storage_permissions  = each.value.storage_permissions
}

data "azurerm_client_config" "current" {}