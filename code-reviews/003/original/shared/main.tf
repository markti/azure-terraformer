
resource "azurerm_resource_group" "shared-rg" {
  name     = var.shared_rg_name
  location = var.location
}
# This creates the plan that the service use
resource "azurerm_service_plan" "service-plan" {
  name                = "company-${var.location}-appservice-plan"
  resource_group_name = azurerm_resource_group.shared-rg.name
  location            = var.location
  sku_name            = "S2"
  os_type             = "Windows"
}

resource "random_password" "password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azurerm_mssql_server" "shared-sql" {
  name                = "company-shared-${var.location}-db-server"
  resource_group_name = azurerm_resource_group.shared-rg.name
  location            = var.location
  version             = "12.0"

  administrator_login          = var.administrator_login
  administrator_login_password = random_password.password.result
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "company-${var.location}-VNET"
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = azurerm_resource_group.shared-rg.name
}

