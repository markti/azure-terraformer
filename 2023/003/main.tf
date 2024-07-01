resource random_string main {
  length           = 8
  upper            = false
  special          = false
}

resource azurerm_resource_group main {
  name     = "rg-ep3-${random_string.main.result}"
  location = var.location
}

resource azurerm_key_vault main {
  name                        = "kv-ep3-${random_string.main.result}"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false

  sku_name = "standard"
}

data azurerm_client_config current {}

resource azurerm_key_vault_access_policy terraform_user {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]

}

resource random_string keyvault_monitor {
  length           = 8
  upper            = false
  special          = false
}

locals {
  monitor_suffix = "a6ipu10e"
}
data azurerm_storage_account monitor {
  name                = "st${local.monitor_suffix}"
  resource_group_name = "rg-ep1-${local.monitor_suffix}"
}
data azurerm_log_analytics_workspace monitor {
  name                = "log-ep1-${local.monitor_suffix}"
  resource_group_name = "rg-ep1-${local.monitor_suffix}"
}

resource azurerm_monitor_diagnostic_setting activity_logs {
  name                       = "diag-${random_string.keyvault_monitor.result}"
  target_resource_id         = azurerm_key_vault.main.id
  storage_account_id         = data.azurerm_storage_account.monitor.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.monitor.id

  log {
    category_group = "audit"

    retention_policy {
      enabled = false
    }
  }
  log {
    category_group = "allLogs"

    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }

}