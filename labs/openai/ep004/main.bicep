param location string = resourceGroup().location

resource openai 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: 'cog-openai-1107'
  location: location
  sku: {
    name: 'S0'
  }
  properties: {
    customSubDomainName: 'cog-openai-1107'
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Deny'
      virtualNetworkRules: []
      ipRules            : []
    }
  }
}
