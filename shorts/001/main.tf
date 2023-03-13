terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.28.0"
    }
  }
  backend "azurerm" {
    # intentionally blank...secret stuff goes in here
  }
}

provider "azurerm" {
  features {
  }
  # intentionally blank...secret stuff goes in here
}