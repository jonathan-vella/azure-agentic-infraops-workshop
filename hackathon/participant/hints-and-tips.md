# Hints & Tips

> **Spoiler warning**: Only reveal these if you're stuck!

## Architecture Hints

<details>
<summary>💡 Service Selection (click to reveal)</summary>

A typical solution might include:

| Capability | Recommended Service | Why |
|------------|---------------------|-----|
| Web Portal | App Service (Linux, P1v3) | Managed, scalable, slots |
| API Backend | App Service (same plan) | Share the plan to save cost |
| Database | Azure SQL (S2 or Serverless) | Managed, geo-replication |
| File Storage | Storage Account (Standard LRS) | Cheap, durable |
| Secrets | Key Vault (Standard) | Azure-native, RBAC |
| Monitoring | Application Insights | Auto-instrumentation |
| Logging | Log Analytics | Centralized queries |

This combination fits within €500/month with room to spare.

</details>

<details>
<summary>💰 Cost Optimization (click to reveal)</summary>

**Quick Wins:**

- Use **App Service slots** for staging instead of separate App Services
- Consider **SQL Serverless** for Dev/Test (auto-pause when idle)
- Use **Managed Identities** to avoid Key Vault secret rotation complexity
- **Reserved Instances** for production (future optimization, not MVP)
- Share **App Service Plan** across web + API

**Estimated Costs:**

| Resource | SKU | Monthly |
|----------|-----|---------|
| App Service Plan | P1v3 | ~€75 |
| Azure SQL | S2 (50 DTU) | ~€60 |
| Storage Account | Standard LRS | ~€5 |
| Key Vault | Standard | ~€1 |
| Application Insights | — | ~€5 |
| Log Analytics | — | ~€10 |
| **Total** | | **~€156** |

Plenty of headroom under €500!

</details>

<details>
<summary>🔒 Security & Compliance (click to reveal)</summary>

**GDPR Compliance:**

- Deploy to `swedencentral` (EU region) ✅
- Enable **TLS 1.2** minimum on all services
- Use **Azure AD** for authentication
- Enable **diagnostic logging** for audit trails
- Consider **Azure Policy** for compliance guardrails

**Security Best Practices:**

```bicep
// Always set these on Storage Accounts
properties: {
  supportsHttpsTrafficOnly: true
  minimumTlsVersion: 'TLS1_2'
  allowBlobPublicAccess: false
}

// Use managed identities
identity: {
  type: 'SystemAssigned'
}
```

</details>

<details>
<summary>🏗️ Bicep Patterns (click to reveal)</summary>

**UniqueString Pattern:**

```bicep
// main.bicep - Generate ONCE, pass everywhere
var uniqueSuffix = uniqueString(resourceGroup().id)

// In modules, receive as parameter
param uniqueSuffix string

// Use in resource names
var kvName = 'kv-${take(projectName, 8)}-${environment}-${take(uniqueSuffix, 6)}'
```

**Naming Constraints:**

| Resource | Max Length | Allowed Chars |
|----------|------------|---------------|
| Key Vault | 24 | alphanumeric, hyphens |
| Storage Account | 24 | lowercase, numbers only |
| SQL Server | 63 | lowercase, numbers, hyphens |

**Required Tags:**

```bicep
var tags = {
  Environment: environment      // dev, staging, prod
  ManagedBy: 'Bicep'
  Project: projectName
  Owner: owner
}
```

</details>

<details>
<summary>🌍 Multi-Region DR (Challenge 4)</summary>

**Key Components:**

| Component | Primary | Secondary | Failover |
|-----------|---------|-----------|----------|
| App Service | swedencentral | germanywestcentral | Traffic Manager |
| SQL Database | swedencentral | germanywestcentral | Geo-replication |
| Storage | swedencentral | — | Use GRS |
| Key Vault | swedencentral | germanywestcentral | Manual sync |

**Minimal Implementation:**

1. Add `secondaryLocation` parameter
2. Create SQL geo-replica
3. Add Traffic Manager profile
4. Update architecture docs

**SQL Geo-Replication:**

```bicep
resource dbReplica 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  name: 'freshconnect-db'
  location: secondaryLocation
  properties: {
    createMode: 'OnlineSecondary'
    sourceDatabaseId: primaryDatabase.id
  }
}
```

</details>

<details>
<summary>🔥 Load Testing Quick Start</summary>

**k6 (Recommended):**

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 100 },
    { duration: '2m', target: 500 },
    { duration: '1m', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['p(95)<2000'],
    http_req_failed: ['rate<0.01'],
  },
};

export default function () {
  const res = http.get('https://YOUR-APP.azurewebsites.net/');
  check(res, { 'status is 200': (r) => r.status === 200 });
  sleep(1);
}
```

**Run:**

```bash
k6 run load-test.js
```

</details>

## Common Mistakes to Avoid

| Mistake | Solution |
|---------|----------|
| Key Vault name too long | Use `kv-${take(name, 8)}-${env}-${take(suffix, 6)}` |
| Storage account with hyphens | Use lowercase letters and numbers only |
| Missing uniqueSuffix | Generate once in main.bicep, pass to all modules |
| Hardcoded secrets | Use Key Vault references or managed identity |
| Over-engineering MVP | Keep it simple — you have 5 hours! |
| Forgetting to deploy | Run `bicep build` often, deploy incrementally |

## Agent-Specific Tips

### plan Agent

- Be specific about your requirements
- Answer clarifying questions thoroughly
- Don't be afraid to say "I don't know" — the agent will suggest defaults

### architect Agent

- Trust the WAF analysis
- Question cost estimates if they seem off
- Ask about trade-offs between options

### bicep-plan Agent

- Review the module structure before moving to code
- Ensure dependencies are in the right order
- Check for governance constraints

### bicep-code Agent

- Let it generate first, then refine
- Run `bicep build` after each major change
- Check for lint warnings (not all are critical)

---

## Still Stuck?

Raise your hand and ask a facilitator! That's what they're here for. 🙋
