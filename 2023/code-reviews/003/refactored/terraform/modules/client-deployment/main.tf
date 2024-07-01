resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}-${var.client_name}"
  location = var.location
}
data "azurerm_client_config" "current" {}

