terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.28.0"
    }
  }
}

provider "azurerm" {
  features {
  }
  # intentionally blank...secret stuff goes in here
}