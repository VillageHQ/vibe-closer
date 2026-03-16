# Open Activity Viewer

Open the rich HTML activity viewer in the user's default browser.

## Steps

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

5. **Write to temp file** — Write the replaced HTML to:
   `/tmp/vc-activity-viewer-{PIPELINE_NAME}-{unix_timestamp_seconds}.html`
   The timestamp ensures a fresh file each time.

6. **Open in browser** — Run:
   - macOS: `open /tmp/vc-activity-viewer-{PIPELINE_NAME}-{timestamp}.html`
   - Linux: `xdg-open /tmp/vc-activity-viewer-{PIPELINE_NAME}-{timestamp}.html`

7. **Confirm to user**:
   > "Opened the activity viewer in your browser. You can approve, edit, and manage activities directly from there."
   >
   > "The viewer connects to your Supabase database in real-time — changes you make in the browser are saved immediately."
