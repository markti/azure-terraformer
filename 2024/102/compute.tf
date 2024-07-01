resource "azurerm_availability_set" "main" {
  name                = "avail-${random_string.main.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_orchestrated_virtual_machine_scale_set" "main" {

  name                = "vmss-${random_string.main.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  platform_fault_domain_count = 3

}

module "vm" {
  source  = "markti/azure-terraformer/azurerm//modules/vm/instance/linux/baseline"
  version = "1.0.19"

  count = 3

  hostname                     = "vm${random_string.main.result}${count.index}"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  vm_size                      = "Standard_D4s_v5"
  admin_username               = "azureuser"
  admin_ssh_key                = tls_private_key.main.public_key_openssh
  subnet_id                    = module.network.subnet_id
  system_assigned_id           = true
  virtual_machine_scale_set_id = azurerm_orchestrated_virtual_machine_scale_set.main.id
  #availability_set_id          = azurerm_availability_set.main.id
  #fault_domain        = 1
  #zone                = 1

  source_image_reference = {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}