resource "random_password" "mssql_server" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azurerm_mssql_server" "main" {
  name                         = "sql-${var.application_name}-${var.environment_name}-${var.location}"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = random_password.mssql_server.result
}

# This rule only allows traffic from the apps VNet
resource "azurerm_mssql_virtual_network_rule" "application" {
  name      = "application-rule"
  server_id = azurerm_mssql_server.main.id
  subnet_id = azurerm_subnet.application.id
}