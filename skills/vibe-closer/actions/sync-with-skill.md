# Sync With Skill

Re-sync workspace artifacts from the skill's source files. Run this after the skill has been updated to refresh generated files in the workspace.

## Items to sync

### 1. Activity Viewer

Regenerate `{WORKSPACE_DIR}/activity-viewer.html` from the source template:

1. **Read pipeline config** from `pipeline-config.md` — extract:
   - `{{ACTIVITIES_TABLE}}`
   - `{{PIPELINE_NAME}}`
   - `{{USER_EMAIL}}`
   - `{{AUTO_APPROVE_THRESHOLD}}`

2. **Resolve Supabase credentials** via `{{ACTIONS_DB}}` provider (Supabase MCP):
   - Call `get_project_url` → Supabase URL
   - Call `get_publishable_keys` → anon key

3. **Read HTML template** from `skills/vibe-closer/views/activity-viewer.html`

4. **Token replacement** — Replace all `%%PLACEHOLDER%%` tokens with resolved values

5. **Write** the result to `{WORKSPACE_DIR}/activity-viewer.html` (overwrite existing)

6. **Report**: "Synced activity-viewer.html from skill template."

## Output

After syncing all items, summarize what was updated:

> **Sync complete:**
> - Activity Viewer — regenerated from template
