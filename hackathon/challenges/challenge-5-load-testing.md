# Challenge 5: Load Testing

> **Duration**: 15 minutes | **Output**: `05-load-test-results.md`

## Objective

Validate that your deployed infrastructure can handle the expected load of 500 concurrent users.

## Requirements

| Metric | Target | Pass/Fail |
|--------|--------|-----------|
| **Concurrent Users** | 500 | Must sustain |
| **Response Time (P95)** | ≤2 seconds | P95 under 2s |
| **Error Rate** | ≤1% | Less than 1% errors |
| **Ramp-up** | 0→500 over 5 min | Gradual increase |

## Quick Start Options

### Option 1: k6 (Recommended — Fast Setup)

k6 is pre-installed in the Dev Container.

```bash
# Create test file
cat > load-test.js << 'EOF'
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 100 },   // Ramp up
    { duration: '2m', target: 500 },   // Sustain peak
    { duration: '1m', target: 0 },     // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<2000'],  // P95 < 2s
    http_req_failed: ['rate<0.01'],     // Error rate < 1%
  },
};

export default function () {
  // Replace with your App Service URL
  const res = http.get('https://app-freshconnect-dev-swc.azurewebsites.net/');
  check(res, { 
    'status is 200': (r) => r.status === 200,
    'response time < 2s': (r) => r.timings.duration < 2000,
  });
  sleep(1);
}
EOF

# Run the test
k6 run load-test.js
```

### Option 2: Azure Load Testing

```bash
# Create Azure Load Testing resource
az load create \
  --name lt-freshconnect \
  --resource-group rg-freshconnect-dev-swc \
  --location swedencentral

# Then use Azure Portal to upload and run test
```

### Option 3: Simple curl loop (Fallback)

```bash
# Quick smoke test (not a real load test)
for i in {1..100}; do
  curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" \
    https://app-freshconnect-dev-swc.azurewebsites.net/ &
done
wait
```

## Document Your Results

Create `agent-output/freshconnect/05-load-test-results.md`:

```markdown
# Load Test Results

## Test Configuration

| Setting | Value |
|---------|-------|
| Tool | k6 |
| Target URL | https://app-freshconnect-dev-swc.azurewebsites.net/ |
| Duration | 4 minutes |
| Peak Users | 500 |

## Results Summary

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Concurrent Users | 500 | 500 | ✅ PASS |
| P95 Response Time | ≤2000ms | 1234ms | ✅ PASS |
| Error Rate | ≤1% | 0.2% | ✅ PASS |
| Total Requests | - | 45,231 | - |

## Key Observations

1. Response times remained stable under load
2. No errors observed during ramp-up
3. P95 stayed well under 2s threshold

## Recommendations

1. Consider auto-scaling rules for sustained peak traffic
2. Monitor during actual peak season (summer/December)
3. Add caching layer if response times increase
```

## Success Criteria

| Criterion | Points |
|-----------|--------|
| Load test executed | 2 |
| Targets documented | 1 |
| Results analyzed | 2 |
| **Total** | **5** |

## Interpreting Results

### ✅ If Tests Pass

- Document the results
- Note any observations about performance
- Proceed to final deployment

### ❌ If Tests Fail

| Issue | Possible Cause | Solution |
|-------|----------------|----------|
| High P95 latency | Under-provisioned | Scale up App Service SKU |
| Error rate > 1% | Connection limits | Check SQL DTU limits |
| Timeouts | Cold start | Enable Always On |

## Tips

- 💡 Run against your actual deployed App Service URL
- 💡 If you haven't deployed yet, use a health endpoint
- 💡 k6 output is self-explanatory — just copy the summary
- 💡 Don't spend too long on this — 5-10 minutes is enough

## Final Step

After load testing, ensure all your artifacts are in place:

```
agent-output/freshconnect/
├── 01-requirements.md           ✅
├── 02-architecture-assessment.md ✅
├── 04-implementation-plan.md    ✅
├── 05-load-test-results.md      ✅ (this challenge)
└── 06-deployment-summary.md     ✅ (create after deploy)
```

Create a deployment summary and prepare for team showcase!
