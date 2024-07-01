

resource "random_string" "key_vault_name" {
  length  = "7"
  special = false
  lower   = true
}

data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "application" {
  enable_rbac_authorization  = true
  name                       = "${var.client_name}${random_string.key_vault_name.result}-kv"
  resource_group_name        = var.resource_group
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 90

  sku_name = "standard"

  network_acls {
    default_action             = "Allow"
    bypass                     = "None"
    virtual_network_subnet_ids = [var.subnet_id]
    ip_rules                   = [var.myip]
  }
}

resource "azurerm_role_assignment" "keyvault-sp-access-assignment" {
  for_each             = var.keyvault_access_ids
  role_definition_name = "Key Vault Secrets Officer"
  scope                = azurerm_key_vault.application.id
  principal_id         = each.key
  timeouts {
    create = "2m"
    update = "2m"
    delete = "2m"
    read   = "2m"
  }
}


resource "azurerm_key_vault_secret" "database_username" {
  name         = "database-username"
  value        = var.database_username
  key_vault_id = azurerm_key_vault.application.id
  depends_on   = [azurerm_role_assignment.keyvault-sp-access-assignment]
}

resource "azurerm_key_vault_secret" "database_password" {
  name         = "database-password"
  value        = var.database_password
  key_vault_id = azurerm_key_vault.application.id

  depends_on = [azurerm_role_assignment.keyvault-sp-access-assignment]
}

resource "azurerm_key_vault_secret" "storage_account_key" {
  name         = "storage-account-key"
  value        = var.storage_account_key
  key_vault_id = azurerm_key_vault.application.id

  depends_on = [azurerm_role_assignment.keyvault-sp-access-assignment]
}
