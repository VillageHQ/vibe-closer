# Get Leads

## fetch-due-leads

Use `{{CRM_TRACKER}}` to pull leads where the follow-up date field (`{{CRM_TRACKER.followup_field}}`) is today or in the past.

Steps:
1. Connect to CRM using the configured MCP provider
2. Query the lead list specified in `{{CRM_TRACKER.lead_list_query}}`
3. Filter: follow-up date <= today
4. Sort: oldest follow-up first
5. Return: name, email, company, status, follow-up date

## fetch-all-leads

Use `{{CRM_TRACKER}}` to pull all leads from the configured lead list.

Steps:
1. Connect to CRM using the configured MCP provider
2. Query the lead list specified in `{{CRM_TRACKER.lead_list_query}}`
3. Sort: follow-up date ascending
4. Return: name, email, company, status, follow-up date

## Output Format

Present as a table:

| # | Name | Company | Status | Follow-up Date | Last Activity |
|---|------|---------|--------|----------------|---------------|
| 1 | ... | ... | ... | ... | ... |
