# Update Activity

Human-in-the-loop editing of a pending activity.

## Steps

1. Fetch the activity from `{{ACTIONS_DB}}` by ID
2. Present current body to user
3. Accept edits (subject, message, scheduled date, recipients, etc.)
4. Before saving:
   - Push current `body` with timestamp to `body_history` array: `body_history = body_history || jsonb_build_object('body', body, 'edited_at', now())`
   - Update `body` with new version
   - Update `updated_at`
5. Save to `{{ACTIONS_DB}}`
6. Present updated activity for confirmation
