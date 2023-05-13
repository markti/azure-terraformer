targetScope = 'resourceGroup'
param location string = resourceGroup().location
param name string

var openAiResourceName = 'cog-openai-${name}'

resource openai 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: openAiResourceName
  location: location
  kind: 'OpenAI'
  sku: {
    name: 'S0'
  }
  properties: {
    customSubDomainName: openAiResourceName
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Deny'
      virtualNetworkRules: []
      ipRules            : []
    }
  }
}
