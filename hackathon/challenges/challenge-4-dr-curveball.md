# Challenge 4: The Curveball — Multi-Region DR

> **Duration**: 20 minutes | **Announced at**: 4:15 | **Output**: Updated architecture + Bicep

## ⚡ The Announcement

> **FACILITATOR READS AT 4:15:**
>
> *"ATTENTION ALL TEAMS! 📣*
>
> *We've just received urgent news from Nordic Fresh Foods headquarters!*
>
> *They've signed a major contract with a Danish restaurant chain — Smørrebrød Express — worth €500K annually. The board has convened an emergency meeting and mandated new business continuity requirements.*
>
> *Your infrastructure must now support multi-region disaster recovery!*
>
> *The clock is ticking! You have 20 minutes!* 🚀"

## New Requirements

| Requirement | Value | Impact |
|-------------|-------|--------|
| **RTO** | ≤1 hour | Must recover operations within 1 hour |
| **RPO** | ≤15 minutes | Maximum 15 minutes of data loss acceptable |
| **Secondary Region** | `germanywestcentral` | Fallback region for DR |
| **Budget Increase** | +€200/month | Total now ~€700/month |

## What You Must Do

### Option A: Full Implementation (Bonus Points)

1. Update architecture document with DR strategy
2. Add secondary region resources to Bicep
3. Configure geo-replication for SQL
4. Add Traffic Manager or Front Door for failover
5. Deploy to both regions

### Option B: Minimum Viable DR (Time-Constrained)

1. Document the DR strategy in architecture assessment
2. Add secondary region parameters to Bicep (even if not deployed)
3. Show you understand the pattern

## Quick Implementation Guide

### 1. Add Secondary Region to Bicep

```bicep
// main.bicep - Add parameter
param primaryLocation string = 'swedencentral'
param secondaryLocation string = 'germanywestcentral'
param enableDR bool = true
```

### 2. Add SQL Geo-Replication

```bicep
// modules/sql-database.bicep - Add geo-replica
resource sqlGeoReplica 'Microsoft.Sql/servers@2023-05-01-preview' = if (enableDR) {
  name: 'sql-${projectName}-${environment}-gwc'
  location: secondaryLocation
  properties: {
    administratorLogin: sqlAdminLogin
    azureADOnlyAuthentication: true
  }
}

resource dbReplica 'Microsoft.Sql/servers/databases@2023-05-01-preview' = if (enableDR) {
  parent: sqlGeoReplica
  name: databaseName
  location: secondaryLocation
  properties: {
    createMode: 'OnlineSecondary'
    sourceDatabaseId: sqlDatabase.id
  }
}
```

### 3. Add Traffic Manager

```bicep
// modules/traffic-manager.bicep
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
          targetResourceId: primaryAppService.id
          priority: 1
        }
      }
      {
        name: 'secondary'
        type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
        properties: {
          targetResourceId: secondaryAppService.id
          priority: 2
        }
      }
    ]
  }
}
```

### 4. Update Architecture Document

Add a section to `02-architecture-assessment.md`:

```markdown
## Disaster Recovery Strategy

### RTO/RPO Targets
- **RTO**: 1 hour (automated failover via Traffic Manager)
- **RPO**: 15 minutes (SQL geo-replication with async mode)

### DR Components
| Component | Primary | Secondary | Failover Method |
|-----------|---------|-----------|-----------------|
| App Service | swedencentral | germanywestcentral | Traffic Manager |
| SQL Database | swedencentral | germanywestcentral | Geo-replication |
| Storage | GRS | - | Automatic |
| Key Vault | swedencentral | germanywestcentral | Manual |

### Failover Process
1. Traffic Manager detects primary endpoint failure
2. DNS automatically routes to secondary endpoint
3. SQL failover group promotes replica to primary
4. Runbook notifies operations team
```

## Success Criteria

| Criterion | Points |
|-----------|--------|
| DR strategy documented | 3 |
| Secondary region in Bicep | 3 |
| SQL geo-replication configured | 4 |
| Traffic Manager/Front Door added | 5 |
| **Bonus: Automated failover** | +10 |

## Tips

- 💡 Focus on documentation if time is short
- 💡 SQL geo-replication takes time to set up — start early
- 💡 Traffic Manager is simpler than Front Door for this scenario
- 💡 You can add the Bicep code without deploying it

## Next Step

After DR is addressed, proceed to [Challenge 5: Load Testing](challenge-5-load-testing.md).
