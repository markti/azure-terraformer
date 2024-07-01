
resource "random_string" "suffix" {
  length  = 8
  special = false
  lower   = true
  upper   = false
}


resource "azurerm_storage_account" "storage-blob" {
  name                     = "${var.client_name}${random_string.suffix.result}"
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_account_network_rules" "storage_only_app_traffic" {
  storage_account_id = azurerm_storage_account.storage-blob.id

  default_action             = "Allow"
  virtual_network_subnet_ids = [var.subnet_id]
  ip_rules                   = [var.myip]
}


resource "azurerm_storage_container" "storage-blob" {
  name                  = var.client_name
  storage_account_name  = azurerm_storage_account.storage-blob.name
  container_access_type = "private"
}
