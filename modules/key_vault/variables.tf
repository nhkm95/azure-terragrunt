variable "vault_name" {
    type = string
}

variable "location" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "enabled_for_disk_encryption" {
    type = bool
    default = true
}

variable "soft_delete_retention_days" {
    type = number
}

variable "purge_protection_enabled" {
    type = bool
    default = true
}

variable "sku_name" {
    type = string
    default = "standard"
}

variable "tags" {
  type = map(string)
  default = {}
}