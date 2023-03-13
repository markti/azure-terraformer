variable name {
  type = string
}
variable location {
  type    = string
  default = "West US"
}

resource azurerm_resource_group main {
  name     = "rg-${var.name}"
  location = var.location
}
resource azurerm_virtual_network main {
  name                = "vnet-${var.name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
}
resource azurerm_subnet default {
  name                 = "snet-default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}
