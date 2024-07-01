locals {
  name = "ep6"
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
