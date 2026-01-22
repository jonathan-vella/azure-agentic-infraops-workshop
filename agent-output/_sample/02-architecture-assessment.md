# Architecture Assessment

> **Project**: [Your Project Name]
> **Date**: [Date]
> **Architect**: @architect agent

## 1. Solution Overview

[High-level description of the proposed architecture]

## 2. Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        [Your Diagram]                        │
│                                                              │
│   [Internet] → [App Gateway/WAF] → [App Service]            │
│                                          ↓                   │
│                              [Azure SQL] ← [Key Vault]       │
│                                          ↓                   │
│                              [Storage Account]               │
│                                          ↓                   │
│                         [Application Insights]               │
└─────────────────────────────────────────────────────────────┘
```

## 3. Azure Services

| Service | SKU | Purpose | Monthly Cost |
|---------|-----|---------|--------------|
| App Service Plan | P1v3 | Web hosting | €X |
| Azure SQL | S2 | Database | €X |
| Storage Account | Standard LRS | Blob storage | €X |
| Key Vault | Standard | Secrets | €X |
| Application Insights | — | Monitoring | €X |
| **Total** | | | **€X** |

## 4. Well-Architected Assessment

### 4.1 Reliability

| Pattern | Implementation |
|---------|----------------|
| Redundancy | [How achieved] |
| Backup | [Strategy] |
| Health probes | [Configuration] |

### 4.2 Security

| Control | Implementation |
|---------|----------------|
| Identity | Managed Identity |
| Encryption | TLS 1.2, AES-256 |
| Network | [Approach] |

### 4.3 Cost Optimization

| Strategy | Savings |
|----------|---------|
| Right-sizing | [Details] |
| Reserved capacity | [If applicable] |

### 4.4 Operational Excellence

| Practice | Implementation |
|----------|----------------|
| IaC | Bicep |
| Monitoring | Application Insights |
| Alerting | [Configuration] |

### 4.5 Performance Efficiency

| Optimization | Details |
|--------------|---------|
| Caching | [Strategy] |
| Scaling | [Auto-scale rules] |

## 5. Cost Estimate

### Monthly Breakdown

| Resource | Cost |
|----------|------|
| Compute | €X |
| Database | €X |
| Storage | €X |
| Networking | €X |
| Monitoring | €X |
| **Total** | **€X** |

### Budget Compliance

- Target: €X/month
- Estimated: €X/month
- Status: ✅ Within budget / ⚠️ Over budget

## 6. Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk 1] | High/Med/Low | [Mitigation] |
| [Risk 2] | High/Med/Low | [Mitigation] |

## 7. Recommendations

1. [Recommendation 1]
2. [Recommendation 2]
3. [Recommendation 3]

---

*Generated using @architect agent*
