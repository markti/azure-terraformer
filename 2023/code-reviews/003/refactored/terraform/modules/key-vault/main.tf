
resource "azurerm_key_vault" "main" {
  name                       = "kv-${var.name}"
  resource_group_name        = var.resource_group
  location                   = var.location
  tenant_id                  = var.tenant_id
  soft_delete_retention_days = 90
  enable_rbac_authorization  = false

  sku_name = "standard"

  network_acls {
    default_action             = "Allow"
    bypass                     = "None"
    virtual_network_subnet_ids = var.subnets
    ip_rules                   = var.ip_rules
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "terraform_user" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
}