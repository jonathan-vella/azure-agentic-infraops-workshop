# Hackathon Agenda

> **Agentic InfraOps Hackathon** — 6 hours (09:00 - 15:00)

---

## Schedule Overview

| Time        | Block           | Duration | Activity                       |
| ----------- | --------------- | -------- | ------------------------------ |
| 09:00-09:30 | **Intro**       | 30 min   | Welcome, setup, team formation |
| 09:30-10:20 | **Challenge 1** | 50 min   | Requirements Capture           |
| 10:20-11:10 | **Challenge 2** | 50 min   | Architecture Design            |
| 11:10-11:40 | 🍽️ **Lunch**    | 30 min   | Break                          |
| 11:40-12:40 | **Challenge 3** | 60 min   | Bicep Implementation           |
| 12:40-13:10 | **Challenge 4** | 30 min   | DR Curveball                   |
| 13:10-13:30 | **Challenge 5** | 20 min   | Load Testing                   |
| 13:30-13:50 | **Challenge 6** | 20 min   | Documentation                  |
| 13:50-14:00 | **Challenge 7** | 10 min   | Diagnostics                    |
| 14:00-14:15 | 🎯 **Prep**     | 15 min   | Presentation Preparation       |
| 14:15-14:55 | **Challenge 8** | 40 min   | Partner Showcase 🎤            |
| 14:55-15:00 | **Wrap-up**     | 5 min    | Leaderboard, cleanup, close    |

---

## Challenge Summary

| #   | Challenge            | Duration | Points | Agent(s)                   |
| --- | -------------------- | -------- | ------ | -------------------------- |
| 1   | Requirements Capture | 50 min   | 20     | `requirements`             |
| 2   | Architecture Design  | 50 min   | 25     | `architect`                |
| 3   | Bicep Implementation | 60 min   | 25     | `bicep-plan`, `bicep-code` |
| 4   | DR Curveball         | 30 min   | 10     | `bicep-plan`, `bicep-code` |
| 5   | Load Testing         | 20 min   | 5      | (k6 scripts)               |
| 6   | Documentation        | 20 min   | 5      | `docs`                     |
| 7   | Diagnostics          | 10 min   | 5      | `diagnose`                 |
| 8   | Partner Showcase 🎤  | 40 min   | 10     | (presentation)             |

**Total Points**: 105 base + 25 bonus

> 🔒 **Coaches**: See [facilitator-guide.md](facilitator/facilitator-guide.md) for Challenge 4 details.
> Challenge 8 focuses on professional communication and presentation skills.

---

## Detailed Timing

### Block 1: Intro (09:00 - 09:30)

| Time  | Activity             |
| ----- | -------------------- |
| 09:00 | Welcome & logistics  |
| 09:05 | Hackathon overview   |
| 09:12 | 7-step workflow demo |
| 09:18 | Setup verification   |
| 09:24 | Team formation       |
| 09:27 | Scenario briefing    |

### Block 2: Challenge 1 (09:30 - 10:20)

| Time  | Activity                              |
| ----- | ------------------------------------- |
| 09:30 | Start — invoke **requirements** agent |
| 09:45 | Check-in — conversations started?     |
| 10:00 | Progress — draft requirements?        |
| 10:10 | Push — encourage approval             |
| 10:20 | Complete — move to Challenge 2        |

### Block 3: Challenge 2 (10:20 - 11:10)

| Time  | Activity                                    |
| ----- | ------------------------------------------- |
| 10:20 | Start — handoff from **requirements** agent |
| 10:35 | Check-in — WAF recommendations?             |
| 10:50 | Cost — Pricing MCP working?                 |
| 11:00 | Wrap — finalize architecture                |
| 11:10 | Lunch                                       |

### 🍽️ Lunch (11:10 - 11:40)

### Block 4: Challenge 3 (11:40 - 12:40)

| Time  | Activity                          |
| ----- | --------------------------------- |
| 11:40 | Start — **bicep-plan** agent      |
| 11:55 | Plan — implementation plan ready? |
| 12:10 | Code — **bicep-code** agent       |
| 12:30 | Validate — `bicep build`          |
| 12:40 | Complete — move to Challenge 4    |

### Block 5: Challenges 4-7 (12:40 - 14:00)

| Time  | Activity                                   |
| ----- | ------------------------------------------ |
| 12:40 | 📣 **Challenge 4: DR Curveball Announced** |
| 12:45 | Update architecture for multi-region       |
| 13:00 | Generate updated Bicep templates           |
| 13:10 | **Challenge 5: Load Testing**              |
| 13:20 | Run k6 load tests                          |
| 13:30 | **Challenge 6: Documentation**             |
| 13:40 | Generate workload docs with **docs** agent |
| 13:50 | **Challenge 7: Diagnostics**               |
| 13:55 | Run diagnostics with **diagnose** agent    |
| 14:00 | Prep begins                                |

### 🎯 Presentation Prep (14:00 - 14:15)

Teams prepare their Partner Showcase presentations (4-min pitch + 2-min Q&A format).

### Block 6: Challenge 8 (14:15 - 14:55)

| Time  | Team             |
| ----- | ---------------- |
| 14:15 | Intro & pairings |
| 14:17 | Team 1 presents  |
| 14:24 | Team 2 presents  |
| 14:31 | Team 3 presents  |
| 14:38 | Team 4 presents  |
| 14:45 | Team 5 presents  |
| 14:52 | Team 6 presents  |

### Wrap-up (14:55 - 15:00)

- Announce leaderboard
- Key learnings
- Resource cleanup reminder

---

## Quick Reference

- **Repo**: [github.com/jonathan-vella/azure-agentic-infraops-workshop](https://github.com/jonathan-vella/azure-agentic-infraops-workshop)
- **Challenges**: [hackathon/challenges/](challenges/)
- **Facilitator Guide**: [hackathon/facilitator/facilitator-guide.md](facilitator/facilitator-guide.md)
- **Pre-Work**: [hackathon/participant/pre-work-checklist.md](participant/pre-work-checklist.md)
