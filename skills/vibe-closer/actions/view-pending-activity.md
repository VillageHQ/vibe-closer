# View Pending Activity

## Browser Viewer (Default)

Open the pipeline viewer from `{WORKSPACE_DIR}/activity-viewer.html`.

### First-time setup

If `activity-viewer.html` or `.config/pipeline-view-config.js` does not exist in the workspace directory:

Run `actions/setup-workspace-artifacts.md` to generate the config and copy the viewer.

### Open viewer

Open `{WORKSPACE_DIR}/activity-viewer.html` in the browser:
- macOS: `open {WORKSPACE_DIR}/activity-viewer.html`
- Linux: `xdg-open {WORKSPACE_DIR}/activity-viewer.html`

Confirm to user:
> "Opened the pipeline viewer in your browser. You can switch between View Leads and View Activities using the sidebar."

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
