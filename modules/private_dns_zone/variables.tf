variable "dns_zone_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "create_prv_vnet_link" {
  type = bool
  default = false
}

variable "prv_vnet_link_name" {
  type = string
}

variable "vnet_id" {
  type = string
}