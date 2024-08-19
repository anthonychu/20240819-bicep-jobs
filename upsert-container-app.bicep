param name string
param location string
param properties object

resource updatedContainerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: name
  properties: properties
  location: location
}

output updatedContainerApp object = updatedContainerApp
