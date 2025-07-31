output "subnet_ids" {
  value = {
    for name, subnet in azurerm_subnet.this :
    name => subnet.id
  }
}

output "id" {
  value = azurerm_virtual_network.this.id
}