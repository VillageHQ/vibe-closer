---
description: "Execute all approved, due activities — sends outreach, updates CRM, adds leads"
---

# Execute Approved Activity

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

## Phase 0: Pre-flight Validation

1. Read `pipeline-config.md` → resolve `{{ACTIONS_DB}}`, `{{CRM_TRACKER}}`, and the `## Channels` section
2. Query `{{ACTIONS_DB}}` to confirm connectivity (e.g., `SELECT 1`). If unavailable, log as `failed` via `actions/add-log.md` and abort — this is the only point that should interrupt the user
3. For each channel listed in `## Channels`, note whether its **Provider** is an MCP tool or manual. No need to test each provider upfront — failures are handled per-activity in Phase 3

## Phase 1: Recover Stale Activities

Query `{{ACTIONS_DB}}` for activities stuck in a previous run:

```sql
UPDATE {{ACTIVITIES_TABLE}}
SET execution_status = 'pending', updated_at = now()
WHERE execution_status = 'running'
  AND updated_at < now() - interval '30 minutes'
```

Track the number of recovered rows for the final report.

## Phase 2: Fetch Due Activities

```sql
SELECT * FROM {{ACTIVITIES_TABLE}}
WHERE approval_status = 'approved'
  AND execution_status = 'pending'
  AND (scheduled_date IS NULL OR scheduled_date <= now())
ORDER BY scheduled_date ASC NULLS FIRST
```

If zero results: report "No approved activities are due for execution." → log as `successful` via `actions/add-log.md` with that summary → stop here.

## Phase 3: Batch Execute

Initialize counters: `executed = 0`, `failed = 0`, `deferred = 0`, plus `failures` list and `manual_actions` list.

For each activity:

1. Set `execution_status = 'running'` and `updated_at = now()`
2. **Test Mode Check**: If `pipeline-config.md` contains `**Test Mode**: true`, then for outreach activities (`send_{channel}`): skip the channel Provider call, set `execution_status = 'finished'` and `updated_at = now()`, log `[TEST MODE] Skipped send for [contact] via [channel]: [summary]`, increment `executed`, and continue to next activity. CRM operations (`add_lead`, `update_followup_date`, `change_pipeline_stage`) execute normally even in test mode.
3. Execute based on activity type (see below)
4. On success: set `execution_status = 'finished'` and `updated_at = now()`, increment `executed`
5. On failure: reset `execution_status = 'pending'` and `updated_at = now()`, add to `failures` list with error detail, increment `failed`, **continue to next activity**

### Outreach Activities (`send_{channel}`)

For any `activity_type` starting with `send_`:

1. Strip the `send_` prefix to get the channel name (e.g., `send_email` → `email`, `send_linkedin` → `linkedin`, `send_twitter` → `twitter`)
2. Look up `pipeline-config.md` → `## Channels` → `### {channel_name}` to get the channel configuration
3. Follow the channel's **Execution** instructions, passing `body` fields per the channel's **Body Schema**:
   - **If the channel has an MCP Provider** (e.g., Gmail MCP): use that provider to send or draft the message. Pass recipients/subject/message/etc. from the activity's `body` JSONB
   - **If the channel is manual** (e.g., "browser automation / manual"): mark `execution_status = 'finished'` and add to `manual_actions` list with the message content and any relevant URLs (profile_url, handle, etc.) ready to copy. Increment `executed`
4. If the channel is not found in `pipeline-config.md`: add to `failures` list with reason "Channel '{channel_name}' not configured", increment `failed`

### CRM Operations

#### `add_lead`
1. Use `{{CRM_TRACKER}}` to create the lead using `body.contacts` and `body.account`
2. Set initial stage from `body.initial_stage` and source from `body.source`
3. Set follow-up date to `body.followup_date` if provided, otherwise today — ensures new leads are picked up by the next `/followup` run
4. If the lead already exists (duplicate): treat as success, not failure

#### `update_followup_date`
1. Look up the lead in `{{CRM_TRACKER}}` via the activity's `contacts` field
2. Update the lead's follow-up date to `body.new_date`

#### `change_pipeline_stage`
1. Look up the lead in `{{CRM_TRACKER}}` via the activity's `contacts` field
2. Update the lead's pipeline stage from `body.from_stage` to `body.to_stage`

## Phase 4: Report + Log

Present a structured summary to the user:

```
Execution complete.
- Executed: [N] ([breakdown by type, e.g., "3 emails drafted, 1 lead added, 1 stage update"])
- Failed: [N]
- Deferred: [N] (provider unavailable)
- Recovered stale: [N]
```

If `failures` is non-empty, list each:
```
Failures:
- [contact name] / [activity_type]: [error reason]
```

If `manual_actions` is non-empty, list each:
```
Requires manual action:
- [contact name] ([channel]): [message preview + URL to copy]
```

### Log

Log the execution result via `actions/add-log.md`:
- `action_name`: `execute-approved-activity`
- `action_type`: `command`
- `status`: `successful` if all executed with zero failures, `partial` if some failed, `failed` if all failed or DB was unavailable
- `summary`: The execution summary line (e.g., "Executed 5 activities (3 emails, 2 CRM updates), 1 failed, 1 manual action")
- `lead_context`: JSON with lead names from executed activities
- `error_detail`: Concatenated failure details if status is `partial` or `failed`, otherwise `NULL`
