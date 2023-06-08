locals {
  openai_resource_name = "cog-openai-1106"
}

resource "azurerm_cognitive_account" "openai" {
  name                = local.openai_resource_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "OpenAI"
  sku_name            = "S0"
}