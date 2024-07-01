
data azurerm_shared_image_version minecraft_blobfuse {
  name                = "1.0.3"
  image_name          = "minecraft-bedrock-blobfuse"
  gallery_name        = var.gallery_name
  resource_group_name = var.gallery_resource_group
}

module bedrock_blobfuse {

  source = "../modules/vm/linux-public"

  location            = var.location
  name                = "${var.name}blobfuse"
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.network.subnet_id
  vm_image_id         = data.azurerm_shared_image_version.minecraft_blobfuse.id
  ssh_public_key      = tls_private_key.main.public_key_openssh
  managed_id          = azurerm_user_assigned_identity.main.id
  
}

resource azurerm_virtual_machine_extension blobfuse_cse {

  name                 = "Minecraft-Final-Setup"
  virtual_machine_id   = module.bedrock_blobfuse.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
  {
  "script": "${
      base64encode(
        templatefile("${path.module}/files/blobfuse-setup.sh", 
          {
            storage_account_name="${azurerm_storage_account.main.name}"
            storage_container_name="${azurerm_storage_container.worlds.name}"
          }
        )
      )
    }"
  }
SETTINGS

}
