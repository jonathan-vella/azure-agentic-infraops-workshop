# Copilot Processing Log

## User Request

Create a new **Challenge 6: Partner Showcase** where teams present their work (5-10 mins max) in a role-play format:

- One team plays the **Partner** (presenting)
- Another team plays the **Customer** (challenging)
- Microsoft facilitators observe and provide feedback

## Key Decisions

| Aspect         | Decision                                                                                   |
| -------------- | ------------------------------------------------------------------------------------------ |
| Timing         | Shorten existing challenges by 10 min each; reduce intro to 30 min; replace 15-min wrap-up |
| Format         | One team at a time, all watch                                                              |
| Scoring        | No points - learning/soft skills focused                                                   |
| Content        | Full partner presentation (architecture + demo + business case) with markdown template     |
| Customer Role  | Scripted objections/questions provided                                                     |
| Microsoft Role | Observe all, provide feedback after each presentation                                      |

## Action Plan

| #   | Phase                        | Task                                                      | Status      |
| --- | ---------------------------- | --------------------------------------------------------- | ----------- |
| 1   | Create Challenge 6           | Create `challenge-6-partner-showcase.md`                  | ✅ Complete |
| 2   | Presentation Template        | Markdown template embedded in Challenge 6                 | ✅ Complete |
| 3   | Customer Questions           | Scripted objections/question bank embedded in Challenge 6 | ✅ Complete |
| 4   | Update Challenges README     | Add Challenge 6 to table with new durations               | ✅ Complete |
| 5   | Update Facilitator Guide     | New timing schedule with Block 6                          | ✅ Complete |
| 6   | Update Scoring Rubric        | Note Challenge 6 is unscored                              | ✅ Complete |
| 7   | Update Participant Materials | Quick reference card updated                              | ✅ Complete |

## Summary

All tasks completed. Challenge 6: Partner Showcase has been created with:

- Full presentation template (markdown guidance for PPT)
- Customer question bank with 20+ scripted objections
- Role-play pairing system
- Facilitator feedback focus areas
- Updated timing across all facilitator materials

### New Schedule

| Block | Time        | Duration | Content                       |
| ----- | ----------- | -------- | ----------------------------- |
| 1     | 0:00 - 0:30 | 30 min   | Intro                         |
| 2     | 0:30 - 1:20 | 50 min   | Challenge 1: Requirements     |
| Break | 1:20 - 1:30 | 10 min   |                               |
| 3     | 1:40 - 2:30 | 50 min   | Challenge 2: Architecture     |
| Break | 2:30 - 2:40 | 10 min   |                               |
| 4     | 2:40 - 3:30 | 50 min   | Challenge 3: Bicep            |
| Break | 3:30 - 3:40 | 10 min   |                               |
| 5     | 3:40 - 4:15 | 35 min   | Curveball + C4-5              |
| Break | 4:15 - 4:25 | 10 min   | Teams prepare presentations   |
| 6     | 4:25 - 5:15 | 50 min   | Challenge 6: Partner Showcase |
| Wrap  | 5:15 - 5:20 | 5 min    | Leaderboard & close           |

**Total: ~5 hours 20 min**

### Files Changed

- `hackathon/challenges/challenge-6-partner-showcase.md` (new)
- `hackathon/challenges/README.md` (updated)
- `hackathon/facilitator/facilitator-guide.md` (updated)
- `hackathon/facilitator/scoring-rubric.md` (updated)
- `hackathon/participant/quick-reference-card.md` (updated)
  ├── facilitator-guide.md # Detailed schedule, curveball script
  ├── scoring-rubric.md # WAF-aligned criteria (100+25 pts)
  └── solution-reference.md # Expected outputs, Bicep patterns

scripts/hackathon/
├── Score-Team.ps1 # Automated scoring script
└── Get-Leaderboard.ps1 # Leaderboard display

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
```
