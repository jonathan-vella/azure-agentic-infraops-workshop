# Challenge 1: Requirements Gathering

> **Duration**: 45 minutes | **Agent**: plan | **Output**: `01-requirements.md`

## Objective

Use the **plan** agent to capture comprehensive Azure infrastructure requirements for the FreshConnect platform.

## Instructions

### Step 1: Start the `plan` Agent (5 min)

Press `Ctrl+Alt+I` to open Copilot Chat, then `Ctrl+Shift+I` to switch to Agent mode.
Select the **plan** agent from the dropdown and paste:

```
I need to plan Azure infrastructure for "FreshConnect" - a farm-to-table delivery platform
for Nordic Fresh Foods.

Key context:
- Stockholm-based company, 500+ partner restaurants, 10,000 consumers
- Need web portal, API backend, database, file storage, secrets, monitoring
- Budget: ~€500/month for infrastructure
- Compliance: GDPR (EU data residency required)
- Timeline: 3 months to MVP for peak season
- Team: 3 developers + 1 DevOps (need managed services)

Expected peak load: 500 concurrent users, seasonal spikes (3x during summer/December)

Please help me capture comprehensive requirements for this project.
```

### Step 2: Answer Clarifying Questions (25 min)

The **plan** agent will ask questions. Use these answers as guidance:

| Question              | Suggested Answer                                                    |
| --------------------- | ------------------------------------------------------------------- |
| **SLA target?**       | 99.9% is acceptable for MVP                                         |
| **RTO/RPO?**          | RTO: 4 hours, RPO: 1 hour                                           |
| **Authentication?**   | Azure AD for internal users, Azure AD B2C for restaurants/consumers |
| **Network security?** | Public endpoints acceptable for MVP                                 |
| **Monitoring?**       | Application Insights + Log Analytics                                |
| **Backup strategy?**  | Azure-managed backups, 7-day retention                              |

### Step 3: Review and Approve (10 min)

1. Review the generated requirements draft
2. Request any changes or additions
3. Ask the agent to create the file: `agent-output/freshconnect/01-requirements.md`

### Step 4: Verify Output (5 min)

Confirm your requirements document includes:

- [ ] Project overview (name, type, timeline)
- [ ] Functional requirements (capabilities, users, integrations)
- [ ] Non-functional requirements (SLA, RTO, RPO, performance)
- [ ] Compliance requirements (GDPR, data residency)
- [ ] Budget (~€500/month)
- [ ] Regional preference (`swedencentral`)

## Success Criteria

| Criterion                       | Points |
| ------------------------------- | ------ |
| Document exists at correct path | 4      |
| Project context complete        | 4      |
| Functional requirements listed  | 4      |
| NFRs specified (SLA, RTO, RPO)  | 4      |
| Compliance identified           | 4      |
| **Total**                       | **20** |

## Tips

- 💡 Don't overthink — capture what you know now
- 💡 It's OK to mark items as "TBD" or "to be confirmed"
- 💡 The **plan** agent will suggest defaults for missing info
- 💡 Budget is approximate — the Pricing MCP will refine costs later

## Next Step

After requirements are approved, proceed to [Challenge 2: Architecture](challenge-2-architecture.md).

Hand off to the **architect** agent or manually invoke:

```
Review the requirements in agent-output/freshconnect/01-requirements.md
and create a comprehensive WAF assessment with cost estimates.
```
