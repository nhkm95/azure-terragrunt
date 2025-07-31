resource "azurerm_storage_account" "this" {
  name                     = var.name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  min_tls_version          = var.min_tls_version
  large_file_share_enabled      = var.large_file_share_enabled
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "identity" {
    for_each = var.identity_type == "None" ? [] : [1]
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? var.identity_ids : null
    }
  }

  lifecycle {
    ignore_changes = [
      customer_managed_key, queue_properties, static_website
    ]
  }

  tags = var.tags
}

resource "azurerm_storage_container" "this" {
  count                 = var.create_container ? 1 : 0
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = var.container_access_type
}

resource "azurerm_storage_account_network_rules" "this" {
  count                      = var.create_network_rules ? 1 : 0
  storage_account_id         = azurerm_storage_account.this.id
  default_action             = var.default_action
  ip_rules                   = var.ip_rules # edit value to your home IP or whitelisted ip
  virtual_network_subnet_ids = var.subnet_ids # subnet ids to secure the storage account
  bypass                     = var.bypass
}