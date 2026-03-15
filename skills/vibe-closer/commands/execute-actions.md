---
description: "Execute all approved activities (send emails, update CRM, etc.)"
---

# Execute Actions

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

## Phase 1: Fetch Approved Activities
Read `actions/execute-activity.md` for the full execution process.

Query `{{ACTIONS_DB}}` for all activities where `approval_status = 'approved'` and `execution_status = 'pending'`.

## Phase 2: Execute Each Activity
For each activity, follow the execution instructions by type (send_email, send_linkedin, update_followup_date, change_pipeline_stage, add_lead).

## Phase 3: Report Results
Summarize what was executed: how many activities by type, any failures.
