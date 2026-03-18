---
description: "Open the pipeline viewer — browse leads, review activities, approve outreach"
---

# View Pending Activity

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

## Phase 1: Open Activity Viewer
Read `actions/view-pending-activity.md`. The default behavior is to open a browser-based activity viewer. Falls back to chat-based display if the browser cannot be opened.

## Phase 2: Display Activities
Query `{{ACTIONS_DB}}` for activities where `approval_status = 'pending'` and present as a filterable table.

## Phase 3: Offer Actions
For each activity, offer: view details, view context, view scoring breakdown, approve, edit, add note & regenerate, reject.

## Final: Log

Log a summary of this entire execution using `actions/add-log.md`.
