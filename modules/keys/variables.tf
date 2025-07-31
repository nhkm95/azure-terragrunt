variable "key_vault_id" {
  description = "ID of the Key Vault"
  type        = string
}

variable "keys" {
  description = "Map of keys to create with rotation policies"
  type = map(object({
    name     = string
    key_type = string
    key_size = number
    key_opts = list(string)
    rotation = object({
      automatic = object({
        time_before_expiry = string
      })
      expire_after         = string
      notify_before_expiry = string
    })
  }))
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "create_cmk" {
  type = bool
  default = false
}

variable "storage_account_id" {
  type = string
}

variable "key_name" {
  type = string
}