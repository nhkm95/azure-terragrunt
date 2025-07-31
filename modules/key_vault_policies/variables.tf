variable "key_vault_id" {
  description = "ID of the Key Vault"
  type        = string
}

variable "access_policies" {
  description = "List of access policies to assign"
  type = list(object({
    tenant_id           = string
    object_id           = string
    key_permissions     = optional(list(string), [])
    secret_permissions  = optional(list(string), [])
    storage_permissions = optional(list(string), [])
  }))
}