# main.tf

locals {
  inbound_rules_flat = flatten([
    for nsg_key, nsg in var.nsgs : [
      for rule in nsg.inbound_rules : {
        key       = "${nsg_key}-${rule.name}"
        nsg_name  = nsg_key
        rule      = rule
        direction = "Inbound"
      }
    ] if nsg.create_inbound_rules
  ])

  outbound_rules_flat = flatten([
    for nsg_key, nsg in var.nsgs : [
      for rule in nsg.outbound_rules : {
        key       = "${nsg_key}-${rule.name}"
        nsg_name  = nsg_key
        rule      = rule
        direction = "Outbound"
      }
    ] if nsg.create_outbound_rules
  ])
}

resource "azurerm_network_security_group" "this" {
  for_each            = var.nsgs
  name                = each.value.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "inbound" {
  for_each = { for rule in local.inbound_rules_flat : rule.key => rule }

  name                        = each.value.rule.name
  resource_group_name         = var.resource_group_name
  # network_security_group_name = azurerm_network_security_group[each.value.nsg_name].name
  network_security_group_name = azurerm_network_security_group.this[each.value.nsg_name].name

  direction                   = each.value.direction
  access                      = each.value.rule.access
  priority                    = each.value.rule.priority
  protocol                    = each.value.rule.protocol
  source_address_prefix       = each.value.rule.source_address_prefix
  destination_address_prefix  = each.value.rule.destination_address_prefix
  source_port_range           = each.value.rule.source_port_range
  destination_port_range      = each.value.rule.destination_port_range
  description                 = each.value.rule.description
}

resource "azurerm_network_security_rule" "outbound" {
  for_each = { for rule in local.outbound_rules_flat : rule.key => rule }

  name                        = each.value.rule.name
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this[each.value.nsg_name].name
  direction                   = each.value.direction
  access                      = each.value.rule.access
  priority                    = each.value.rule.priority
  protocol                    = each.value.rule.protocol
  source_address_prefix       = each.value.rule.source_address_prefix
  destination_address_prefix  = each.value.rule.destination_address_prefix
  source_port_range           = each.value.rule.source_port_range
  destination_port_range      = each.value.rule.destination_port_range
  description                 = each.value.rule.description
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.subnet_ids

  subnet_id                 = each.value
  # network_security_group_id = azurerm_network_security_group[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id

}



# resource "azurerm_network_security_group" "this" {
#   name = var.nsg_name
#   location = var.location
#   resource_group_name = var.resource_group_name

#   tags = var.tags
# }

# resource "azurerm_network_security_rule" "inbound" {
#   # for_each = { for rule in var.inbound_rules : rule.name => rule }

#   for_each = var.create_inbound_rules ? { for rule in var.inbound_rules : rule.name => rule } : {}
#   resource_group_name = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.this.name
#   direction = "Inbound"
#   name = each.value.name
#   priority = each.value.priority
#   access = each.value.access
#   protocol = each.value.protocol

#   source_address_prefix = each.value.source_address_prefix
#   destination_address_prefix = each.value.destination_address_prefix
#   source_port_range = each.value.source_port_range
#   destination_port_range = each.value.destination_port_range
#   description = each.value.description
# }

# resource "azurerm_network_security_rule" "outbound" {
#   # for_each = { for rule in var.outbound_rules : rule.name => rule }

#   for_each = var.create_outbound_rules ? { for rule in var.outbound_rules : rule.name => rule } : {}
#   resource_group_name = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.this.name
#   direction = "Outbound"
#   name = each.value.name
#   priority = each.value.priority
#   access = each.value.access
#   protocol = each.value.protocol

#   source_address_prefix = each.value.source_address_prefix
#   destination_address_prefix = each.value.destination_address_prefix
#   source_port_range = each.value.source_port_range
#   destination_port_range = each.value.destination_port_range
#   description = each.value.description
# }

