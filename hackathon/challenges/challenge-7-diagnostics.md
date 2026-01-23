# Challenge 7: Troubleshooting & Diagnostics

> **Duration**: 10 minutes | **Agent**: `docs` or Azure tooling | **Output**: Troubleshooting runbook

## The 2 AM Scenario

**INCIDENT ALERT** 🚨

```
Time: 2:17 AM Sunday
Alert: FreshConnect API response time degraded
Severity: High
P95 Latency: 8.2 seconds (threshold: 2 seconds)
Error Rate: 4.3% (threshold: 1%)
On-Call: You (first day on rotation)
```

You open your laptop. You have the Bicep templates. You have the architecture diagrams. But you don't have a
troubleshooting guide.

Where do you start? What do you check first? What commands do you run? When do you escalate?

## Your Challenge

Create a **troubleshooting runbook** that helps an on-call engineer diagnose and resolve common FreshConnect
infrastructure issues quickly and confidently.

### The Business Stakes

- **Customer Impact**: 500 concurrent users waiting for slow responses
- **Revenue Impact**: Order processing delays during peak dinner rush
- **Reputational Impact**: Restaurant partners questioning platform reliability
- **Team Impact**: On-call engineer needs to make decisions under pressure

**Question**: If you were handed the pager for FreshConnect tonight, what would you want documented?

## Guiding Questions

### Diagnostic Strategy

1. **What are the likely failure modes?**
   - Database connection exhaustion?
   - App Service resource limits?
   - Storage throttling?
   - Network connectivity issues?
   - External dependency failures?

2. **What's the diagnostic sequence?**
   - Check application health first, or infrastructure metrics?
   - Start with logs, or metrics?
   - Look at current state, or historical trends?

3. **What tools should you use?**
   - Azure Portal health dashboards?
   - Application Insights queries?
   - Azure Monitor metrics and alerts?
   - Kudu console / SSH for app inspection?
   - Azure CLI diagnostic commands?

4. **What are the quick fixes vs. escalations?**
   - Can on-call engineer restart services safely?
   - When should they wake up the architect?
   - What changes require approval vs. immediate action?

### Runbook Structure

Consider organizing your runbook like this:

```
1. Initial Assessment (First 60 seconds)
   - What to check immediately
   - Quick health indicators
   - Severity classification

2. Common Scenarios (Next 5-10 minutes)
   - Symptom: High API latency
     → Likely causes
     → Diagnostic steps
     → Remediation actions

   - Symptom: Database connection errors
     → ...

   - Symptom: Storage access failures
     → ...

3. Diagnostic Tools & Commands
   - Azure CLI commands for health checks
   - Application Insights queries
   - Metric alerts to investigate

4. Escalation Criteria
   - When to escalate vs. resolve
   - Contact information
   - What information to include in escalation

5. Post-Incident Actions
   - What to document
   - How to prevent recurrence
```

## Research & Discovery

You don't need to know everything. Here's what to research:

### Azure Monitoring Concepts

- **Application Insights**: How does it capture application telemetry? What queries are useful for diagnosing issues?
- **Azure Monitor**: What metrics are collected automatically? Which metrics indicate what problems?
- **Log Analytics**: How do you query logs across services? What's KQL (Kusto Query Language)?
- **Resource Health**: How does Azure report service health issues?

### Azure Diagnostic Tools

- **AppLens**: AI-powered diagnostics for Azure App Service (ask about `mcp_azure_mcp_applens` tool)
- **Azure CLI diagnostics**: `az webapp log tail`, `az monitor metrics list`, etc.
- **Application Insights Profiler**: Where are performance bottlenecks?
- **Connection Monitor**: Network connectivity troubleshooting

### Service-Specific Diagnostics

For FreshConnect infrastructure, consider:

- **App Service**: CPU%, Memory%, Response time, HTTP queue length
- **SQL Database**: DTU%, Connection count, Query performance
- **Storage Account**: Transactions/sec, E2E latency, Throttling errors
- **Key Vault**: Secret access patterns, Permission issues

## Example Approach: Start with Common Symptoms

### Symptom: Slow API Response Times

**Step 1: Check Application Insights**

```kusto
requests
| where timestamp > ago(15m)
| summarize avg(duration), percentiles(duration, 50, 95, 99) by name
| order by avg_duration desc
```

**Step 2: Identify slow dependencies**

```kusto
dependencies
| where timestamp > ago(15m)
| summarize avg(duration), percentiles(duration, 95, 99) by name, type
| order by avg_duration desc
```

**Step 3: Check Azure SQL metrics**

```bash
az monitor metrics list \
  --resource /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Sql/servers/{server}/databases/{db} \
  --metric "dtu_consumption_percent" \
  --start-time "2025-01-23T02:00:00Z" \
  --end-time "2025-01-23T02:30:00Z"
```

**What do these results tell you? What's the next diagnostic step?**

## Required Deliverable

Create a troubleshooting runbook that includes:

- [ ] **Quick Reference**: Top 3-5 checks to perform immediately
- [ ] **Common Scenarios**: At least 3 symptom-based diagnostic flows
- [ ] **Diagnostic Commands**: Specific Azure CLI or KQL queries to run
- [ ] **Remediation Actions**: What actions can resolve common issues
- [ ] **Escalation Criteria**: When to escalate vs. resolve independently

**Format**: Markdown document that could be printed and used during an incident

**Audience**: On-call engineer with basic Azure knowledge but unfamiliar with FreshConnect specifics

## Success Criteria

| Criterion                                       | Points |
| ----------------------------------------------- | ------ |
| Runbook addresses at least 3 common failure scenarios | 2      |
| Includes specific diagnostic commands/queries   | 1      |
| Clear decision points (check X, then Y)         | 1      |
| Actionable remediation steps provided           | 1      |
| **Total**                                       | **5**  |

## Coaching Questions

### As You Build This Runbook

- **If you were new to this system**, what context would you need to understand symptoms quickly?
- **Under pressure at 2 AM**, what format is easiest to follow? Numbered steps? Flowchart? Decision tree?
- **If you couldn't fix it**, what information should you collect for the person you escalate to?

### After You Finish

- **Incident Response Time**: Could someone use this runbook to diagnose issues in under 5 minutes?
- **Coverage**: What failure modes are NOT covered? Are those low-risk or should they be added?
- **Maintenance**: How would you keep this runbook accurate as infrastructure evolves?

## Time Management Tips

- **0-2 min**: Identify 3 most likely failure modes for FreshConnect
- **2-5 min**: Prompt `docs` agent or research diagnostic approaches for each failure mode
- **5-8 min**: Structure runbook with clear diagnostic flows
- **8-10 min**: Add specific commands/queries and escalation criteria

## What You're Learning

- **Operational Thinking**: Designing for failure, not just success
- **Incident Response**: Structured approaches to diagnosing production issues
- **Diagnostic Tools**: Azure Monitor, Application Insights, AppLens capabilities
- **Documentation Under Pressure**: What format helps someone make decisions quickly

## Pro Tips

💡 **Start with health checks**: "Is it up?" before "Why is it slow?"

💡 **Use decision trees**: IF this, THEN check that — clear branching logic

💡 **Include expected values**: "CPU should be <70%, if >90% then..."

💡 **Test your runbook**: Ask someone unfamiliar with FreshConnect to follow it

💡 **Link to tools**: Provide direct links to Application Insights, Azure Portal dashboards

## Next Step

Congratulations! You've completed the technical challenges. Move to [Challenge 8: Partner
Showcase](challenge-8-partner-showcase.md) to present your FreshConnect solution.
