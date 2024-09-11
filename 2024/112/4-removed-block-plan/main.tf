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
/*
resource "azurerm_app_service_plan" "main" {
  name                = "asp-ep112-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}*/
/*
# This will remove the app service plan
removed {
  from = azurerm_app_service_plan.main

  lifecycle {
    destroy = false
  }
}
*/

resource "azurerm_service_plan" "main" {
  name                = "asp-ep112-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Windows"
  sku_name            = "S1"
}

/*
# This will remove the app service 'App' resource
removed {
  from = azurerm_app_service.main

  lifecycle {
    destroy = false
  }
}
*/
/*
resource "azurerm_app_service" "main" {
  name                = "app-ep112-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}
*/