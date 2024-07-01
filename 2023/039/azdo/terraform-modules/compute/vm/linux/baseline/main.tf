
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

resource azurerm_linux_virtual_machine main {
  name                = "vm${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_user

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = var.admin_user
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.vm_image_id

  dynamic "source_image_reference" {
    for_each = var.vm_image_id == null ? [0] : []
    content {
      publisher = var.source_image_reference.publisher
      sku       = var.source_image_reference.sku
      offer     = var.source_image_reference.offer
      version   = var.source_image_reference.version
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_storage_account_uri == null ? [] : [0]
    content {
      storage_account_uri = var.boot_diagnostics_storage_account_uri
    }
  }

  identity {
    type = "SystemAssigned"
  }

}