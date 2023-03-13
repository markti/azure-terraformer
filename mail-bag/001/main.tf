resource random_string main {
  length           = 8
  upper            = false
  special          = false
}

resource azurerm_resource_group main {
  name     = "rg-${var.name}-${random_string.main.result}"
  location = var.location
}

locals {
  my_geo_locations = [
    {
      location2          = "West US"
      failover_priority2 = 0
    },
    {
      location2          = "East US"
      failover_priority2 = 1
    }
  ]
}

resource azurerm_cosmosdb_account db {

  name                          = "cosmos-${var.name}-${random_string.main.result}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  offer_type                    = "Standard"
  kind                          = "GlobalDocumentDB"
  public_network_access_enabled = false
  
  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = "West US"
    failover_priority = 0
  }

  geo_location {
    location          = "East US"
    failover_priority = 1
  }

  dynamic "geo_location" {
    for_each = local.my_geo_locations
    content {
      location          = geo_location.value.location2
      failover_priority = geo_location.value.failover_priority2
    }
  }

}