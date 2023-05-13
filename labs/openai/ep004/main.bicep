targetScope = 'subscription'
param location string = 'East US'

var prefix = uniqueString(subscription().subscriptionId)

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${prefix}'
  location: location
}

module cognitive './cognitive.bicep' = {
  name: 'stuff'
  scope: rg
  params: {
    name: prefix
  }
}
