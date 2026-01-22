# Facilitator Guide

> **For hackathon coaches and facilitators only.**

## Event Overview

| Aspect       | Details                               |
| ------------ | ------------------------------------- |
| Duration     | 5 hours                               |
| Participants | 20-24                                 |
| Teams        | 5-6 (3-4 members each)                |
| Format       | Challenge-based, full 7-step workflow |
| Skill Level  | Azure portal familiar, new to IaC     |

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

| Policy                  | Effect | Forces                                     |
| ----------------------- | ------ | ------------------------------------------ |
| Allowed locations       | Deny   | Only `swedencentral`, `germanywestcentral` |
| Require Environment tag | Deny   | Must tag all resources                     |
| Require Project tag     | Deny   | Must tag all resources                     |
| SQL Azure AD-only auth  | Deny   | No SQL passwords                           |
| Storage HTTPS only      | Deny   | `supportsHttpsTrafficOnly: true`           |
| Storage min TLS 1.2     | Deny   | `minimumTlsVersion: 'TLS1_2'`              |
| Storage no public blob  | Deny   | `allowBlobPublicAccess: false`             |
| App Service HTTPS       | Deny   | `httpsOnly: true`                          |

> ⚠️ **Note**: Policies take 5-15 minutes to become effective after deployment.

---

## Schedule

📅 **See [AGENDA.md](../AGENDA.md) for the full schedule overview.**

> **Event runs 10:00 - 15:00** (5 hours with 35-min lunch)

---

## Block-by-Block Facilitator Notes

### Block 1: Intro (10:00 - 10:30)

**Setup Check Script:**

```bash
az account show --query "{Subscription:name}" -o table
bicep --version
echo "✅ Ready!"
```

### Block 2: Challenge 1 - Requirements (10:30 - 11:15)

**Common Issues:**

| Issue                | Solution                    |
| -------------------- | --------------------------- |
| Agent not responding | Reload VS Code window       |
| Vague requirements   | Ask "What SLA? What's RTO?" |

### Block 3: Challenge 2 - Architecture (11:15 - 12:00)

No common issues — monitor Pricing MCP functionality.

### 🍽️ Lunch Break (12:00 - 12:35)

### Block 4: Challenge 3 - Bicep (12:35 - 13:20)

**Common Issues:**

| Issue                   | Solution               |
| ----------------------- | ---------------------- |
| Key Vault name too long | ≤24 chars              |
| Storage account invalid | Lowercase+numbers only |

### Block 5: ⚡ CURVEBALL + Challenges 4-5 (13:20 - 14:00)

#### 📢 Announcement Script (13:20)

Stand up, get everyone's attention:

> _"ATTENTION ALL TEAMS! 📣_
>
> _We've just received urgent news from Nordic Fresh Foods headquarters!_
>
> _They've signed a major contract with a Danish restaurant chain — Smørrebrød Express — worth
> €500K annually. The board has mandated new business continuity requirements._
>
> _Your infrastructure must now support:_
>
> - _Multi-region disaster recovery_
> - _RTO of 1 hour or less_
> - _RPO of 15 minutes or less_
> - _Secondary region: germanywestcentral_
>
> _Budget has increased by €200/month to accommodate this._
>
> _You have 20 minutes! GO GO GO!_ 🚀"

### 🎯 Presentation Prep (14:00 - 14:15)

**Facilitator Actions:**

- Remind teams of the 4-min pitch + 2-min Q&A format
- Share the [Presentation Template](../challenges/challenge-6-partner-showcase.md#what-to-present)
- Assign team pairings (see below)
- Set up presentation area (projector, timer)

### Block 6: Challenge 6 - Partner Showcase 🎤 (14:15 - 14:55)

#### Presentation Setup

Pair teams for the role-play:

| Presenting (Partner) | Challenging (Customer) |
| -------------------- | ---------------------- |
| Team 1               | Team 2                 |
| Team 2               | Team 3                 |
| Team 3               | Team 4                 |
| Team 4               | Team 5                 |
| Team 5               | Team 6                 |
| Team 6               | Team 1                 |

#### 📢 Announcement Script (14:15)

> _"Time for the Partner Showcase! 🎤_
>
> _Each team will present their FreshConnect solution. You are now the **Partner** pitching to Nordic Fresh Foods._
>
> _When you're not presenting, you'll play the **Customer** — asking tough but fair questions!_
>
> _Format: 4 min pitch + 2 min Q&A + 30 sec transition._
>
> _Team 1, you're up first!"_

> **Tip**: Keep presentations moving! Use a visible timer.

#### Facilitator Feedback Focus

After each presentation, briefly comment on:

| Area                | Look For                                         |
| ------------------- | ------------------------------------------------ |
| **Clarity**         | Was the solution easy to understand?             |
| **Justification**   | Were decisions well-reasoned?                    |
| **WAF Alignment**   | Reliability, security, cost, operations covered? |
| **Professionalism** | How would this land with a real customer?        |

### Wrap-up (14:55 - 15:00)

```powershell
# Score all teams
Get-ChildItem .\agent-output -Directory | ForEach-Object {
    .\scripts\hackathon\Score-Team.ps1 -TeamName $_.Name -SkipAzureCheck
}

# Display leaderboard
.\scripts\hackathon\Get-Leaderboard.ps1
```

- Share key learnings from presentations
- Announce final leaderboard
- Remind teams to clean up resources

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

| Bonus              | How to Verify                              |
| ------------------ | ------------------------------------------ |
| Zone Redundancy    | Portal → App Service Plan → Zone redundant |
| Private Endpoints  | Portal → SQL/Storage → Networking          |
| Multi-Region       | Resources in `germanywestcentral`          |
| Managed Identities | Portal → App Service → Identity            |

---

## Common Errors

### Authentication

| Error                 | Solution                         |
| --------------------- | -------------------------------- |
| `AADSTS50076`         | Use `az login --use-device-code` |
| `AuthorizationFailed` | Check subscription access        |

### Bicep

| Error    | Solution                      |
| -------- | ----------------------------- |
| `BCP035` | Missing required parameter    |
| `BCP037` | Wrong property or API version |

### Deployment

| Error              | Solution                 |
| ------------------ | ------------------------ |
| `QuotaExceeded`    | Try different region/SKU |
| `NameNotAvailable` | Use uniqueSuffix pattern |
| Zone redundancy    | Use P1v3+ SKU            |

---

## Team Progress Tracker

| Team | C1  | C2  | C3  | C4  | C5  | C6  | Deploy | Bonus |
| ---- | --- | --- | --- | --- | --- | --- | ------ | ----- |
| 1    | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜     |       |
| 2    | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜     |       |
| 3    | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜     |       |
| 4    | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜     |       |
| 5    | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜     |       |
| 6    | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜  | ⬜     |       |

Legend: ⬜ Not started | 🔄 In progress | ✅ Complete

> **Note**: C6 (Partner Showcase) is not scored — track completion only.

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
