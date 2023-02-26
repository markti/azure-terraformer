data azurerm_shared_image_version minecraft_local {
  name                = "1.0.2"
  image_name          = "minecraft-bedrock-local"
  gallery_name        = var.gallery_name
  resource_group_name = var.gallery_resource_group
}
/*
module bedrock_local {

  source = "../modules/vm/linux-public"

  location            = var.location
  name                = "${var.name}local"
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.network.subnet_id
  vm_image_id         = data.azurerm_shared_image_version.minecraft_local.id
  ssh_public_key      = tls_private_key.main.public_key_openssh
  
}

resource azurerm_virtual_machine_extension local_cse {

  name                 = "Minecraft-Final-Setup"
  virtual_machine_id   = module.bedrock_local.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
  {
    "commandToExecute": "systemctl enable mcbedrock"
  }
SETTINGS

}
