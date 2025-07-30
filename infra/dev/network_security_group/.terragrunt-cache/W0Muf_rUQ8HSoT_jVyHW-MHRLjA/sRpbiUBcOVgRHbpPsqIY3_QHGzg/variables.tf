# variables.tf

variable "location" {
  type        = string
  description = "Azure region where NSGs will be created"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to assign to the NSGs"
}

variable "nsgs" {
  description = "Map of NSGs with their rules"
  type = map(object({
    nsg_name             = string
    create_inbound_rules  = bool
    create_outbound_rules = bool
    inbound_rules = list(object({
      name                        = string
      priority                    = number
      access                      = string
      protocol                    = string
      source_address_prefix       = optional(string)
      destination_address_prefix  = optional(string)
      source_port_range           = optional(string)
      destination_port_range      = optional(string)
      description                 = optional(string)
    }))
    outbound_rules = list(object({
      name                        = string
      priority                    = number
      access                      = string
      protocol                    = string
      source_address_prefix       = optional(string)
      destination_address_prefix  = optional(string)
      source_port_range           = optional(string)
      destination_port_range      = optional(string)
      description                 = optional(string)
    }))
  }))
}


variable "subnet_ids" {
  type = map(string)
  default = {}
  description = "Map of NSG name to subnet ID for association"
}

# variable "nsg_name" {
#   type = string
#   description = "name of security group"
# }

# variable "location" {
#   type = string
#   description = "location of the security group"
# }

# variable "resource_group_name" {
#   type = string
#   description = "name of resource group"
# }

# variable "tags" {
#   type = map(string)
#   default = {}
#   description = "mapping to strings to assign to the resource"
# }

# variable "inbound_rules" {
#   type = list(object({
#       name = string
#       priority = number
#       access = string
#       protocol = string
#       source_address_prefix = optional(string)
#       destination_address_prefix = optional(string)
#       source_port_range = optional(string)
#       destination_port_range = optional(string)
#       description = optional(string)
#     })
#   )
# }

# variable "outbound_rules" {
#   type = list(object({
#       name = string
#       priority = number
#       access = string
#       protocol = string
#       source_address_prefix = optional(string)
#       destination_address_prefix = optional(string)
#       source_port_range = optional(string)
#       destination_port_range = optional(string)
#       description = optional(string)
#     })
#   )
# }

# variable "create_inbound_rules" {
#   description = "Flag to indicate whether to create inbound rules"
#   type        = bool
#   default     = true  # By default, inbound rules are created
# }

# variable "create_outbound_rules" {
#   description = "Flag to indicate whether to create outbound rules"
#   type        = bool
#   default     = false  # By default, outbound rules are not created
# }

