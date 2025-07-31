locals {
  location        = "southeastasia"
  project         = get_env("project_name","xxx")
  terragrunt_version = "0.83.2"

  default_tags = {
    Project     = local.project
    ManagedBy   = "Terragrunt v${local.terragrunt_version}"
  }
}