# Facilitator Guide

> **For hackathon coaches and facilitators only.**

## Event Overview

| Aspect | Details |
|--------|---------|
| Duration | 5 hours |
| Participants | 20-24 |
| Teams | 5-6 (3-4 members each) |
| Format | Challenge-based, full 7-step workflow |
| Skill Level | Azure portal familiar, new to IaC |

## Your Role

1. **Guide, don't solve** — Help teams find answers, don't write their code
2. **Monitor progress** — Check in with each team every 15-20 minutes
3. **Unblock quickly** — Don't let teams stall for more than 5 minutes on setup issues
4. **Encourage experimentation** — There's no single "correct" architecture
5. **Celebrate learning** — The goal is understanding, not perfection

---

## Pre-Event Setup

### Governance Policies (Optional but Recommended)

Deploy Azure Policies to create realistic governance constraints. Teams will encounter real policy errors!

```powershell
# Check current governance status
.\scripts\hackathon\Get-GovernanceStatus.ps1 -SubscriptionId "<sub-id>"

# Deploy hackathon policies (checks for existing before creating)
.\scripts\hackathon\Setup-GovernancePolicies.ps1 -SubscriptionId "<sub-id>"

# After event: Remove policies
.\scripts\hackathon\Remove-GovernancePolicies.ps1 -SubscriptionId "<sub-id>"
```

**Policies deployed:**

| Policy | Effect | Forces |
|--------|--------|--------|
| Allowed locations | Deny | Only `swedencentral`, `germanywestcentral` |
| Require Environment tag | Deny | Must tag all resources |
| Require Project tag | Deny | Must tag all resources |
| SQL Azure AD-only auth | Deny | No SQL passwords |
| Storage HTTPS only | Deny | `supportsHttpsTrafficOnly: true` |
| Storage min TLS 1.2 | Deny | `minimumTlsVersion: 'TLS1_2'` |
| Storage no public blob | Deny | `allowBlobPublicAccess: false` |
| App Service HTTPS | Deny | `httpsOnly: true` |

> ⚠️ **Note**: Policies take 5-15 minutes to become effective after deployment.

---

## Detailed Schedule

### Block 1: Intro (0:00 - 0:45)

| Time | Activity | Action |
|------|----------|--------|
| 0:00 | Welcome | Share WiFi, logistics |
| 0:05 | Overview | Walk through README.md |
| 0:15 | Workflow demo | Show 7-step diagram |
| 0:25 | Setup verification | Teams verify Dev Container, Azure |
| 0:35 | Team formation | Form teams, assign roles |
| 0:40 | Scenario briefing | Review scenario, clarify questions |

**Setup Check Script:**

```bash
az account show --query "{Subscription:name}" -o table
bicep --version
echo "✅ Ready!"
```

### Block 2: Challenge 1 - Requirements (0:45 - 1:45)

| Time | Activity | Action |
|------|----------|--------|
| 0:45 | Start | Ensure teams invoke **plan** agent correctly |
| 1:00 | Check-in | All teams started a conversation? |
| 1:15 | Progress | Draft requirements? |
| 1:30 | Push | Encourage approval |
| 1:45 | Break | 10 minutes |

**Common Issues:**

| Issue | Solution |
|-------|----------|
| Agent not responding | Reload VS Code window |
| Vague requirements | Ask "What SLA? What's RTO?" |

### Block 3: Challenge 2 - Architecture (1:55 - 2:55)

| Time | Activity | Action |
|------|----------|--------|
| 1:55 | Start | Verify handoff from **plan** agent |
| 2:10 | Check-in | Getting WAF recommendations? |
| 2:30 | Cost | Pricing MCP working? |
| 2:45 | Wrap | Finalize architecture doc |
| 2:55 | Break | 10 minutes |

### Block 4: Challenge 3 - Bicep (3:05 - 4:05)

| Time | Activity | Action |
|------|----------|--------|
| 3:05 | Start | Teams start **bicep-plan** agent |
| 3:20 | Plan | Implementation plan ready? |
| 3:30 | Code | Transition to **bicep-code** agent |
| 3:50 | Validate | Check `bicep build` |
| 4:05 | Break | 10 minutes |

**Common Issues:**

| Issue | Solution |
|-------|----------|
| Key Vault name too long | ≤24 chars |
| Storage account invalid | Lowercase+numbers only |

### Block 5: ⚡ CURVEBALL + Challenges 4-5 (4:15 - 5:00)

#### 📢 Announcement Script (4:15)

Stand up, get everyone's attention:

> *"ATTENTION ALL TEAMS! 📣*
>
> *We've just received urgent news from Nordic Fresh Foods headquarters!*
>
> *They've signed a major contract with a Danish restaurant chain — Smørrebrød Express — worth
> €500K annually. The board has mandated new business continuity requirements.*
>
> *Your infrastructure must now support:*
> - *Multi-region disaster recovery*
> - *RTO of 1 hour or less*
> - *RPO of 15 minutes or less*
> - *Secondary region: germanywestcentral*
>
> *Budget has increased by €200/month to accommodate this.*
>
> *You have 35 minutes! GO GO GO!* 🚀"

| Time | Activity | Action |
|------|----------|--------|
| 4:15 | Announce | Read the script! |
| 4:25 | DR | Teams update architecture |
| 4:35 | Load Test | Teams run k6 |
| 4:50 | Deploy | Final push |
| 5:00 | Wrap-up | Begin showcases |

### Block 6: Wrap-up (5:00 - 5:15)

```powershell
# Score all teams
Get-ChildItem .\agent-output -Directory | ForEach-Object {
    .\scripts\hackathon\Score-Team.ps1 -TeamName $_.Name -SkipAzureCheck
}

# Display leaderboard
.\scripts\hackathon\Get-Leaderboard.ps1
```

---

## Scoring

### Automated Scoring

```powershell
# Individual team
.\scripts\hackathon\Score-Team.ps1 -TeamName "freshconnect" -ResourceGroupName "rg-freshconnect-dev-swc"

# All teams
Get-ChildItem .\agent-output -Directory | Where-Object { $_.Name -ne ".gitkeep" } | ForEach-Object {
    .\scripts\hackathon\Score-Team.ps1 -TeamName $_.Name -SkipAzureCheck
}

# Leaderboard
.\scripts\hackathon\Get-Leaderboard.ps1
```

### Manual Verification (Bonus Points)

| Bonus | How to Verify |
|-------|---------------|
| Zone Redundancy | Portal → App Service Plan → Zone redundant |
| Private Endpoints | Portal → SQL/Storage → Networking |
| Multi-Region | Resources in `germanywestcentral` |
| Managed Identities | Portal → App Service → Identity |

---

## Common Errors

### Authentication

| Error | Solution |
|-------|----------|
| `AADSTS50076` | Use `az login --use-device-code` |
| `AuthorizationFailed` | Check subscription access |

### Bicep

| Error | Solution |
|-------|----------|
| `BCP035` | Missing required parameter |
| `BCP037` | Wrong property or API version |

### Deployment

| Error | Solution |
|-------|----------|
| `QuotaExceeded` | Try different region/SKU |
| `NameNotAvailable` | Use uniqueSuffix pattern |
| Zone redundancy | Use P1v3+ SKU |

---

## Team Progress Tracker

| Team | C1 | C2 | C3 | C4 | C5 | Deploy | Bonus |
|------|----|----|----|----|----|----|-------|
| 1 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | |
| 2 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | |
| 3 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | |
| 4 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | |
| 5 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | |
| 6 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | |

Legend: ⬜ Not started | 🔄 In progress | ✅ Complete

---

## Emergency Procedures

### Copilot Down

1. Announce to all teams
2. Use template files in `.github/templates/`
3. Extend time if needed

### Azure Issues

1. Check [status.azure.com](https://status.azure.com)
2. Try `germanywestcentral` region
3. Focus on Bicep generation if widespread

### Team Falls Behind

1. Offer direct help
2. Let them skip Challenge 3 design artifacts
3. Remind: learning > completion

---

## Post-Event

Remind teams:

```bash
az group delete --name rg-freshconnect-dev-swc --yes --no-wait
```

Collect feedback on what worked and what didn't.
