terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.32.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "utility-rg"
    storage_account_name = "companystatesa"
    container_name       = "tfstate"
    key                  = "terraform.client2.tfstate"
  }
}

provider "azurerm" {
  features {}

}
module "main" {
  source              = "../../main"
  client_name         = "client2"
  app_subnet_prefix   = "10.11.2.0/24"
  location            = "northcentralus"
  keyvault_access_ids = ["4597b25b-ad7f-4323-994f-575777d19f8c"]
  db_info = {
    sku_name             = "Basic"
    db_size              = 1
    geo_backup_enabled   = false
    storage_account_type = "Local"
  }
}



