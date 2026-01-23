---
description: "Proofreading and editorial standards for hackathon documentation"
applyTo: "**/hackathon/**/*.md"
---

# Hackathon Proofreading Standards

Comprehensive editorial standards for maintaining consistency, clarity, and professional quality
across all hackathon documentation.

## Voice and Tone

- **Clear, warm, professional, and action-oriented**
- Catch inconsistencies others miss
- Every word must earn its place
- Make complex content accessible without oversimplifying
- Professional but approachable
- Active voice preferred
- Encouraging without being patronizing

## Terminology Standards

Use these terms consistently across ALL hackathon files:

| Correct Term                     | Avoid                             |
| -------------------------------- | --------------------------------- |
| GitHub Copilot                   | Copilot, copilot, GH Copilot      |
| Azure Well-Architected Framework | WAF (first use), Well Architected |
| Bicep                            | BICEP, bicep (except in code)     |
| Dev Container                    | devcontainer, dev-container       |
| Nordic Fresh Foods               | Nordic Foods, the company         |
| FreshConnect                     | Fresh Connect, freshconnect       |
| Partner Showcase                 | partner showcase, Presentation    |
| `plan` agent                     | Plan agent, plan Agent            |
| hackathon                        | workshop (for this event)         |
| challenge-based                  | workshop-style, training          |
| coach / coaching                 | trainer / instructor              |
| attendee / participant           | student, learner                  |

## Timing Reference (6-Hour Schedule)

All timing references must match this schedule:

| Block | Time        | Duration |
| ----- | ----------- | -------- |
| Intro | 10:00-10:30 | 30 min   |
| C1    | 10:30-11:20 | 50 min   |
| C2    | 11:20-12:10 | 50 min   |
| Lunch | 12:10-12:40 | 30 min   |
| C3    | 12:40-13:50 | 70 min   |
| C4    | 13:50-14:30 | 40 min   |
| C5    | 14:30-14:50 | 20 min   |
| C6    | 14:50-15:10 | 20 min   |
| C7    | 15:10-15:15 | 5 min    |
| Prep  | 15:15-15:25 | 10 min   |
| C8    | 15:25-15:55 | 30 min   |
| Wrap  | 15:55-16:00 | 5 min    |

## Team Structure Reference

| Aspect          | Value                    |
| --------------- | ------------------------ |
| Team Size       | Up to 5 members per team |
| Number of Teams | Maximum 4 teams          |

## Spelling and Grammar

- No typos or spelling errors
- Correct grammar and punctuation
- Consistent use of Oxford comma (always use it)
- Proper capitalization for Azure services and product names

## Formatting Standards

- Tables are aligned and render correctly
- Code blocks use correct language identifiers
- Links are valid (relative paths preferred)
- Emoji usage is consistent and purposeful
- Headers follow hierarchy (no skipped levels)
- Blockquotes used appropriately for callouts

## Instructional Clarity

- Steps are numbered and actionable
- Commands are copy-pasteable
- Prerequisites are clearly stated
- Success criteria are defined
- Common issues have solutions documented

## Review Checklist

### Spelling and Grammar

- [ ] No typos or spelling errors
- [ ] Correct grammar and punctuation
- [ ] Consistent Oxford comma usage
- [ ] Proper capitalization

### Terminology Consistency

- [ ] All terms match the terminology table
- [ ] Agent names formatted correctly (backticks for inline)
- [ ] Product names properly capitalized

### Timing Consistency

- [ ] All timing matches the 6-hour schedule
- [ ] Duration values are accurate
- [ ] No references to old 5-hour format

### Formatting

- [ ] Tables render correctly
- [ ] Code blocks have language identifiers
- [ ] Links are valid
- [ ] Emoji usage is purposeful
- [ ] Header hierarchy is correct

### Instructional Quality

- [ ] Steps are numbered
- [ ] Commands are copy-pasteable
- [ ] Prerequisites stated
- [ ] Success criteria defined

## Proofreading Workflow

### Phase 1: Inventory

1. List all `.md` files in `hackathon/` folder
2. Read `AGENDA.md` first as source of truth for timing
3. Note key terminology and timing from agenda

### Phase 2: Individual File Review

For each file:

1. Read the full content
2. Check against the review checklist
3. Note issues with file path and line numbers
4. Categorize as: Critical / Important / Minor

### Phase 3: Cross-File Consistency

1. Verify timing matches across all files
2. Check terminology consistency
3. Ensure challenge numbering is consistent
4. Verify all cross-references and links work

### Phase 4: Fixes

1. Fix Critical issues first
2. Fix Important issues
3. Fix Minor issues
4. Group related fixes into logical commits

### Phase 5: Report

Document changes made:

```markdown
## Proofreading Summary

### Files Reviewed

- [x] file1.md - X issues found, X fixed
- [x] file2.md - Clean

### Issues Fixed

| File | Issue | Fix |
| ---- | ----- | --- |
| ...  | ...   | ... |

### Remaining Items

- Items requiring human decision
```

## Quality Gates

Before completing any hackathon documentation:

- [ ] Run markdown linter: `npm run lint:md`
- [ ] All links validated
- [ ] No broken cross-references
- [ ] Timing cross-checked with AGENDA.md
- [ ] Terminology verified against standards table
