# Challenge 2: Architecture Assessment

> **Duration**: 45 minutes | **Agent**: architect | **Output**: `02-architecture-assessment.md`

## Objective

Use the **architect** agent to create a Well-Architected Framework (WAF) aligned architecture assessment with cost estimates.

## Instructions

### Step 1: Hand Off from Challenge 1 (5 min)

Switch to the **architect** agent in the Chat view (`Ctrl+Shift+I` to switch to Agent mode).

Invoke with:

```
Review the requirements in agent-output/freshconnect/01-requirements.md
and create a comprehensive WAF assessment with cost estimates.
```

### Step 2: Review WAF Analysis (20 min)

The **architect** agent will analyze your requirements against the five WAF pillars:

| Pillar                     | Key Questions                                              |
| -------------------------- | ---------------------------------------------------------- |
| **Reliability**            | How will the system handle failures? What's the SLA?       |
| **Security**               | How is data protected? Authentication model?               |
| **Cost Optimization**      | Does it fit the €500/month budget? Where can you optimize? |
| **Operational Excellence** | How will you monitor and maintain the system?              |
| **Performance Efficiency** | Can it handle 500 concurrent users?                        |

### Step 3: Review Service Selection (15 min)

Verify the proposed Azure services make sense:

| Capability   | Expected Service     | Alternative     |
| ------------ | -------------------- | --------------- |
| Web Portal   | App Service (Linux)  | Container Apps  |
| API Backend  | App Service (Linux)  | Azure Functions |
| Database     | Azure SQL Database   | Cosmos DB       |
| File Storage | Blob Storage         | —               |
| Secrets      | Key Vault            | —               |
| Monitoring   | Application Insights | —               |
| Logging      | Log Analytics        | —               |

### Step 4: Review Cost Estimate (15 min)

The Azure Pricing MCP will provide cost estimates. Verify:

- [ ] Total monthly cost is under €500
- [ ] Major cost drivers are identified
- [ ] Optimization opportunities are noted

**Expected cost breakdown:**

| Resource                | Estimated Cost  |
| ----------------------- | --------------- |
| App Service Plan (P1v3) | ~€75/month      |
| Azure SQL (S2)          | ~€60/month      |
| Storage Account         | ~€5/month       |
| Key Vault               | ~€1/month       |
| Application Insights    | ~€5/month       |
| Log Analytics           | ~€10/month      |
| **Total**               | **~€156/month** |

### Step 5: Approve and Save (5 min)

Ask the agent to create the file: `agent-output/freshconnect/02-architecture-assessment.md`

## Success Criteria

| Criterion                      | Points |
| ------------------------------ | ------ |
| Cost estimation included       | 5      |
| Reliability patterns addressed | 5      |
| Security controls identified   | 5      |
| Scalability approach defined   | 5      |
| Service selection justified    | 5      |
| **Total**                      | **25** |

## WAF Quick Reference

<details>
<summary>📊 Reliability Checklist</summary>

- [ ] SLA target defined and achievable
- [ ] RTO/RPO documented
- [ ] Backup strategy defined
- [ ] Failure modes identified
- [ ] Health monitoring configured

</details>

<details>
<summary>🔒 Security Checklist</summary>

- [ ] Authentication method defined
- [ ] TLS 1.2 minimum
- [ ] Secrets in Key Vault
- [ ] Network security considered
- [ ] Managed identities preferred

</details>

<details>
<summary>💰 Cost Checklist</summary>

- [ ] Within budget
- [ ] Right-sized SKUs
- [ ] Consumption vs. provisioned evaluated
- [ ] Dev/Test vs. Production considered

</details>

## Tips

- 💡 The **architect** agent will suggest trade-offs — understand them
- 💡 Cost estimates are approximate — actual costs may vary
- 💡 Don't gold-plate the MVP — focus on essential features
- 💡 Document assumptions and constraints

## Next Step

After architecture is approved, proceed to [Challenge 3: Implementation](challenge-3-implementation.md).

Optionally, generate design artifacts first:

```
@diagram Create an architecture diagram for FreshConnect based on
agent-output/freshconnect/02-architecture-assessment.md
```
