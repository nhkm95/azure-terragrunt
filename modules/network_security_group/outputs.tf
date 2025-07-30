output "ids" {
  value = { for key, nsg in azurerm_network_security_group.this : key => nsg.id }
}
