resource azurerm_user_assigned_identity minecraft_local_storage {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = "id-${var.name}-${random_string.main.result}-local-storage"
}