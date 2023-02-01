resource random_string main {
  length           = 8
  upper            = false
  special          = false
}

resource azurerm_resource_group main {
  name     = "rg-packer-tester-${random_string.main.result}"
  location = var.location
}

data azurerm_key_vault main {
  name                = "kv-ep3-gz9fbcix"
  resource_group_name = "rg-ep3-gz9fbcix"
}

data azurerm_key_vault_secret ssh_public_key {
  name         = "ssh-public"
  key_vault_id = data.azurerm_key_vault.main.id
}

module "network" {
  source   = "../modules/network/bastion"

  name                = random_string.main.result
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  
}