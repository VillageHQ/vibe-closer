# View Pending Activity

## Browser Viewer (Default)

Open the activity viewer from `{WORKSPACE_DIR}/activity-viewer.html`.

### First-time setup

If `activity-viewer.html` does not exist in the workspace directory:

1. **Read pipeline config** from `pipeline-config.md` — extract:
   - `{{ACTIVITIES_TABLE}}`
   - `{{PIPELINE_NAME}}`
   - `{{USER_EMAIL}}`
   - `{{AUTO_APPROVE_THRESHOLD}}`

2. **Resolve Supabase credentials** via `{{ACTIONS_DB}}` provider (Supabase MCP):
   - Call `get_project_url` → Supabase URL (e.g., `https://xxx.supabase.co`)
   - Call `get_publishable_keys` → anon key

3. **Read HTML template** from `skills/vibe-closer/views/activity-viewer.html`

4. **Token replacement** — Replace these tokens in the HTML template:
   - `%%SUPABASE_URL%%` → Supabase project URL
   - `%%SUPABASE_ANON_KEY%%` → Supabase anon key
   - `%%ACTIVITIES_TABLE%%` → activities table name
   - `%%PIPELINE_NAME%%` → pipeline name
   - `%%USER_EMAIL%%` → user email
   - `%%AUTO_APPROVE_THRESHOLD%%` → auto-approve threshold (number)

5. **Write to workspace** — Write the replaced HTML to `{WORKSPACE_DIR}/activity-viewer.html`

### Open viewer

Open `{WORKSPACE_DIR}/activity-viewer.html` in the browser:
- macOS: `open {WORKSPACE_DIR}/activity-viewer.html`
- Linux: `xdg-open {WORKSPACE_DIR}/activity-viewer.html`

Confirm to user:
> "Opened the activity viewer in your browser. Changes are saved to Supabase in real-time."

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
