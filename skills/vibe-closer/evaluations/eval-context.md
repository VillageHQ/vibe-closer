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

### TC-5: Context output format completeness
**Action**: fetch-full-lead-context
**Pass if**: Output contains ALL section headers (Summary, ICP Match Analysis, People, Email History, Meeting History, CRM Notes & Activity Log, Key Selling Points, Warm Paths) and email entries include subject lines, direction, key content, and action items

### TC-6: Stored full_lead_context in generated activity
**Setup**: Generate an activity for a lead with email and meeting history
**Action**: generate-lead-activity, then inspect stored `full_lead_context`
**Pass if**: Stored context contains the complete gather-lead-context output (not re-summarized) PLUS a "Generation Context" appendix with workspace guidelines applied, template used, sequence-flow step, and previous activity history

### TC-7: Warm path detection
**Setup**: Lead has mutual connection via FETCH_RELATIONSHIPS
**Action**: fetch-full-lead-context
**Pass if**: "Warm Paths" section populated with connection details
