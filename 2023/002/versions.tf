terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"      
      version = "~> 3.28.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.4.3"
    }
    http = {
      source = "hashicorp/http"
      version = "~> 3.2.1"
    }
  }
}

provider "azurerm" {
  features {
  }
}