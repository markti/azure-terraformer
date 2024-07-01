
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}-${var.location}"
  location = var.location
}

# This creates the plan that the service use
resource "azurerm_service_plan" "main" {
  name                = "asp-${var.application_name}-${var.environment_name}-${var.location}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku_name            = "S2"
  os_type             = "Windows"
}

resource "azurerm_application_insights" "main" {
  name                = "appi-${var.application_name}-${var.environment_name}-${var.location}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "other"
}
