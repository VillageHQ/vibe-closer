---
description: "Update workspace to the latest plugin version — sync artifacts and apply migrations"
---

# Update Skill

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

## Phase 1: Version Check

1. Read `{{WORKSPACE_VERSION}}` from `pipeline-config.md` → `## Meta` section
   - If the field is missing or set to "Never", treat it as `0.0.0`
2. Read the plugin version from `.claude-plugin/plugin.json` (relative to the skill root: `../../.claude-plugin/plugin.json`)
3. Compare versions:
   - **If equal**: "Workspace is up to date (v{version})." — stop here.
   - **If workspace < plugin**: proceed to Phase 2.

## Phase 2: Discover Migrations

1. Scan `skills/vibe-closer/migrations/` for files named `v{semver}.md`
2. Filter to versions > workspace version AND <= plugin version
3. Sort ascending by version
4. Present a summary to the user:

```
## Pending Updates

Your workspace is at v{workspace_version}. The latest plugin is v{plugin_version}.

### v1.31.0 — Pipeline Viewer with CRM Leads
- New: View All Leads from CRM with inline editing
- New: Vertical sidebar layout (View Leads / View Activities)
- New: .config/pipeline-view-config.js for viewer config
- Changed: activity-viewer.html is now static (no token replacement)

Applying updates...
```

## Phase 3: Apply Migrations

For each pending migration in ascending version order:

1. Read the migration file (e.g., `skills/vibe-closer/migrations/v1.31.0.md`)
2. Execute the instructions in its `## Migration Steps` section **exactly** — do only what the migration specifies
3. Do NOT automatically sync all artifacts unless the migration explicitly instructs it

## Phase 4: Finalize

1. Update `{{WORKSPACE_VERSION}}` in `pipeline-config.md` → `## Meta` to the current plugin version
2. Report:
   ```
   Workspace updated to v{plugin_version}.
   Applied {N} migration(s): v1.31.0, ...
   ```
3. Log via `actions/add-log.md`

## Final: Log

Log a summary of this entire execution using `actions/add-log.md`.
