# Approve Activity

Human-in-the-loop approval gate.

## Steps

1. Fetch the activity from `{{ACTIONS_DB}}` by ID
2. Show full details to user:
   - Activity type
   - Recipients
   - Scheduled date
   - Full body content
   - Confidence score and brief reasoning (from `scoring_breakdown`)
   - If score is below 50, flag: "Low confidence — review carefully"
3. Ask for explicit confirmation: "Approve this activity? (yes/no/edit)"
4. If approved:
   - Update `approval_status` to `approved`
   - Update `updated_at`
5. If edit requested: redirect to `update-activity.md`
6. If rejected:
   - Confirm with user: "Are you sure you want to reject this activity?"
   - On confirmation: update `approval_status` to `rejected` and `updated_at`

## Bulk Approval

If user says "approve all" or "LGTM":
1. List all pending activities with summaries
2. Ask: "Approve all [N] activities?"
3. On confirmation, update all to `approved`

## Auto-Approved Activities

Activities scoring >= `{{AUTO_APPROVE_THRESHOLD}}` are auto-approved during generation. To review auto-approved activities:
1. Query `{{ACTIONS_DB}}` for activities where `approval_status = 'approved' AND execution_status = 'pending'`
2. Present them with the same detail view (including confidence score)
3. User can revoke approval (set back to `'pending'`) or confirm
