resource azurerm_user_assigned_identity minecraft_blob_storage {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "id-${var.name}-${random_string.main.result}-blob-storage"
}

resource azurerm_role_assignment minecraft_storage_owner {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.minecraft_blob_storage.principal_id
}