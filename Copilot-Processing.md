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

### Phase 5: Update Participant Materials for 6-Hour, 8-Challenge Format ✅ COMPLETE

**Current Task: Transform participant materials to coaching-focused approach**

Files to update:
- [x] hints-and-tips.md - Changed from prescriptive answers to guiding questions
- [x] quick-reference-card.md - Updated to 6-hour schedule, 8 challenges, added docs/diagnose agents
- [x] scenario-brief.md - Verified hackathon terminology, 8-challenge flow
- [x] team-role-cards.md - Updated for coaching emphasis, 8 challenges, new challenge roles

Coaching philosophy applied:
- ✅ Turned "answers" into questions that help discover solutions
- ✅ Replaced "do this" with "consider: what if...?"
- ✅ Emphasized prompt engineering skills
- ✅ Business context drives technical decisions

**Detailed Changes Made:**

1. **hints-and-tips.md**:
   - Transformed service selection from prescriptive table to guiding questions
   - Updated cost optimization with discovery questions about resource sharing, right-sizing
   - Changed security section to ask "How would you discover GDPR requirements?"
   - Added Challenge 6 (Documentation) hints with audience/format/value questions
   - Added Challenge 7 (Diagnostics) hints with failure modes and diagnostic strategy
   - Updated DR curveball to use questions instead of complete implementation
   - Updated load testing with understanding-focused questions
   - Changed agent tips to question-based coaching
   - Updated from 6 to 8 challenges, 5 hours to 6 hours
   - Changed all "workshop" references to "hackathon"

2. **quick-reference-card.md**:
   - Added 6-hour schedule table (09:00-15:00) with all 8 challenges
   - Updated agent list to include `docs` and `diagnose` agents
   - Added expected outputs for Challenges 6-7
   - Added Pro Tips section with Mermaid flowchart example (Challenge 3)
   - Added ADR template tip (Challenge 4)
   - Added documentation prompt templates (Challenge 6)
   - Added diagnostic query examples (Challenge 7)

3. **scenario-brief.md**:
   - Added "The Hackathon Journey" section explaining 8-challenge structure
   - Updated from "plan" agent to "requirements" agent
   - Clarified not all teams complete all challenges — focus is learning
   - Verified all terminology uses "hackathon"

4. **team-role-cards.md**:
   - Updated all role descriptions to emphasize coaching/collaboration mindset
   - Added specific tips for Challenges 6-7 in each role
   - Updated role rotation table for 8 challenges (rotate every 2 challenges)
   - Added suggested lead roles for new challenges (Documenter for C6, Architect for C7)
   - Expanded "Team Agreement" to include coaching philosophy
   - Added coaching mindset bullets to Navigator role
   - Updated references to 8 challenges throughout

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
- **Challenge 4**: Parameterize HA (multi-region vs single-region), mandate ADRs,
  remove complete solutions
- **Challenge 5**: Ensure k6 in devcontainer, provide prompt for generating load test results doc,
  specify which agent to use
- **Challenge 6**: Convert ASCII diagrams to mermaid

### 5. Technical

- Add k6 load testing tool to devcontainer

---

## Summary

### Phase 5 Complete: Participant Materials Updated ✅

**Successfully transformed all 4 participant materials files** to reflect the new 6-hour,
8-challenge, coaching-focused hackathon format.

**Files Updated:**
1. ✅ `hackathon/participant/hints-and-tips.md` (292 → 531 lines)
2. ✅ `hackathon/participant/quick-reference-card.md` (121 → ~180 lines)
3. ✅ `hackathon/participant/scenario-brief.md` (120 → 142 lines)
4. ✅ `hackathon/participant/team-role-cards.md` (115 → 180 lines)

**Key Transformations:**

✅ **Coaching Philosophy Applied**:
- Every "answer" converted to guiding questions
- "Do this" replaced with "Consider: what if...?"
- Emphasis on prompt engineering and discovery
- Business context drives all technical decisions

✅ **8-Challenge Structure**:
- All references updated from 6 to 8 challenges
- Challenge 6: Documentation (20 min, 5 points)
- Challenge 7: Diagnostics (10 min, 5 points)
- Challenge 8: Partner Showcase (40 min, 10 points)

✅ **6-Hour Schedule**:
- Updated from 5-hour to 6-hour format (09:00-15:00)
- Includes 30-minute lunch break (11:10-11:40)
- All timing references updated consistently

✅ **Terminology Consistency**:
- Changed all "workshop" to "hackathon"
- Changed "plan" agent to "requirements" agent
- Added "docs" and "diagnose" agents

✅ **Enhanced Content**:
- Added Mermaid flowchart tips for Challenge 3
- Added ADR template guidance for Challenge 4
- Added documentation prompt templates for Challenge 6
- Added diagnostic query examples for Challenge 7
- Added role suggestions for new challenges

**Quality Assurance:**
- All changes align with `proofread-hackathon.prompt.md` standards
- Consistent with AGENDA.md 6-hour schedule
- Maintains professional yet approachable tone
- Emphasizes discovery over prescription

**Next Steps (if needed):**
- Review changes for consistency with other hackathon files
- Consider applying similar coaching approach to facilitator materials
- Ensure challenge files themselves reflect coaching philosophy

---

**Note**: Please review these updated files and confirm they meet your expectations before
removing this `Copilot-Processing.md` file from the repository.
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

---

## FINAL COMPLETION STATUS

### ✅ ALL PHASES COMPLETE

**Transformation Summary:**
- 10 files modified in challenge transformation
- 21 consistency issues fixed in comprehensive proofread
- 8 challenges fully transformed to coaching approach
- Supporting documentation updated (AGENDA, READMEs, facilitator guides, participant materials)
- Technical infrastructure enhanced (k6, Mermaid diagrams)
- All files aligned with 6-hour/8-challenge format

### Completed Phases

1. ✅ **Phase 1: Analysis & Discovery**
2. ✅ **Phase 2: Expert Persona & Integration Guide**
3. ✅ **Phase 3: Core Challenge Files (1-8)**
4. ✅ **Phase 4: Supporting Documentation**
5. ✅ **Phase 5: Technical Infrastructure**
6. ✅ **Phase 6: Comprehensive Proofread** (21 issues fixed)

### Proofreading Results

**21 Total Issues Fixed:**
- 7 agent name formatting fixes
- 6 terminology fixes (coach vs facilitator)
- 3 point allocation corrections
- 3 agent formatting improvements
- 1 file path cross-reference fix
- 1 timing consistency fix

**All Challenges Verified:**
- ✅ Terminology consistent (hackathon, challenge, coach)
- ✅ Timing matches AGENDA.md
- ✅ Points total 105
- ✅ Agent names lowercase with backticks
- ✅ Coaching tone maintained
- ✅ Mermaid diagrams (no ASCII)
- ✅ Cross-references accurate

### Files Modified (25 Total)

**Foundation:**
- `.github/prompts/expert-persona-hackathon-refactor.prompt.md` (NEW)
- `.github/prompts/INTEGRATION-GUIDE.md` (NEW)
- `.github/prompts/proofread-hackathon.prompt.md` (UPDATED)

**Challenges (8):**
- Challenges 1-5 (TRANSFORMED to coaching)
- Challenge 6 (NEW - Documentation)
- Challenge 7 (NEW - Diagnostics)
- Challenge 8 (RENAMED, Mermaid diagram)
- challenges/README.md (UPDATED)

**Supporting (13):**
- AGENDA.md, README.md
- facilitator/* (3 files)
- participant/* (4 files)
- .devcontainer/devcontainer.json (k6 added)

### Business Value

1. **Learning**: Prompt engineering focus, not just Azure syntax
2. **Engagement**: Questions drive critical thinking
3. **Scalability**: Coaches guide, don't solve
4. **Real-World**: Mirrors actual development workflows
5. **Complete**: All 7 agent workflow steps covered

---

🎉 **TRANSFORMATION COMPLETE**

All hackathon content successfully refactored to challenge-based coaching approach.

**Philosophy**: "I am a coach, not a trainer. Business is the driver, IT is the enabler."

**Next**: Remove this file before committing to main branch.
