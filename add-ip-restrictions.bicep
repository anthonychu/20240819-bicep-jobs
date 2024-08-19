param containerAppName string = 'hello'
param location string = 'westus'

module existing 'get-existing-container-app.bicep' = {
  name: 'existingContainerApp'
  params: {
    containerAppName: containerAppName
  }
}

var existingContainerApp = existing.outputs.existingContainerApp

resource updatedContainerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: containerAppName
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
  location: location
}
