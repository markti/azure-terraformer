resource random_password admin_password {
  length           = 16
  special          = true
  override_special = "!.@"
}

resource "local_file" "foo" {
  content  = random_password.admin_password.result
  filename = "${path.module}/password.txt"
}

data azurerm_image aztf_w2016_image {
  name                = "aztf-w2016"
  resource_group_name = "rg-ep9-packer"
}


module windows_vm {
  source = "../modules/vm/windows"

  name                = "win${random_string.main.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.network.subnet_id
  vm_image_id         = data.azurerm_image.aztf_w2016_image.id
  admin_password      = random_password.admin_password.result

}