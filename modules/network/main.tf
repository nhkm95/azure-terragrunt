resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
}

resource "azurerm_subnet" "this" {
    
    for_each = var.subnets

    name                 = each.key
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.this.name
    address_prefixes     = each.value.address_prefixes
    service_endpoints    = try(each.value.service_endpoints, null)

  dynamic "delegation" {
    for_each = try(each.value.delegatio, [])
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }    
}