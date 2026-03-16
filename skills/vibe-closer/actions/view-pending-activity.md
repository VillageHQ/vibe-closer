# View Pending Activity

## Browser Viewer (Default)

Open the rich HTML activity viewer by executing `actions/open-activity-viewer.md`. This provides a full-featured table with inline editing, bulk actions, scoring breakdowns, AI context viewing, filtering, and sorting — all in the browser.

## Chat Fallback

If the browser viewer cannot be opened (e.g., the user explicitly requests chat-based display, or the environment doesn't support `open`), fall back to the table display below.

Query `{{ACTIONS_DB}}` for activities where `approval_status = 'pending'`.

## Display Format

Present as a table:

| # | Type | Contact | Company | Scheduled | Confidence | Summary |
|---|------|---------|---------|-----------|------------|---------|
| 1 | Email | [name] | [company] | [date] | [score]/100 | [summary] |

For each activity, offer:
- **View details** — Show full body (subject, message, etc.)
- **View context** — Show the lead context used to generate it
- **View scoring breakdown** — Show per-dimension scores and reasoning from `scoring_breakdown`
- **Approve** → triggers `approve-activity.md`
- **Edit** → triggers `update-activity.md`
- **Add note & regenerate** → triggers `add-note.md`
- **Reject** → triggers `approve-activity.md` rejection flow (sets `approval_status = 'rejected'`)

## Filtering

Support filters:
- By activity type: any configured channel (`send_{channel}`) or CRM operation (`update_followup_date`, `change_pipeline_stage`, `add_lead`)
- By scheduled date range
- By contact/company name
- By confidence score range (e.g., "show low confidence" = score < 60)
