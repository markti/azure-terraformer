
resource azurerm_storage_account main {
  name                     = "st${random_string.main.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource azurerm_storage_container worlds {
  name                  = "worlds"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}