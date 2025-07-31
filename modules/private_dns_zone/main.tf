resource "azurerm_private_dns_zone" "this" {
    name                = var.dns_zone_name
    resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
    count                   = var.create_prv_vnet_link ? 1 : 0
    name                    = var.prv_vnet_link_name
    private_dns_zone_name   = var.dns_zone_name
    resource_group_name     = var.resource_group_name
    virtual_network_id      = var.vnet_id
}