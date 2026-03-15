# Add Log Entry

Log the result of a command execution to the logs table.

## Steps

1. Insert a log entry into `{{LOGS_TABLE}}` via `{{ACTIONS_DB}}`:

```sql
INSERT INTO {{LOGS_TABLE}} (action_name, action_type, status, summary, lead_context, error_detail)
VALUES ('<command-name>', '<action|command>', '<status>', '<summary>', '<lead_context>', '<error_detail>');
```

## Field Guide

| Field | Description |
|---|---|
| `action_name` | The command or action file name (e.g., `followup`, `discover-leads`, `execute-approved-activity`) |
| `action_type` | `'command'` for slash commands, `'action'` for standalone action invocations |
| `status` | `'successful'` — completed as expected. `'failed'` — could not complete. `'partial'` — some phases succeeded, others did not |
| `summary` | 1-2 sentence description of the **outcome**, not just the action. Good: "Processed 5 due leads, drafted 4 outreach emails, 1 auto-approved." Bad: "Ran followup command." |
| `lead_context` | Optional JSON with lead names/companies if the command was lead-specific. Use `'{}'` if not applicable |
| `error_detail` | Populated only on `'failed'` or `'partial'` status. Contains the error message or reason for failure. Use `NULL` if successful |
