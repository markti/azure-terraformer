resource azurerm_user_assigned_identity main {
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  name                = "id-${var.name}-${random_string.main.result}"
}

resource azurerm_role_assignment minecraft_storage_owner {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}