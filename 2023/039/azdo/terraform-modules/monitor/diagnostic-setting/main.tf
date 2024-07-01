
resource azurerm_monitor_diagnostic_setting main {

  name                           = var.name
  target_resource_id             = var.resource_id
  storage_account_id             = var.storage_account_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = var.logs
    content {
      category = enabled_log.value

      retention_policy {
        enabled = true
        days    = var.retention_period
      }
    }
  }

  dynamic "metric" {
    for_each = var.metrics
    content {
      category = metric.value

      retention_policy {
        enabled = true
        days    = var.retention_period
      }
    }
  }

}