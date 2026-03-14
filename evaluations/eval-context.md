# Eval: Context Gathering

Test that lead context aggregation works across all sources.

## Test Cases

### TC-1: Basic context
**Setup**: Lead exists in CRM with name, email, company
**Action**: fetch-basic-lead-context
**Pass if**: Returns name, email, company, status, follow-up date

### TC-2: Full context aggregation
**Setup**: Lead with CRM notes, email threads, meeting transcript, LinkedIn profile
**Action**: fetch-full-lead-context
**Pass if**: Context includes data from ALL configured sources

### TC-3: Missing source graceful handling
**Setup**: Lead exists but NOTETAKER MCP is not configured
**Action**: fetch-full-lead-context
**Pass if**: Returns partial context, notes which sources were unavailable

### TC-4: ICP matching
**Setup**: Lead at a SaaS company, ICP1 targets SaaS
**Action**: research-lead
**Pass if**: Output maps lead to correct ICP and relevant pain points

### TC-5: Context output format
**Action**: fetch-full-lead-context
**Pass if**: Output matches the markdown template from gather-lead-context.md

### TC-6: Warm path detection
**Setup**: Lead has mutual connection via FETCH_RELATIONSHIPS
**Action**: fetch-full-lead-context
**Pass if**: "Warm Paths" section populated with connection details
