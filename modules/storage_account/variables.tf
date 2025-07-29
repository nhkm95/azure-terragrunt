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

variable "container_name" {
  type        = string
  default = ""
}

variable "container_access_type" {
  type = string
  default = "private"
}