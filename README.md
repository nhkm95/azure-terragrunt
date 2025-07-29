1. Create local state file
    - In terragrunt root file (infra/dev/terragrunt.hcl), comment out generate backend block
    - In resource_group folder where .hcl file is located, run terragrunt init, plan then apply
    - Repeat for storage account. It will create the container along with it

2. Migrate local state file to storage account container
    - Uncomment generate backend block in terragrunt root file
    - Run terragrunt init --migrate-state
    - State file mirgrated. Run terraform plan. Intended output is "No changes. Your infrastructure matches the configuration."

3. Destroy resources
    - Migrate state file from remote to local
    - In resource folder, run terragrunt init --migrate-state