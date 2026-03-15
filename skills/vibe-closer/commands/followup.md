---
description: "Process due leads and generate follow-up activities"
argument-hint: "[optional: specific lead name or 'all']"
---

# Follow Up on Pipeline

This command is triggered in two ways:
- **Daily:** Scheduled run to process all leads with due follow-up dates
- **On new activity:** Triggered by `actions/poll-new-activity.md` when a new email reply is detected

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

## Phase 1: Check Regeneration Requests
Query `{{ACTIONS_DB}}` for activities where `needs_regeneration = true`. For each, run `actions/generate-lead-activity.md` for that lead (which will pick up the notes and regenerate).

## Phase 2: Fetch Due Leads
Read `actions/get-leads.md` → fetch due leads (follow-up date <= today). If `$ARGUMENTS` specifies a lead name, filter to that lead only.

**If no leads are due AND no regeneration requests were found in Phase 1:**
Tell the user: "No leads are due for follow-up today." Query `{{CRM_TRACKER}}` for the next earliest follow-up date and show it: "Next due: [date]." Stop here.

## Phase 3: Gather Context & Draft Activities
For each lead:
1. Read `actions/gather-lead-context.md` → fetch full context
2. Read `actions/generate-lead-activity.md` → determine next step and draft activity

## Phase 4: Present for Approval
If any activities were auto-approved during Phase 3 (confidence score >= `{{AUTO_APPROVE_THRESHOLD}}`):
- Summarize them first: "Auto-approved [N] activities with confidence >= [threshold]: [brief list of contact names and summaries]"
- These will execute in Phase 5 alongside manually approved ones

Read `actions/view-pending-activity.md` → present activities with `approval_status = 'pending'` for manual review. Wait for user to approve/edit/reject each activity.

## Phase 5: Execute Approved Activities
For approved activities: read `actions/execute-activity.md` → execute.
