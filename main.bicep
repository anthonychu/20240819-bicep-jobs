param location string = 'westus'
param managedEnvironmentName string = 'my-managed-environment'
param logAnalyticsWorkspaceName string = 'my-log-analytics-workspace'
param jobName string = 'my-job'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

resource env 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: managedEnvironmentName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
  }
}

resource job 'Microsoft.App/jobs@2024-03-01' = {
  name: jobName
  location: location
  properties: {
    environmentId: env.id
    configuration: {
      replicaTimeout: 120
      triggerType: 'Schedule'
      scheduleTriggerConfig: {
        cronExpression: '*/1 7-19 * * 1-5'
      }
    }
    template: {
      containers: [
        {
          name: 'my-container'
          image: 'curlimages/curl:latest'
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
          args: [
            '-v'
            'https://www.azure.com'
          ]
        }
      ]
    }
  }
}
