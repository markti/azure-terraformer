
module "network" {

  count = length(local.regions_array)

  source = "../modules/network/bastion"

  name                = "${var.name}${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = local.regions_array[count.index]
  
}

resource azurerm_network_security_rule minecraft {

  count = length(local.regions_array)

  name                        = "minecraft-port"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "19132-19133"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = module.network[count.index].nsg_name
  
}