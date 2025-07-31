variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "account_tier" {
  type        = string
  description = "Storage account tier"
  default     = "Standard" # Optional fallback
}

variable "replication_type" {
  type        = string
  description = "Replication type"
  default     = "LRS" # Optional fallback
}

variable "min_tls_version" {
  type        = string
  description = "Minimum TLS version"
  default     = "TLS1_2"
}

variable "create_container" {
  type    = bool
  default = false
}

variable "container_name" {
  type    = string
  default = ""
}

variable "container_access_type" {
  type    = string
  default = "private"
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "large_file_share_enabled" {
  type = bool
  default = false
}

variable "public_network_access_enabled" {
  type = bool
  default = false
}

variable "identity_type" {
  description = "Type of identity to use: 'None', 'SystemAssigned', 'UserAssigned', or 'SystemAssigned, UserAssigned'"
  type        = string
  default     = "None"
}

variable "identity_ids" {
  description = "List of User Assigned Identity IDs"
  type        = list(string)
  default     = []
}

variable "default_action" {
  type = string
  default = "Deny"
}

variable "ip_rules" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "bypass" {
  type = list(string)
}

variable "create_network_rules" {
  type = bool
  default = false
}