resource random_string main {
  length           = 8
  upper            = false
  special          = false
}

resource azurerm_resource_group main {
  name     = "rg-ep2-${random_string.main.result}"
  location = var.location
}

resource azurerm_virtual_network main {
  name                = "vnet-ep2-${random_string.main.result}"
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

resource azurerm_network_security_group default {
  name                = "nsg-default"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource azurerm_network_security_rule rule1 {

  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.default.name

  name                        = "rule-100"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"

}

resource azurerm_subnet_network_security_group_association default_rule1 {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}