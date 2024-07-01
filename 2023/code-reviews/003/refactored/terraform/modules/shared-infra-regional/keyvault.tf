data "azurerm_client_config" "current" {}

module "keyvault" {
  source         = "../key-vault"
  name           = "${var.application_name}-${var.environment_name}-${var.location_index}"
  resource_group = azurerm_resource_group.main.name
  location       = azurerm_resource_group.main.location
  tenant_id      = data.azurerm_client_config.current.tenant_id
  subnets        = [azurerm_subnet.application.id]
  ip_rules       = [local.myip]
}

resource "azurerm_key_vault_secret" "database_username" {
  name         = "database-username"
  value        = azurerm_mssql_server.main.administrator_login
  key_vault_id = module.keyvault.id
}
resource "azurerm_key_vault_secret" "database_password" {
  name         = "database-password"
  value        = azurerm_mssql_server.main.administrator_login_password
  key_vault_id = module.keyvault.id
}
resource "azurerm_key_vault_secret" "storage_key" {
  name         = "storage-key"
  value        = azurerm_storage_account.main.primary_access_key
  key_vault_id = module.keyvault.id
}