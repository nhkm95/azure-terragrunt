variable "vnet_name" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

# variable "subnets" {
#   description = "Map of subnet definitions. Key = subnet name"
#   type = map(object({
#     address_prefixes  = list(string)
#     service_endpoints = optional(list(string))
#     delegation        = optional(list(object({
#       name = string
#       service_delegation = object({
#         name    = string
#         actions = list(string)
#       })
#     })))
#   }))
# }

variable "subnets" {
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string))
    delegation = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    })))
  }))
}