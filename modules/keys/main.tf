# Key
resource "azurerm_key_vault_key" "this" {
  for_each     = var.keys
  name         = each.value.name
  key_vault_id = var.key_vault_id
  key_type     = each.value.key_type
  key_size     = each.value.key_size
  key_opts     = each.value.key_opts

  rotation_policy {
    automatic {
      time_before_expiry = each.value.rotation.automatic.time_before_expiry
    }

    expire_after         = each.value.rotation.expire_after
    notify_before_expiry = each.value.rotation.notify_before_expiry
  }

  tags = var.tags
}

resource "azurerm_storage_account_customer_managed_key" "this" {
  count                      = var.create_cmk ? 1 : 0
  storage_account_id         = var.storage_account_id
  key_vault_id               = var.key_vault_id
  key_name                   = var.key_name
}