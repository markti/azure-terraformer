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
    key                  = "terraform.shared.tfstate"
  }
}



provider "azurerm" {
  features {}

}
module "main" {
  source         = "../../shared"
  shared_rg_name = "shared-rg"
  address_space  = "10.11.0.0/16"
  location       = "northcentralus"


}




