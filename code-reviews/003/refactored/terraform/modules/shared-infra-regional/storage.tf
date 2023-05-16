
resource "azurerm_storage_account" "main" {
  name                     = replace(lower("${var.application_name}${var.environment_name}${var.location_index}"), "-", "")
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account_network_rules" "application" {
  storage_account_id         = azurerm_storage_account.main.id
  default_action             = "Allow"
  virtual_network_subnet_ids = [azurerm_subnet.application.id]
  ip_rules                   = [local.myip]
}
