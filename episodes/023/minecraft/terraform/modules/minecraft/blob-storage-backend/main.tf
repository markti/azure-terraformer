resource random_string main {
  length           = 8
  upper            = false
  special          = false
}

data azurerm_shared_image_version minecraft_blob_storage {
  name                = var.image_version
  image_name          = var.image_name
  gallery_name        = var.gallery_name
  resource_group_name = var.gallery_resource_group
}

module minecraft_blob_storage {

  source = "../../vm/linux-public"

  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.name}blob"
  subnet_id           = var.subnet_id
  vm_image_id         = data.azurerm_shared_image_version.minecraft_blob_storage.id
  ssh_public_key      = var.ssh_public_key
  managed_id          = azurerm_user_assigned_identity.minecraft_blob_storage.id

}
resource azurerm_virtual_machine_extension blobfuse_cse {

  name                 = "Minecraft-Final-Setup"
  virtual_machine_id   = module.minecraft_blob_storage.id
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
