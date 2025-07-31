locals {
  location        = "southeastasia"
  project         = "nhbs"
  terragrunt_version = "0.83.2"

  default_tags = {
    Project     = local.project
    ManagedBy   = "Terragrunt v${local.terragrunt_version}"
  }
}