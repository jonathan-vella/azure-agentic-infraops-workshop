# Quick Reference Card

> **Print this page** (Ctrl+P → Save as PDF or print double-sided)

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Alt+I` | Open Chat view |
| `Ctrl+Shift+I` | Switch to Agent mode |
| `Ctrl+I` | Inline chat (editor/terminal) |
| `Ctrl+N` | New chat session |
| `Ctrl+Alt+.` | Model picker |
| `Tab` | Accept suggestion |
| `Escape` | Dismiss suggestion |

---

## Custom Agents

Select from the **agent dropdown** in Chat view:

| Agent | Purpose |
|-------|---------|
| **plan** | Capture requirements |
| **architect** | Design architecture (WAF) |
| **bicep-plan** | Create implementation plan |
| **bicep-code** | Generate Bicep templates |
| **deploy** | Deploy to Azure |

**How to use**: `Ctrl+Alt+I` → Click agent dropdown → Select agent → Type prompt

---

## Chat Features

| Feature | How to Use |
|---------|------------|
| **Context** | `#file`, `#folder`, `#symbol`, drag & drop |
| **Codebase search** | `#codebase` in prompt |
| **Fetch web page** | `#fetch url` |
| **Workspace** | `@workspace` for workspace questions |
| **Terminal** | `@terminal` for shell help |
| **Slash commands** | `/fix`, `/explain`, `/tests`, `/doc` |

---

## Essential CLI Commands

```bash
# Verify setup
az account show --query name -o tsv
bicep --version

# Create resource group
az group create -n rg-freshconnect-dev-swc -l swedencentral

# Validate Bicep
bicep build main.bicep
bicep lint main.bicep

# What-If deployment
az deployment group what-if -g rg-freshconnect-dev-swc -f main.bicep

# Deploy
az deployment group create -g rg-freshconnect-dev-swc -f main.bicep

# Cleanup (END OF DAY!)
az group delete -n rg-freshconnect-dev-swc --yes --no-wait
```

---

## Expected Outputs

| Challenge | Output File |
|-----------|-------------|
| 1 | `agent-output/{team}/01-requirements.md` |
| 2 | `agent-output/{team}/02-architecture-assessment.md` |
| 3 | `infra/bicep/{team}/main.bicep` + modules |
| 4 | Updated Bicep with DR |
| 5 | `agent-output/{team}/05-load-test-results.md` |

---

## Naming Conventions

| Resource | Pattern | Max |
|----------|---------|-----|
| Key Vault | `kv-{project}-{env}-{suffix}` | 24 |
| Storage | `st{project}{env}{suffix}` | 24 |
| SQL Server | `sql-{project}-{env}-{suffix}` | 63 |
| App Service | `app-{project}-{env}-{region}` | 60 |

**Generate unique suffix**:
```bicep
var uniqueSuffix = uniqueString(resourceGroup().id)
```

---

## Security Checklist

- [ ] `supportsHttpsTrafficOnly: true`
- [ ] `minimumTlsVersion: 'TLS1_2'`
- [ ] `allowBlobPublicAccess: false`
- [ ] `azureADOnlyAuthentication: true`
- [ ] Managed Identity (no connection strings)

---

## Budget Guide

| Phase | Budget | Region |
|-------|--------|--------|
| Challenges 1-3 | €500/month | swedencentral |
| After Curveball | €700/month | + germanywestcentral |

---

## Load Test Targets

| Metric | Target |
|--------|--------|
| Concurrent Users | 500 |
| P95 Response | ≤ 2 seconds |
| Error Rate | ≤ 1% |

---

## Help!

| Problem | Solution |
|---------|----------|
| Agent not responding | Reload VS Code window |
| Bicep won't compile | Check `bicep build` output |
| Name too long | Use `take()` function |
| Zone redundancy error | Use P1v3+ SKU |

---

**Team**: _________________ **Score**: _____/130
