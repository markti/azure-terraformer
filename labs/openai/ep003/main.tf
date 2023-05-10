resource "random_string" "main" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${random_string.main.result}"
  location = "East US"
}

locals {
  openai_resource_name = "cog-openai-1106"
}

resource "azurerm_cognitive_account" "openai" {
  name                = local.openai_resource_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "OpenAI"

  sku_name = "S0"

}

resource "azurerm_cognitive_deployment" "chatgpt35turbo" {
  name                 = "chat-gpt-35-turbo"
  cognitive_account_id = azurerm_cognitive_account.openai.id
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0301"
  }

  scale {
    type = "Standard"
  }
}