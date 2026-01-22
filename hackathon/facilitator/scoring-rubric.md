# Scoring Rubric

> **100-point base + 25 bonus** | WAF-aligned | 🤖 Automated via `Score-Team.ps1`

> **Note**: Challenge 6 (Partner Showcase) is **not scored** — it focuses on professional
> communication and soft skills development.

## Automated Scoring

```powershell
# Score team
.\scripts\hackathon\Score-Team.ps1 -TeamName "freshconnect" -ResourceGroupName "rg-freshconnect-dev-swc"

# Score without Azure verification
.\scripts\hackathon\Score-Team.ps1 -TeamName "freshconnect" -SkipAzureCheck

# Leaderboard
.\scripts\hackathon\Get-Leaderboard.ps1
```

Results saved to `agent-output/{team}/score-results.json`.

---

## Scoring Overview

| Category                | Points  | Automated? |
| ----------------------- | ------- | ---------- |
| Requirements & Planning | 20      | ✅         |
| Architecture Design     | 25      | ✅         |
| Implementation Quality  | 25      | ✅         |
| Deployment Success      | 20      | ✅         |
| Documentation           | 10      | ✅         |
| **Base Total**          | **100** |            |
| Load Testing            | +5      | ✅         |
| **Bonus Points**        | +25     | ✅         |
| **Max Total**           | **130** |            |

---

## Detailed Criteria

### 1. Requirements (20 pts)

**File**: `agent-output/{team}/01-requirements.md`

| Criterion                | Points |
| ------------------------ | ------ |
| Project context complete | 4      |
| Functional requirements  | 4      |
| NFRs (SLA, RTO, RPO)     | 4      |
| Compliance identified    | 4      |
| Budget stated            | 4      |

### 2. Architecture (25 pts)

**File**: `agent-output/{team}/02-architecture-assessment.md`

| Criterion            | Points |
| -------------------- | ------ |
| Cost estimation      | 5      |
| Reliability patterns | 5      |
| Security controls    | 5      |
| Scalability approach | 5      |
| Service selection    | 5      |

### 3. Implementation (25 pts)

**Files**: `infra/bicep/{team}/`

| Criterion          | Points |
| ------------------ | ------ |
| Bicep compiles     | 5      |
| Bicep lints clean  | 5      |
| Naming conventions | 5      |
| Security hardened  | 5      |
| Modular structure  | 5      |

### 4. Deployment (20 pts)

**Verification**: Azure Portal / CLI

| Criterion              | Points |
| ---------------------- | ------ |
| What-If executed       | 4      |
| Deployment succeeded   | 8      |
| Core resources running | 4      |
| Summary documented     | 4      |

### 5. Documentation (10 pts)

| Criterion             | Points |
| --------------------- | ------ |
| All artifacts present | 4      |
| Design artifacts      | 3      |
| Clear formatting      | 3      |

### 6. Load Testing (+5 pts)

**File**: `agent-output/{team}/05-load-test-results.md`

| Criterion          | Points |
| ------------------ | ------ |
| Test executed      | 2      |
| Targets documented | 1      |
| Results analyzed   | 2      |

---

## Bonus Points (+25 max)

| Enhancement        | Points | Verification                          |
| ------------------ | ------ | ------------------------------------- |
| Zone Redundancy    | +5     | P1v3+ SKU, `zoneRedundant: true`      |
| Private Endpoints  | +5     | PE resources in Bicep                 |
| Multi-Region DR    | +10    | Resources in 2+ regions               |
| Managed Identities | +5     | SystemAssigned, no connection strings |

---

## Score Sheet

| Team | Req | Arch | Impl | Deploy | Docs | Load | Bonus | Total |
| ---- | --- | ---- | ---- | ------ | ---- | ---- | ----- | ----- |
| 1    | /20 | /25  | /25  | /20    | /10  | /5   |       |       |
| 2    | /20 | /25  | /25  | /20    | /10  | /5   |       |       |
| 3    | /20 | /25  | /25  | /20    | /10  | /5   |       |       |
| 4    | /20 | /25  | /25  | /20    | /10  | /5   |       |       |
| 5    | /20 | /25  | /25  | /20    | /10  | /5   |       |       |
| 6    | /20 | /25  | /25  | /20    | /10  | /5   |       |       |

---

## Grading Scale

| Percentage | Grade                |
| ---------- | -------------------- |
| ≥90%       | 🏆 OUTSTANDING       |
| ≥80%       | 🥇 EXCELLENT         |
| ≥70%       | 🥈 GOOD              |
| ≥60%       | 🥉 SATISFACTORY      |
| <60%       | 📚 NEEDS IMPROVEMENT |

---

## Award Categories (Optional)

| Award                | Criteria         |
| -------------------- | ---------------- |
| 🏆 Best Overall      | Highest total    |
| 🛡️ Security Champion | Best security    |
| 💰 Cost Optimizer    | Best efficiency  |
| 📐 Best Architecture | Most WAF-aligned |
| 🚀 Speed Demon       | First to deploy  |
