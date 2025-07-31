# key_vault.tf
# Key Vault
resource "azurerm_key_vault" "this" {
  name                        = var.vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days    # value can be between 7 and 90 (the default) days
  purge_protection_enabled    = var.purge_protection_enabled  # Once Purge Protection has been enabled it's not possible to disable it
  sku_name = var.sku_name # refer to pricing tier, possible values are standard and premium

  tags = var.tags
}

data "azurerm_client_config" "current" {}