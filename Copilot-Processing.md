# Copilot Processing Log

## User Request

Create a 5-hour hands-on hackathon package for IT Pros, aligned with the Agentic InfraOps project.
**Update**: Reorganize into separate files per challenge with subfolders.

## Action Plan

| # | Phase | Task | Status |
|---|-------|------|--------|
| 1 | Clear Old Structure | Remove old flat hackathon files | ✅ Complete |
| 2 | Main README | Create `hackathon/README.md` with overview | ✅ Complete |
| 3 | Challenge 1 | Create `hackathon/challenges/challenge-1-requirements.md` | ✅ Complete |
| 4 | Challenge 2 | Create `hackathon/challenges/challenge-2-architecture.md` | ✅ Complete |
| 5 | Challenge 3 | Create `hackathon/challenges/challenge-3-implementation.md` | ✅ Complete |
| 6 | Challenge 4 | Create `hackathon/challenges/challenge-4-dr-curveball.md` | ✅ Complete |
| 7 | Challenge 5 | Create `hackathon/challenges/challenge-5-load-testing.md` | ✅ Complete |
| 8 | Scenario Brief | Create `hackathon/participant/scenario-brief.md` | ✅ Complete |
| 9 | Pre-Work | Create `hackathon/participant/pre-work-checklist.md` | ✅ Complete |
| 10 | Hints | Create `hackathon/participant/hints-and-tips.md` | ✅ Complete |
| 11 | Facilitator Guide | Create `hackathon/facilitator/facilitator-guide.md` | ✅ Complete |
| 12 | Scoring Rubric | Create `hackathon/facilitator/scoring-rubric.md` | ✅ Complete |
| 13 | Solution Reference | Create `hackathon/facilitator/solution-reference.md` | ✅ Complete |
| 14 | Scoring Script | Create `scripts/hackathon/Score-Team.ps1` | ✅ Complete |
| 15 | Leaderboard Script | Create `scripts/hackathon/Get-Leaderboard.ps1` | ✅ Complete |

## Summary

### Final Structure

```
hackathon/
├── README.md                        # Main overview and navigation
├── challenges/
│   ├── challenge-1-requirements.md  # @plan agent (60 min, 20 pts)
│   ├── challenge-2-architecture.md  # @architect agent (60 min, 25 pts)
│   ├── challenge-3-implementation.md # @bicep-plan + @bicep-code (60 min, 25 pts)
│   ├── challenge-4-dr-curveball.md  # Multi-region DR (20 min, 10 pts)
│   └── challenge-5-load-testing.md  # k6/Azure Load Testing (15 min, 5 pts)
├── participant/
│   ├── scenario-brief.md            # Nordic Fresh Foods business case
│   ├── pre-work-checklist.md        # Setup requirements
│   └── hints-and-tips.md            # Collapsible hints per challenge
└── facilitator/
    ├── facilitator-guide.md         # Detailed schedule, curveball script
    ├── scoring-rubric.md            # WAF-aligned criteria (100+25 pts)
    └── solution-reference.md        # Expected outputs, Bicep patterns

scripts/hackathon/
├── Score-Team.ps1                   # Automated scoring script
└── Get-Leaderboard.ps1              # Leaderboard display
```

### Key Features
- **Modular structure**: Each challenge in separate file
- **Clear navigation**: Subfolders with relevant names
- **Staggered challenges**: Multi-region DR introduced as "curveball" at 4:15
- **Load testing**: Challenge 5 validates 500 users, ≤2s P95, ≤1% errors
- **Automated scoring**: PowerShell scripts in root scripts folder
- **Collapsible hints**: Spoiler-style hints for participants

### Challenge Flow
1. Challenges 1-3 (3 hrs): MVP single-region (€500/month)
2. Challenge 4 (curveball): Multi-region DR added (€700/month)
3. Challenge 5: Load testing validation

## Status: ✅ COMPLETE

All 15 tasks completed. Review the final structure and delete this file when done.
