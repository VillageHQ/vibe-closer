# View Pending Activity

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
- **Reject** → delete from DB

## Filtering

Support filters:
- By activity type: `send_email`, `send_linkedin`, etc.
- By scheduled date range
- By contact/company name
- By confidence score range (e.g., "show low confidence" = score < 60)
