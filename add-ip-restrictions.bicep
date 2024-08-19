param containerAppName string = 'hello'
param location string = 'westus'

resource existingContainerApp 'Microsoft.App/containerApps@2024-03-01' existing = {
  name: containerAppName
}

module updatedContainerApp './upsert-container-app.bicep' = {
  name: 'updatedContainerApp'
  params: {
    location: location
    properties: union(existingContainerApp.properties, {
      configuration: {
        ingress: {
          ipSecurityRestrictions: [
            {
              name: 'my-ip-restriction'
              action: 'Deny'
              ipAddressRange: '192.168.0.0/24'
            }
          ]
        }
      }
    })
    name: containerAppName
  }
}

