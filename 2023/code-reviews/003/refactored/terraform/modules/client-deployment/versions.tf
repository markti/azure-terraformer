terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.32.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">=0.43.0"
    }
  }
}
