resource random_string activity_logs {
  length           = 8
  upper            = false
  special          = false
}

data "azurerm_subscription" "current" {
}

resource azurerm_monitor_diagnostic_setting activity_logs {
  name                       = "diag-${random_string.activity_logs.result}"
  target_resource_id         = data.azurerm_subscription.current.id
  storage_account_id         = azurerm_storage_account.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  log {
    category = "Administrative"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Security"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "ServiceHealth"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Alert"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Recommendation"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Policy"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Autoscale"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "ResourceHealth"

    retention_policy {
      enabled = false
    }
  }

}