
data azurerm_image ubuntu {
  name                = "aztf-ubuntu"
  resource_group_name = "rg-packer"
}

module linux_vm {

  source = "../modules/vm/linux"

  name                = "lin${random_string.main.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  ssh_public_key      = data.azurerm_key_vault_secret.ssh_public_key.value
  vm_image_id         = data.azurerm_image.ubuntu.id
  subnet_id           = module.network.subnet_id

}