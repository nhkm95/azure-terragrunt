# terraform {
  # required_providers {
  #   azurerm = {
  #     source  = "hashicorp/azurerm"
  #     version = ">= 3.0"
  #   }
  # }
# }

resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location

  tags = var.tags
}