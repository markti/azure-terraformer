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

provider "azurerm" {
  features {}
  subscription_id = "00000000-0000-0000-0000-000000000000"
  tenant_id       = "00000000-0000-0000-0000-000000000000"
}

data "http" "myip" {
  url = "http://ipinfo.io/ip"
}

locals {
  myip        = chomp(data.http.myip.response_body)
  keyvaultIds = setunion(var.keyvault_access_ids, [data.azurerm_client_config.current.object_id])
}
data "terraform_remote_state" "shared-state" {
  backend = "azurerm"
  config = {
    resource_group_name  = "utility-rg"
    storage_account_name = "companystatesa"
    container_name       = "tfstate"
    key                  = "terraform.shared.tfstate"
  }
}

resource "azurerm_resource_group" "main" {
  name     = var.client_name
  location = var.location
}

data "azurerm_mssql_server" "shared_sql_server" {
  resource_group_name = ""
  name                = ""
}

module "database" {
  source         = "../modules/sql-db"
  resource_group = azurerm_resource_group.main.name
  client_name    = var.client_name
  location       = var.location
  sqlserver = {
    name           = data.shared_sql_server.shared_sql_server.name
    resource_group = data.shared_sql_server.shared_sql_server.resource_group_name
  }
  subnet_id = module.network.app_subnet_id
  db_info   = var.db_info
}
data "azurerm_client_config" "current" {}

module "application-insights" {
  source         = "../modules/application-insights"
  resource_group = azurerm_resource_group.main.name
  client_name    = var.client_name
  location       = var.location
}

module "key-vault" {
  source         = "../modules/key-vault"
  resource_group = azurerm_resource_group.main.name
  client_name    = var.client_name
  location       = var.location

  database_username = data.terraform_remote_state.shared-state.outputs.db_username
  database_password = data.terraform_remote_state.shared-state.outputs.db_password

  storage_account_key = module.storage-blob.azurerm_storage_account_key
  keyvault_access_ids = local.keyvaultIds
  subnet_id           = module.network.app_subnet_id
  myip                = local.myip
}

module "storage-blob" {
  source         = "../modules/storage-blob"
  resource_group = azurerm_resource_group.main.name
  client_name    = var.client_name
  location       = var.location
  subnet_id      = module.network.app_subnet_id
  myip           = local.myip
}

module "network" {
  source            = "../modules/virtual-network"
  resource_group    = azurerm_resource_group.main.name
  client_name       = var.client_name
  location          = var.location
  vnet_id           = data.terraform_remote_state.shared-state.outputs.vnet_id
  service_endpoints = ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.ContainerRegistry"]
  app_subnet_prefix = var.app_subnet_prefix
}
