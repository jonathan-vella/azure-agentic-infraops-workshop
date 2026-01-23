# Challenge 4: The Curveball — High Availability & Disaster Recovery

> **Duration**: 30 minutes | **Announced at**: 12:40 | **Output**: Updated architecture + Bicep + ADR

## ⚡ The Announcement

> **FACILITATOR READS AT 12:40:**
>
> _"ATTENTION ALL TEAMS! 📣_
>
> _We've just received urgent news from Nordic Fresh Foods headquarters!_
>
> _They've signed a major contract with a Danish restaurant chain — Smørrebrød Express — worth
> €500K annually. The board has convened an emergency meeting and approved increased infrastructure investment._
>
> _Your infrastructure must now support high availability with disaster recovery capabilities!_
>
> _You have 30 minutes to propose and plan the solution!_ 🚀"

## New Business Requirements

| Requirement          | Value                | Business Impact                               |
| -------------------- | -------------------- | --------------------------------------------- |
| **RTO**              | ≤1 hour              | Maximum acceptable downtime                   |
| **RPO**              | ≤15 minutes          | Maximum acceptable data loss                  |
| **Secondary Region** | `germanywestcentral` | Coverage for broader European market          |
| **Budget Increase**  | +€200/month          | Total infrastructure budget now ~€700/month   |
| **Timeline**         | 30 minutes           | Board needs decision on architecture approach |

## Your Challenge

You must decide: **What level of HA/DR does the business need?**

### Option A: Single-Region HA

- All resources in `swedencentral`
- Zone-redundant services where available
- Faster failover, lower cost
- Risk: Regional outage affects all services

### Option B: Multi-Region DR

- Primary: `swedencentral`, Secondary: `germanywestcentral`
- Geo-replication for data
- Higher cost, longer RTO
- Risk: Complexity in failover orchestration

### Option C: Multi-Region Active-Active

- Both regions serve traffic simultaneously
- Highest availability, highest cost
- Risk: Data consistency challenges

**Your Task**: Choose an approach and design it as a **parameterized solution**.

## Required Deliverables

### 1. Architecture Decision Record (ADR) ⭐ MANDATORY

Create: `agent-output/freshconnect/04-adr-ha-dr-strategy.md`

Your ADR must document:

**Context**: Why is this decision needed?

- What changed in the business requirements?
- What are the consequences of not addressing this?

**Decision**: What approach did you choose and why?

- Single-region HA vs multi-region DR vs active-active?
- Which services need redundancy?
- What's your failover strategy?

**Consequences**: What are the trade-offs?

- Cost implications (+€200 budget: is it enough?)
- Operational complexity
- RTO/RPO achievability
- Risks and mitigation strategies

**Alternatives Considered**: What did you reject and why?

- Why not the other options?
- What would make you reconsider?

### 2. Updated Bicep (Parameterized)

Add a parameter to your `main.bicep` that enables HA/DR:

**Concept**:

```bicep
param haStrategy string = 'single-region' // 'single-region' or 'multi-region'
param primaryLocation string = 'swedencentral'
param secondaryLocation string = 'germanywestcentral'
```

**Questions to Explore**:

- How do you prompt the `bicep-code` agent to add this capability?
- Which modules need to change?
- What resources must exist in both regions?
- How do you handle data replication?

### 3. Updated Cost Estimate

**Consider**:

- Does your solution fit in the +€200 budget increase?
- What are the major cost drivers for HA/DR?
- Where could you optimize if over budget?

## Guiding Questions

**Architecture Questions**:

- What services can be zone-redundant within a single region?
- Which services require geo-replication for multi-region?
- How does Traffic Manager vs Front Door vs Application Gateway differ for failover?
- What's the replication lag for SQL geo-replication? Does it meet 15-minute RPO?

**Cost Questions**:

- What's the incremental cost of zone redundancy (single region)?
- What's the incremental cost of full multi-region deployment?
- Which services double in cost? Which don't?
- Can you achieve RTO/RPO targets within +€200?

**Operational Questions**:

- Who triggers failover? Automatic or manual?
- How do you test DR without affecting production?
- What's the recovery procedure?
- What documentation does the ops team need?

**Prompt Engineering Questions**:

- How do you ask the `bicep-code` agent to add DR capabilities?
- What context does the agent need to make good choices?
- How do you validate the agent's DR implementation?

## Concepts to Research

### SQL Geo-Replication

**Pattern**: Primary database + read-only replica in secondary region

**Key Questions**:

- What Bicep resource creates a geo-replica?
- What's the `createMode` property value?
- How do you reference the source database?
- What's the replication lag?

### Traffic Management

**Options**: Traffic Manager, Front Door, Application Gateway

**Key Questions**:

- Which option best fits this scenario?
- How do you configure health probes?
- What's the failover time?
- How does DNS caching affect RTO?

### Storage Redundancy

**Options**: LRS, ZRS, GRS, GZRS

**Key Questions**:

- What redundancy level meets RPO requirements?
- What's the cost difference?
- Is GRS automatic failover? Or manual?

## Success Criteria

| Criterion                           | Points |
| ----------------------------------- | ------ |
| ADR documented with clear rationale | 3      |
| HA/DR approach chosen and justified | 2      |
| Bicep parameterized for HA strategy | 2      |
| Cost estimate updated               | 2      |
| Trade-offs clearly understood       | 1      |
| **Total**                           | **10** |

## Time Management Tips

💡 **15 minutes**: Architecture Decision Record
💡 **10 minutes**: Prompt the `bicep-code` agent with your requirements
💡 **5 minutes**: Review generated changes and update cost estimate

Don't try to deploy in this challenge - focus on design and planning!

## Coaching Approach

This challenge tests your ability to:

- Make informed decisions under time pressure
- Balance business needs with technical constraints
- Document architectural decisions clearly
- Use AI agents effectively with well-crafted prompts

**Remember**: There's no single "right answer" - the quality of your decision-making process matters more than the specific option you choose.

## Next Step

After completing your ADR and Bicep updates:

Proceed to [Challenge 5: Load Testing](challenge-5-load-testing.md) to validate your infrastructure can handle the expected load.
