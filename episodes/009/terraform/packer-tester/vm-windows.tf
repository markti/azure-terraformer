
data azurerm_image w2016 {
  name                = "aztf-w2016"
  resource_group_name = "rg-packer"
}

resource random_password admin_password {
length           = 16
  special          = true
  override_special = "!.@"
}

resource local_file admin_password {
  content  = random_password.admin_password.result
  filename = "${path.module}/password.txt"
}

module windows_vm {

  source = "../modules/vm/windows"

  name                = "win${random_string.main.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  admin_password      = random_password.admin_password.result
  vm_image_id         = data.azurerm_image.w2016.id
  subnet_id           = module.network.subnet_id

}