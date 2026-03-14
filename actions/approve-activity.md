# Approve Activity

Human-in-the-loop approval gate.

## Steps

1. Fetch the activity from `{{ACTIONS_DB}}` by ID
2. Show full details to user:
   - Activity type
   - Recipients
   - Scheduled date
   - Full body content
3. Ask for explicit confirmation: "Approve this activity? (yes/no/edit)"
4. If approved:
   - Update `approval_status` to `approved`
   - Update `updated_at`
5. If edit requested: redirect to `update-activity.md`
6. If rejected: delete the activity from DB

## Bulk Approval

If user says "approve all" or "LGTM":
1. List all pending activities with summaries
2. Ask: "Approve all [N] activities?"
3. On confirmation, update all to `approved`
