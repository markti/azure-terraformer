
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.name}-${random_string.main.result}"
  location = var.location
}

resource "azurerm_service_plan" "consumable" {
  name                = "asp-${var.name}-${random_string.main.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_storage_account" "consumable" {
  name                     = "st${random_string.main.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
