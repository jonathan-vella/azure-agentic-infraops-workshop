# Challenge 3: Bicep Implementation

> **Duration**: 40 minutes | **Agents**: bicep-plan, bicep-code | **Output**: Bicep templates

## Objective

Generate an implementation plan and Bicep templates for the FreshConnect infrastructure.

## Instructions

### Part A: Implementation Planning (20 min)

#### Step 1: Invoke Bicep Plan Agent

Switch to the **bicep-plan** agent in Chat view (`Ctrl+Shift+I` to switch to Agent mode):

```
Create an implementation plan for FreshConnect based on
agent-output/freshconnect/02-architecture-assessment.md
```

#### Step 2: Review the Plan

The **bicep-plan** agent will:

1. Analyze your architecture
2. Discover Azure governance constraints (policies, quotas)
3. Create a phased implementation plan

Verify the plan includes:

- [ ] Module structure (which Bicep files to create)
- [ ] Dependencies (what deploys first)
- [ ] Naming conventions (CAF-aligned)
- [ ] Security settings (TLS, HTTPS-only)

#### Step 3: Approve and Save

Ask the agent to create: `agent-output/freshconnect/04-implementation-plan.md`

---

### Part B: Code Generation (35 min)

#### Step 4: Invoke Bicep Code Agent

Switch to the **bicep-code** agent:

```
Generate Bicep templates for FreshConnect based on
agent-output/freshconnect/04-implementation-plan.md
```

#### Step 5: Review Generated Code

The **bicep-code** agent will create:

```
infra/bicep/freshconnect/
├── main.bicep              # Orchestrator
├── main.bicepparam         # Parameters
├── deploy.ps1              # Deployment script
└── modules/
    ├── app-service.bicep   # App Service Plan + Web Apps
    ├── sql-database.bicep  # Azure SQL
    ├── storage.bicep       # Storage Account
    ├── key-vault.bicep     # Key Vault
    └── monitoring.bicep    # App Insights + Log Analytics
```

#### Step 6: Validate Bicep (5 min)

```bash
# Navigate to the generated folder
cd infra/bicep/freshconnect

# Build (check for syntax errors)
bicep build main.bicep

# Lint (check for best practices)
bicep lint main.bicep
```

## Critical Patterns

### UniqueString for Resource Names

```bicep
// main.bicep - Generate ONCE, pass to ALL modules
var uniqueSuffix = uniqueString(resourceGroup().id)

module keyVault 'modules/key-vault.bicep' = {
  params: {
    uniqueSuffix: uniqueSuffix
  }
}
```

### Required Tags

```bicep
var tags = {
  Environment: environment
  ManagedBy: 'Bicep'
  Project: projectName
  Owner: owner
}
```

### Security Defaults

```bicep
// Storage Account
properties: {
  supportsHttpsTrafficOnly: true
  minimumTlsVersion: 'TLS1_2'
  allowBlobPublicAccess: false
}
```

## Success Criteria

| Criterion                       | Points |
| ------------------------------- | ------ |
| Bicep compiles without errors   | 5      |
| Bicep lints clean (warnings OK) | 5      |
| CAF naming conventions used     | 5      |
| Security settings applied       | 5      |
| Modular structure               | 5      |
| **Total**                       | **25** |

## Common Issues

| Issue                         | Solution                                                                   |
| ----------------------------- | -------------------------------------------------------------------------- |
| Key Vault name too long       | Max 24 chars: `kv-${take(projectName, 8)}-${env}-${take(uniqueSuffix, 6)}` |
| Storage account invalid       | Lowercase + numbers only, no hyphens                                       |
| SQL Azure AD policy error     | Set `azureADOnlyAuthentication: true`                                      |
| Zone redundancy not supported | Use P1v3 or higher for App Service Plan                                    |

## Tips

- 💡 Let the agent generate first, then refine
- 💡 Don't fix every lint warning — focus on errors
- 💡 Run `bicep build` frequently to catch issues early
- 💡 Check the Azure Policy constraints for your subscription

## Deployment Preview

Before deploying, preview changes:

```powershell
# Create resource group
az group create --name rg-freshconnect-dev-swc --location swedencentral

# What-If (preview changes)
az deployment group what-if `
  --resource-group rg-freshconnect-dev-swc `
  --template-file main.bicep `
  --parameters main.bicepparam
```

## Next Step

After Bicep is generated and validated:

1. **Deploy** your infrastructure (use the generated `deploy.ps1`)
2. Wait for [Challenge 4: DR Curveball](challenge-4-dr-curveball.md) announcement at 4:15!

```powershell
# Deploy
./deploy.ps1

# Or manually
az deployment group create `
  --resource-group rg-freshconnect-dev-swc `
  --template-file main.bicep `
  --parameters main.bicepparam
```
