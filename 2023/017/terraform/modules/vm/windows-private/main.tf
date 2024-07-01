
resource azurerm_network_interface main {
  name                = "nic-vm${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource azurerm_windows_virtual_machine main {
  name                = "vm${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_DS2_v2"
  admin_username      = "adminuser"
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.vm_image_id

}