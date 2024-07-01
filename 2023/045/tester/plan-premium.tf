
resource "azurerm_resource_group" "premium" {
  name     = "rg-${var.name}-${random_string.main.result}-premium"
  location = var.location
}

resource "azurerm_service_plan" "premium" {
  name                         = "asp-${var.name}-${random_string.main.result}-premium"
  resource_group_name          = azurerm_resource_group.premium.name
  location                     = azurerm_resource_group.premium.location
  os_type                      = "Linux"
  sku_name                     = "EP2"
  worker_count                 = 3
  maximum_elastic_worker_count = 10
}
resource "azurerm_storage_account" "premium" {
  name                     = "st${random_string.main.result}prem"
  resource_group_name      = azurerm_resource_group.premium.name
  location                 = azurerm_resource_group.premium.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
