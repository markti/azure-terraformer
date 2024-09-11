resource "random_string" "suffix" {
  lower   = true
  upper   = false
  numeric = true
  special = false
  length  = 6
}

resource "azurerm_resource_group" "main" {
  name     = "rg-ep112-${random_string.suffix.result}"
  location = var.location
}

resource "azurerm_service_plan" "main" {
  name                = "asp-ep112-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Windows"
  sku_name            = "S1"
}

import {
  to = azurerm_windows_web_app.main
  id = "/subscriptions/32cfe0af-c5cf-4a55-9d85-897b85a8f07c/resourceGroups/rg-ep112-5w97hr/providers/Microsoft.Web/sites/app-ep112-5w97hr"
}

resource "azurerm_windows_web_app" "main" {
  name                = "app-ep112-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on = true
    #ftps_state                        = "Disabled"
    #ip_restriction_default_action     = "Allow"
    #scm_ip_restriction_default_action = "Allow"
    #use_32_bit_worker                 = true
    application_stack {
      dotnet_version = "v4.0"
    }
  }

  app_settings = {
    SOME_KEY = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}