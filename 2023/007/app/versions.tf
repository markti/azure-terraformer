terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"      
      version = "~> 3.41.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "sttzfvsiaz"
    container_name       = "tfstate"
    key                  = "marks-app.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}