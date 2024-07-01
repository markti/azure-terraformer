data "azurerm_storage_account" "shared" {
  resource_group_name = "rg-cr3-shared-${var.environment_name}-${var.location}"
  name                = "cr3shared${var.environment_name}${var.location_index}"
}

resource "azurerm_storage_container" "main" {
  name                  = var.client_name
  storage_account_name  = data.azurerm_storage_account.shared.name
  container_access_type = "private"
}
