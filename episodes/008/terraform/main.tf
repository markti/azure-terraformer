locals {
  name = "ep8"
}

resource random_string main {
  length           = 8
  upper            = false
  special          = false
}

resource azurerm_resource_group main {
  name     = "rg-${local.name}-${random_string.main.result}"
  location = var.location
}

resource azurerm_storage_account main {
  name                     = "st${random_string.main.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}