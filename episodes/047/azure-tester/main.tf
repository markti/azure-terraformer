resource "random_string" "main" {
  length  = 6
  lower   = true
  upper   = false
  special = false
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.name}-${random_string.main.result}"
  location = var.location
}