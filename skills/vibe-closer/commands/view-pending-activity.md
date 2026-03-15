---
description: "View all pending activities awaiting approval"
---

# View Pending Activity

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

## Phase 1: Fetch Pending Activities
Read `actions/view-pending-activity.md` for the full display and interaction process.

## Phase 2: Display Activities
Query `{{ACTIONS_DB}}` for activities where `approval_status = 'pending'` and present as a filterable table.

## Phase 3: Offer Actions
For each activity, offer: view details, view context, view scoring breakdown, approve, edit, add note & regenerate, reject.
