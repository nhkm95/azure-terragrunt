Resource group and storage account created outside of terraform. 

Create using azure cli:
az group create --name rg-nhbs-dev --location southeastasia
az storage account create --name nhbstfstatedev --resource-group rg-nhbs-dev --sku Standard_LRS
az storage container create --name tfstate --account-name nhbstfstatedev

To assign dynamic values to subscription id, run this command in terminal before terragrunt init

Powershell:
$env:AZURE_SUBSCRIPTION_ID = "your subscription id"

Mac:
export ARM_SUBSCRIPTION_ID="your subscription id"

