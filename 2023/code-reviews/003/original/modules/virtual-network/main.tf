resource "azurerm_subnet" "app_subnet" {
  name                 = var.client_name
  resource_group_name  = element(split("/", var.vnet_id), 4)
  virtual_network_name = element(split("/", var.vnet_id), 8)
  address_prefixes     = [var.app_subnet_prefix]
  service_endpoints    = var.service_endpoints
  delegation {
    name = "${var.client_name}-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
