---
description: "View pipeline activity logs — what commands ran, their outcomes, and status"
argument-hint: "[optional: 'today' | 'failed' | number of recent entries]"
---

# View Logs

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

## Phase 1: Build Query

Query `{{LOGS_TABLE}}` via `{{ACTIONS_DB}}`. Apply filters based on `$ARGUMENTS`:

- `today` — filter to `created_at >= current_date`
- `failed` — filter to `status IN ('failed', 'partial')`
- A number (e.g., `10`) — `LIMIT` to that many entries
- No arguments — default to last 20 entries

Always order by `created_at DESC`.

## Phase 2: Display Results

Present as a table:

| # | Time | Command | Status | Summary |
|---|------|---------|--------|---------|
| 1 | ... | ... | ... | ... |

If `error_detail` is populated for any entry, show it below the table under a "Errors" section.

If no logs exist, tell the user: "No logs found. Logs are recorded automatically each time a command runs."
