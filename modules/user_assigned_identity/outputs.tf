output "tenant_id" {
    value = azurerm_user_assigned_identity.this.tenant_id
}

output "principal_id" {
    value = azurerm_user_assigned_identity.this.principal_id
}