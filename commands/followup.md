---
description: "Process due leads and generate follow-up activities"
argument-hint: "[optional: specific lead name or 'all']"
---

# Follow Up on Pipeline

This command is triggered in two ways:
- **Daily:** Scheduled run to process all leads with due follow-up dates
- **On new activity:** Triggered by `actions/poll-new-activity.md` when a new email reply is detected

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

1. Read `actions/get-leads.md` → fetch due leads (follow-up date <= today)
2. For each lead:
   a. Read `actions/gather-lead-context.md` → fetch full context
   b. Read `actions/generate-lead-activity.md` → determine next step and draft activity
3. Read `actions/view-pending-activity.md` → present all drafted activities for approval
4. Wait for user to approve/edit/reject each activity
5. For approved activities: read `actions/execute-activity.md` → execute

If `$ARGUMENTS` specifies a lead name, filter to that lead only.
