data "http" "myip" {
  url = "http://ipinfo.io/ip"
}

locals {
  myip = chomp(data.http.myip.response_body)
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.application_name}-${var.environment_name}-${var.location}"
  address_space       = ["${var.address_space}.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "application" {
  name                 = "snet-application"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["${var.address_space}.2.0/24"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.ContainerRegistry"]
  delegation {
    name = "application-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}