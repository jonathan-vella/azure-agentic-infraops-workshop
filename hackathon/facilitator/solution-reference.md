# Solution Reference

> **For facilitators only** — Expected outputs and patterns.

## Expected Artifacts

```
agent-output/freshconnect/
├── 01-requirements.md
├── 02-architecture-assessment.md
├── 03-des-architecture-diagram.md (optional)
├── 04-implementation-plan.md
├── 05-load-test-results.md
└── 06-deployment-summary.md

infra/bicep/freshconnect/
├── main.bicep
├── main.bicepparam
├── deploy.ps1
└── modules/
    ├── app-service.bicep
    ├── sql-database.bicep
    ├── storage.bicep
    ├── key-vault.bicep
    └── monitoring.bicep
```

---

## Expected Requirements

**Functional:**

- Web portal for order entry (React/Vue on App Service)
- RESTful API backend (.NET/Node on App Service)
- Order, customer, inventory database (Azure SQL)
- File storage for images/invoices (Blob Storage)
- Secret management (Key Vault)

**Non-Functional:**

- SLA: 99.9%
- RTO: 4 hours (1 hour after Challenge 4)
- RPO: 1 hour (15 min after Challenge 4)
- Peak: 500 concurrent users
- Seasonal: 3x traffic spikes

**Constraints:**

- Budget: ~€500/month (€700 after Challenge 4)
- Region: swedencentral (+germanywestcentral after Challenge 4)
- Compliance: GDPR

---

## Expected Architecture

| Resource | SKU | Cost |
|----------|-----|------|
| App Service Plan | P1v3 (Linux) | ~€75/mo |
| App Service (Web) | — | Included |
| App Service (API) | — | Included |
| Azure SQL | S2 (50 DTU) | ~€60/mo |
| Storage Account | Standard LRS | ~€5/mo |
| Key Vault | Standard | ~€1/mo |
| Application Insights | — | ~€5/mo |
| Log Analytics | — | ~€10/mo |
| **Total** | | **~€156/mo** |

After Challenge 4 (DR):

| Additional Resource | Cost |
|---------------------|------|
| Secondary App Service Plan | ~€75/mo |
| SQL Geo-Replica | ~€60/mo |
| Traffic Manager | ~€5/mo |
| **New Total** | **~€300/mo** |

---

## Expected Bicep Patterns

### main.bicep

```bicep
targetScope = 'resourceGroup'

@description('Environment name')
param environment string = 'dev'

@description('Project name')
param projectName string = 'freshconnect'

@description('Primary location')
param location string = 'swedencentral'

@description('Owner for tagging')
param owner string = 'hackathon-team'

// Generate unique suffix ONCE
var uniqueSuffix = uniqueString(resourceGroup().id)

// Required tags
var tags = {
  Environment: environment
  ManagedBy: 'Bicep'
  Project: projectName
  Owner: owner
}

// Modules
module monitoring 'modules/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    location: location
    projectName: projectName
    environment: environment
    tags: tags
  }
}

module keyVault 'modules/key-vault.bicep' = {
  name: 'keyVault'
  params: {
    location: location
    projectName: projectName
    environment: environment
    uniqueSuffix: uniqueSuffix
    tags: tags
  }
}

module storage 'modules/storage.bicep' = {
  name: 'storage'
  params: {
    location: location
    projectName: projectName
    environment: environment
    uniqueSuffix: uniqueSuffix
    tags: tags
  }
}

module sqlDatabase 'modules/sql-database.bicep' = {
  name: 'sqlDatabase'
  params: {
    location: location
    projectName: projectName
    environment: environment
    uniqueSuffix: uniqueSuffix
    tags: tags
  }
}

module appService 'modules/app-service.bicep' = {
  name: 'appService'
  params: {
    location: location
    projectName: projectName
    environment: environment
    tags: tags
    appInsightsInstrumentationKey: monitoring.outputs.appInsightsInstrumentationKey
  }
}
```

### Security Settings (Required)

```bicep
// Storage Account
properties: {
  supportsHttpsTrafficOnly: true
  minimumTlsVersion: 'TLS1_2'
  allowBlobPublicAccess: false
}

// SQL Server
properties: {
  azureADOnlyAuthentication: true
  minimalTlsVersion: '1.2'
}

// App Service
properties: {
  httpsOnly: true
  minTlsVersion: '1.2'
}
```

### Naming Convention

```bicep
// Key Vault (max 24 chars)
var kvName = 'kv-${take(projectName, 8)}-${environment}-${take(uniqueSuffix, 6)}'

// Storage Account (max 24 chars, no hyphens)
var stName = 'st${take(replace(projectName, '-', ''), 10)}${environment}${take(uniqueSuffix, 6)}'

// SQL Server
var sqlName = 'sql-${projectName}-${environment}-${take(uniqueSuffix, 8)}'
```

---

## DR Solution (Challenge 4)

### Additional Parameters

```bicep
param enableDR bool = true
param secondaryLocation string = 'germanywestcentral'
```

### SQL Geo-Replication

```bicep
resource sqlServerSecondary 'Microsoft.Sql/servers@2023-05-01-preview' = if (enableDR) {
  name: 'sql-${projectName}-${environment}-gwc'
  location: secondaryLocation
  properties: {
    azureADOnlyAuthentication: true
  }
}

resource dbReplica 'Microsoft.Sql/servers/databases@2023-05-01-preview' = if (enableDR) {
  parent: sqlServerSecondary
  name: databaseName
  location: secondaryLocation
  properties: {
    createMode: 'OnlineSecondary'
    sourceDatabaseId: sqlDatabase.id
  }
}
```

### Traffic Manager

```bicep
resource trafficManager 'Microsoft.Network/trafficManagerProfiles@2022-04-01' = {
  name: 'tm-${projectName}'
  location: 'global'
  properties: {
    profileStatus: 'Enabled'
    trafficRoutingMethod: 'Priority'
    dnsConfig: {
      relativeName: 'tm-${projectName}'
      ttl: 60
    }
    monitorConfig: {
      protocol: 'HTTPS'
      port: 443
      path: '/health'
    }
    endpoints: [
      {
        name: 'primary'
        type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
        properties: {
          targetResourceId: primaryApp.id
          priority: 1
        }
      }
      {
        name: 'secondary'
        type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
        properties: {
          targetResourceId: secondaryApp.id
          priority: 2
        }
      }
    ]
  }
}
```

---

## Load Test Results (Example)

```markdown
# Load Test Results

## Configuration
| Setting | Value |
|---------|-------|
| Tool | k6 |
| Target | https://app-freshconnect-dev-swc.azurewebsites.net/ |
| Duration | 4 minutes |
| Peak Users | 500 |

## Results
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Concurrent Users | 500 | 500 | ✅ PASS |
| P95 Response Time | ≤2000ms | 847ms | ✅ PASS |
| Error Rate | ≤1% | 0.1% | ✅ PASS |
| Total Requests | — | 48,231 | — |

## Observations
1. Stable response times under load
2. No errors during ramp-up
3. P95 well under threshold
```

---

## Deployment Commands

```powershell
# Create resource group
az group create --name rg-freshconnect-dev-swc --location swedencentral

# What-If
az deployment group what-if `
  --resource-group rg-freshconnect-dev-swc `
  --template-file main.bicep `
  --parameters main.bicepparam

# Deploy
az deployment group create `
  --resource-group rg-freshconnect-dev-swc `
  --template-file main.bicep `
  --parameters main.bicepparam
```
