# Copilot Processing Log: Hackathon Content Refactoring

## User Request

Transform the hackathon from a workshop-style format to a challenge-based, coaching-oriented experience where:

- Business challenges drive IT solutions (not prescriptive steps)
- Minimal solutions provided - guidelines and snippets only
- Coaching approach: answer questions with questions to build prompt engineering skills
- Extended to 6 hours (including 30min lunch) to cover full 7-step workflow including docs and diagnose phases
- Specific improvements to challenges 3-6
- Add k6 to devcontainer
- Use mermaid diagrams instead of ASCII
- Work on feature branch (not master)

## Status: Phase 1 - Initialization ✅

Created processing log to track all changes.

## Action Plan

### Phase 1: Analysis & Discovery ✅

**Tasks:**

- [x] Review all hackathon-related files to understand current structure
- [x] Identify all files in scope for updates
- [x] Document current state and required changes
- [x] Check if k6 is in devcontainer - **NOT FOUND, needs to be added**

**Key Findings:**

- Current format: 5-hour workshop with 6 challenges
- Stops at deployment (Challenge 3), no docs/diagnose phases
- Challenge 4 is a "curveball" DR scenario
- Contains many complete code solutions
- Uses prescriptive "step-by-step" instructions
- ASCII diagrams in Challenge 6
- k6 is NOT in devcontainer - needs to be added

### Phase 2: Create Expert Persona Prompt ✅

**Tasks:**

- [x] Create comprehensive prompt with expert persona definition
- [x] Include all specific requirements from user
- [x] Define scope of all files to be updated
- [x] Include examples of coaching vs training approach

**Output:**

- Created: `.github/prompts/expert-persona-hackathon-refactor.prompt.md`
- Persona: Dr. Elena Björkström, Principal Learning Experience Designer
- Philosophy: "The best teachers don't give answers—they teach people how to ask better questions."
- Comprehensive transformation guidelines with before/after examples
- Detailed requirements for each challenge
- New 6-hour timing breakdown
- Success criteria and implementation approach
- **Integrated with**: `.github/prompts/proofread-hackathon.prompt.md` for quality assurance
- Created: `.github/prompts/INTEGRATION-GUIDE.md` - Workflow showing how both prompts work together

### Phase 3: Update Core Challenge Files

**Tasks:**

- [ ] Challenge 3: Remove agent validation details, add requirement for mermaid flowchart explaining process
  - [ ] Apply proofread checklist after changes
- [ ] Challenge 4: Make HA parameterized, require ADRs, remove complete answers
  - [ ] Apply proofread checklist after changes
- [ ] Challenge 5: Add k6 to devcontainer, create prompt for load test results with agent specification
  - [ ] Apply proofread checklist after changes
- [ ] Challenge 6: Replace ASCII with mermaid diagrams
  - [ ] Apply proofread checklist after changes
- [ ] Create Challenge 7: Documentation phase
  - [ ] Apply proofread checklist after creation
- [ ] Create Challenge 8: Diagnose phase (or combine with 7)
  - [ ] Apply proofread checklist after creation
- [ ] Update challenges/README.md to reflect new challenges
  - [ ] Apply proofread checklist after changes

**Note**: Each change must be followed by proofreading using `.github/prompts/proofread-hackathon.prompt.md`

### Phase 4: Update Supporting Documentation

**Tasks:**

- [ ] Update AGENDA.md for 6-hour format with lunch break
  - [ ] Apply proofread checklist
- [ ] Update facilitator-guide.md with coaching approach
  - [ ] Apply proofread checklist
- [ ] Update hints-and-tips.md to be more question-oriented
  - [ ] Apply proofread checklist
- [ ] Update scoring-rubric.md for new challenges
  - [ ] Apply proofread checklist
- [ ] Update README.md overview
  - [ ] Apply proofread checklist
- [ ] Update workshop-invitation.md (if exists)
  - [ ] Apply proofread checklist
- [ ] Update any other participant materials
  - [ ] Apply proofread checklist

**Note**: Each file update must include immediate proofreading for consistency
un comprehensive proofread pass across all changed files using proofread-hackathon.prompt.md

- [ ] Review all changes for consistency with expert persona guidelines
- [ ] Ensure coaching tone throughout (not training tone)
- [ ] Verify 6-hour timing works and is consistent across all files
- [ ] Check all mermaid diagrams render correctly
- [ ] Validate no complete solutions are provided (only snippets/concepts)
- [ ] Run `npm run lint:md` on all changed files
- [ ] Verify all cross-references and links work
- [ ] Test k6 is properly installed in devcontainer
- [ ] Create final summary report of all changes
- [ ] Create load test prompt template

### Phase 6: Review & Validation

**Tasks:**

- [ ] Review all changes for consistency
- [ ] Ensure coaching tone throughout
- [ ] Verify 6-hour timing works
- [ ] Check all mermaid diagrams render correctly
- [ ] Validate no complete solutions are provided

## Files in Scope

### Challenge Files (Primary)

- `/workspaces/infraops-workshop/hackathon/challenges/challenge-1-requirements.md`
- `/workspaces/infraops-workshop/hackathon/challenges/challenge-2-architecture.md`
- `/workspaces/infraops-workshop/hackathon/challenges/challenge-3-implementation.md`
- `/workspaces/infraops-workshop/hackathon/challenges/challenge-4-dr-curveball.md`
- `/workspaces/infraops-workshop/hackathon/challenges/challenge-5-load-testing.md`
- `/workspaces/infraops-workshop/hackathon/challenges/challenge-6-partner-showcase.md`
- `/workspaces/infraops-workshop/hackathon/challenges/README.md`
- NEW: challenge-7-documentation.md (to be created)
- NEW: challenge-8-diagnose.md (to be created or combined with 7)

### Facilitator Materials

- `/workspaces/infraops-workshop/hackathon/facilitator/facilitator-guide.md`
- `/workspaces/infraops-workshop/hackathon/facilitator/scoring-rubric.md`
- `/workspaces/infraops-workshop/hackathon/facilitator/solution-reference.md`

### Participant Materials

- `/workspaces/infraops-workshop/hackathon/participant/hints-and-tips.md`
- `/workspaces/infraops-workshop/hackathon/participant/quick-reference-card.md`
- `/workspaces/infraops-workshop/hackathon/participant/scenario-brief.md`
- `/workspaces/infraops-workshop/hackathon/participant/team-role-cards.md`

### Core Documentation

- `/workspaces/infraops-workshop/hackathon/AGENDA.md`
- `/workspaces/infraops-workshop/hackathon/README.md`
- `/workspaces/infraops-workshop/hackathon/workshop-invitation.md`

### Technical Configuration

- `/workspaces/infraops-workshop/.devcontainer/devcontainer.json`
- NEW: Load test prompt template file

## Key Changes Required

### 1. Terminology

- Replace "workshop" with "hackathon" throughout
- Emphasize "challenge-based" learning
- Use "coach" not "trainer/instructor"

### 2. Tone & Approach

- Remove prescriptive "do this" steps
- Add guiding questions instead of answers
- Focus on prompt engineering skills
- Provide snippets, not complete solutions

### 3. Content Structure

- Extend from 5 to 6 hours
- Add 30min lunch break
- Add docs phase (challenge 7)
- Add diagnose phase (challenge 8)
- Rebalance timing across all challenges

### 4. Specific Challenge Updates

- **Challenge 3**: Attendees explain validation/lint/deploy, create mermaid flowchart
- **Challenge 4**: Parameterize HA (multi-region vs single-region), mandate ADRs, remove complete solutions
- **Challenge 5**: Ensure k6 in devcontainer, provide prompt for generating load test results doc, specify which agent to use
- **Challenge 6**: Convert ASCII diagrams to mermaid

### 5. Technical

- Add k6 load testing tool to devcontainer
- Create template prompts for agent interactions

## Next Steps

Ready to proceed with Phase 1: Analysis & Discovery

### Phase 4: Cleanup

| #   | Task                      | Status      |
| --- | ------------------------- | ----------- |
| 4.1 | Remove test artifacts     | ✅ Complete |
| 4.2 | Document any issues found | ✅ Complete |

## Issues Found & Fixed

| Script                         | Issue                                          | Fix                                                                                                   |
| ------------------------------ | ---------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `Score-Team.ps1`               | Wrong repo root path (1 level up instead of 2) | Changed `Split-Path -Parent $PSScriptRoot` to `Split-Path -Parent (Split-Path -Parent $PSScriptRoot)` |
| `Get-Leaderboard.ps1`          | Same path issue                                | Same fix applied                                                                                      |
| `Setup-GovernancePolicies.ps1` | TLS 1.2 policy definition not found            | Warning logged, non-blocking                                                                          |

## Summary

**All scripts validated successfully!**

- 7 PowerShell scripts: ✅ Syntax OK, Help docs present
- 2 JavaScript validators: ✅ Syntax OK, functioning
- Path bugs fixed in 2 scripts
- All WhatIf/dry-run modes work correctly
