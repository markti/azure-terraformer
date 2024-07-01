
resource "azurerm_linux_function_app" "func1" {
  name                = "func-${var.name}-${random_string.main.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  storage_account_name       = azurerm_storage_account.consumable.name
  storage_account_access_key = azurerm_storage_account.consumable.primary_access_key
  service_plan_id            = azurerm_service_plan.consumable.id

  site_config {}
}