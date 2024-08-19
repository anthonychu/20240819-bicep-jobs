param containerAppName string = 'hello'

resource existingContainerApp 'Microsoft.App/containerApps@2024-03-01' existing = {
  name: containerAppName
}

output existingContainerApp object = existingContainerApp
