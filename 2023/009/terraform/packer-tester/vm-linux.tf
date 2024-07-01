
data azurerm_key_vault main {
  name                = "kv-ep3-gz9fbcix"
  resource_group_name = "rg-ep3-gz9fbcix"
}
data azurerm_key_vault_secret ssh_public_key {
  name         = "ssh-public"
  key_vault_id = data.azurerm_key_vault.main.id
}

data azurerm_image aztf_ubuntu_image {
  name                = "aztf-ubuntu"
  resource_group_name = "rg-ep9-packer"
}


module linux_vm {
  source = "../modules/vm/linux"

  name                = random_string.main.result
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.network.subnet_id
  vm_image_id         = data.azurerm_image.aztf_ubuntu_image.id
  ssh_public_key      = data.azurerm_key_vault_secret.ssh_public_key.value

}