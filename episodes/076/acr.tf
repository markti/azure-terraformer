resource "azurerm_container_registry" "acr" {
  name                = "acr${random_string.main.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Premium"
  admin_enabled       = false
}

locals {
  use_logs_or_use_metrics_instead = true

  logs    = use_logs_or_use_metrics_instead ? ["x", "y", "z"] : []
  metrics = use_logs_or_use_metrics_instead ? [] : ["AllMetrics"]
}

resource "azurerm_monitor_diagnostic_setting" "main" {

  name                       = "acr${random_string.main.result}"
  target_resource_id         = azurerm_container_registry.acr.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  dynamic "log" {
    for_each = local.logs
    content {
      category = log.value
      enabled  = true
    }
  }

  dynamic "metric" {
    for_each = local.metrics
    content {
      category = metric.value
      enabled  = true
    }
  }
}