
resource azurerm_key_vault main {
  name                        = "kv-${var.application_name}-${var.environment_name}"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false

  sku_name = "standard"
}

data azurerm_storage_account observability {
  name                = var.observability_storage_account
  resource_group_name = "rg-aztf-observability-${var.environment_name}"
}
data azurerm_log_analytics_workspace observability {
  name                = "log-aztf-observability-${var.environment_name}"
  resource_group_name = "rg-aztf-observability-${var.environment_name}"
}

module keyvault_diagnostic {

  source = "git::ssh://git@ssh.dev.azure.com/v3/tinderholt/infrastructure/terraform-modules//monitor/diagnostic-setting?ref=v1.0.0"

  name                       = azurerm_key_vault.main.name
  resource_id                = azurerm_key_vault.main.id
  storage_account_id         = data.azurerm_storage_account.observability.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.observability.id
  logs                       = ["AuditEvent", "AzurePolicyEvaluationDetails"]
  metrics                    = ["AllMetrics"]
  retention_period           = 30

}

resource azurerm_key_vault_access_policy terraform_user {

  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]

}

resource azurerm_key_vault_access_policy admin_user {

  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azuread_group.admin.object_id

  secret_permissions = [
    "Get", "List"
  ]

}
