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
  openai_resource_name = "cog-openai-1105"
}

resource "azapi_resource" "openai" {
  type      = "Microsoft.CognitiveServices/accounts@2022-03-01"
  name      = local.openai_resource_name
  parent_id = azurerm_resource_group.main.id
  location  = azurerm_resource_group.main.location

  body = jsonencode({
    sku = {
      name = "S0"
    }
    kind = "OpenAI"
    properties = {
      customSubDomainName = lower(local.openai_resource_name)
      publicNetworkAccess = "Enabled"
      networkAcls = {
        defaultAction       = "Deny"
        virtualNetworkRules = []
        ipRules             = []
      }
    }
  })

}