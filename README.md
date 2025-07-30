1. Create local state file
    - Only create local state file for resource group and storage account resources. The rest will be created in remote backend.
    - Change file extension of include_backend.hcl to include_backend.hcl.txt. This file will be used only when migrating state file to remote backend.
    - In resource group and storage account child modules, comment out "include backend" block. It will be used when migrating state file to remote backend.

2. Migrate local state file to storage account container
    - Change include_backend.hcl.txt file extension to include_backend.hcl
    - In resource group and storage account child modules, uncomment "include backend" block. It will now be used to migrate local state file to remote backend.
    - Migrate 1 by 1: Run terragrunt init --migrate-state in resource group child module then storage account
    - State file mirgrated. Run terraform plan. Intended output is "No changes. Your infrastructure matches the configuration."

3. Destroy resources
    - Migrate state file from remote to local
    - Do it in reverse. In each child module, comment out "include backend" block. It will now be used to migrate remote state file to local backend.
    - Change include_backend.hcl file extension to include_backend.hcl.txt
    - In each child module, run terragrunt init --migrate-state
    - State file mirgrated. Run terraform plan. Intended output is "No changes. Your infrastructure matches the configuration."

To assign dynamic values to subscription id, run this command in terminal before terragrunt init

Powershell:
$env:AZURE_SUBSCRIPTION_ID = "your subscription id"

Mac:
export ARM_SUBSCRIPTION_ID="your subscription id"