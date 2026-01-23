# Quick Reference Card

> **Print this page** (Ctrl+P → Save as PDF or print double-sided)

---

## Hackathon Schedule (6 Hours)

| Time        | Challenge       | Duration | Points |
| ----------- | --------------- | -------- | ------ |
| 09:00-09:30 | Intro           | 30 min   | —      |
| 09:30-10:20 | **Challenge 1** | 50 min   | 20     |
| 10:20-11:10 | **Challenge 2** | 50 min   | 25     |
| 11:10-11:40 | 🍽️ Lunch        | 30 min   | —      |
| 11:40-12:40 | **Challenge 3** | 60 min   | 25     |
| 12:40-13:10 | **Challenge 4** | 30 min   | 10     |
| 13:10-13:30 | **Challenge 5** | 20 min   | 5      |
| 13:30-13:50 | **Challenge 6** | 20 min   | 5      |
| 13:50-14:00 | **Challenge 7** | 10 min   | 5      |
| 14:00-14:15 | Prep            | 15 min   | —      |
| 14:15-14:55 | **Challenge 8** | 40 min   | 10     |
| 14:55-15:00 | Wrap-up         | 5 min    | —      |

**Total Points**: 105 base + 25 bonus

---

## Keyboard Shortcuts

| Shortcut       | Action                        |
| -------------- | ----------------------------- |
| `Ctrl+Alt+I`   | Open Chat view                |
| `Ctrl+Shift+I` | Switch to Agent mode          |
| `Ctrl+I`       | Inline chat (editor/terminal) |
| `Ctrl+N`       | New chat session              |
| `Ctrl+Alt+.`   | Model picker                  |
| `Tab`          | Accept suggestion             |
| `Escape`       | Dismiss suggestion            |

---

## Custom Agents

Select from the **agent dropdown** in Chat view:

| Agent            | Purpose                    | Challenges |
| ---------------- | -------------------------- | ---------- |
| **requirements** | Capture requirements       | 1          |
| **architect**    | Design architecture (WAF)  | 2          |
| **bicep-plan**   | Create implementation plan | 3, 4       |
| **bicep-code**   | Generate Bicep templates   | 3, 4       |
| **docs**         | Generate documentation     | 6, 7       |
| **diagnose**     | Troubleshooting runbooks   | 7          |

**How to use**: `Ctrl+Alt+I` → Click agent dropdown → Select agent → Type prompt

---

## Chat Features

| Feature             | How to Use                                 |
| ------------------- | ------------------------------------------ |
| **Context**         | `#file`, `#folder`, `#symbol`, drag & drop |
| **Codebase search** | `#codebase` in prompt                      |
| **Fetch web page**  | `#fetch url`                               |
| **Workspace**       | `@workspace` for workspace questions       |
| **Terminal**        | `@terminal` for shell help                 |
| **Slash commands**  | `/fix`, `/explain`, `/tests`, `/doc`       |

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

| Challenge | Output File/Artifact                                |
| --------- | --------------------------------------------------- |
| 1         | `agent-output/{team}/01-requirements.md`            |
| 2         | `agent-output/{team}/02-architecture-assessment.md` |
| 3         | `infra/bicep/{team}/main.bicep` + modules           |
| 4         | Updated Bicep with DR + ADR document                |
| 5         | `agent-output/{team}/05-load-test-results.md`       |
| 6         | `agent-output/{team}/06-*.md` (documentation)       |
| 7         | `agent-output/{team}/07-*.md` (troubleshooting)     |
| 8         | Presentation (slides or markdown)                   |

---

## Pro Tips

**Challenge 3 — Mermaid Flowcharts:**

````markdown
````mermaid
graph TD
    A[Start] --> B[Decision]
    B -->|Yes| C[Deploy]
    B -->|No| D[Refine]
\```
````
````

**Challenge 4 — ADR Template:**

```markdown
# ADR: Multi-Region Disaster Recovery

## Context

[Why DR is needed now]

## Decision

[What approach we chose]

## Consequences

[Cost, complexity, benefits]
```

**Challenge 6 — Documentation Prompts:**

- "Generate ops runbook for [audience]"
- "Create cost breakdown with optimization tips"
- "Document DR procedures for compliance audit"

**Challenge 7 — Diagnostic Queries:**

```bash
# Quick health check
az webapp show --name <app-name> --resource-group <rg> --query state

# Application Insights query
az monitor app-insights query --app <app-id> \
  --analytics-query "requests | where timestamp > ago(1h) | summarize avg(duration)"
```

---

## Naming Conventions

| Resource    | Pattern                        | Max |
| ----------- | ------------------------------ | --- |
| Key Vault   | `kv-{project}-{env}-{suffix}`  | 24  |
| Storage     | `st{project}{env}{suffix}`     | 24  |
| SQL Server  | `sql-{project}-{env}-{suffix}` | 63  |
| App Service | `app-{project}-{env}-{region}` | 60  |

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

| Phase           | Budget     | Region               |
| --------------- | ---------- | -------------------- |
| Challenges 1-3  | €500/month | swedencentral        |
| After Curveball | €700/month | + germanywestcentral |

---

## Load Test Targets

| Metric           | Target      |
| ---------------- | ----------- |
| Concurrent Users | 500         |
| P95 Response     | ≤ 2 seconds |
| Error Rate       | ≤ 1%        |

---

## Help!

| Problem               | Solution                   |
| --------------------- | -------------------------- |
| Agent not responding  | Reload VS Code window      |
| Bicep won't compile   | Check `bicep build` output |
| Name too long         | Use `take()` function      |
| Zone redundancy error | Use P1v3+ SKU              |

---

**Team**: **\*\*\*\***\_**\*\*\*\*** **Score**: **\_**/130
