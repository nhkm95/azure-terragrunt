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
  description = <<EOT
Map of subnet configurations.
Each key is a subnet name. Each value is an object containing:
- address_prefixes: List of CIDRs
- service_endpoints: (optional) List of service endpoints
- delegation: (optional) List of delegation objects
EOT

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