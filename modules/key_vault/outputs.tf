output "id" {
  value = azurerm_key_vault.this.id
}

# output "id" {
#   value = {
#     for name, vault in azurerm_key_vault.this :
#     name => vault.id
#   }
# }