resource "azuread_group" "sales" {
  display_name     = "Sales Team"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}
data "azuread_client_config" "current" {
}

data "azurerm_subscription" "current" {
}

resource "azurerm_role_assignment" "sales" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.sales.object_id
}