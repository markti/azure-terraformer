resource azurerm_resource_group main {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.location
}

# current terraform user
data azurerm_client_config current {}
