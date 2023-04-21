
data azurerm_key_vault main {
  name                = "kv-aztf-devops-dev"
  resource_group_name = "rg-aztf-devops-dev"
}
data azurerm_key_vault_secret ssh_public_key {
  name         = "ssh-public"
  key_vault_id = data.azurerm_key_vault.main.id
}

data azurerm_shared_image_version ubuntu2004 {
  name                = "2023.03.1"
  image_name          = "ubuntu2004-baseline"
  gallery_name        = "galaztfmachineimagesdev"
  resource_group_name = "rg-aztf-machine-images-dev"
}

module linux_vm {
  source = "git::ssh://git@ssh.dev.azure.com/v3/tinderholt/infrastructure/terraform-modules//compute/vm/linux/baseline?ref=v1.0.2"

  name                = random_string.main.result
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.network.subnet_id
  vm_size             = "Standard_DS2_v2"
  vm_image_id         = data.azurerm_shared_image_version.ubuntu2004.id
  admin_user          = "azureuser"
  ssh_public_key      = data.azurerm_key_vault_secret.ssh_public_key.value

}