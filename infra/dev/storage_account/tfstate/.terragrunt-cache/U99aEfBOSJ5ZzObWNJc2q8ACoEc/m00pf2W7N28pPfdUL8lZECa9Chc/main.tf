terraform {

}

resource "azurerm_storage_account" "this" {
  name                     = var.name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  min_tls_version          = var.min_tls_version

  tags = var.tags

}

resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_id  = azurerm_storage_account.this.id
  container_access_type = var.container_access_type
}