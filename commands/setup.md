---
description: "Set up a new vibe-closer pipeline workspace"
argument-hint: "[use-case: sales|hiring|fundraising]"
---

# Setup

Guide the user through creating a vibe-closer pipeline workspace.

## Step 1: Choose Location

Ask: "Where should I create your pipeline workspace? Default: current working directory"

If user provides a path, use it. Otherwise use the current working directory.

## Step 2: Choose Use Case

If `$ARGUMENTS` specifies a use case, use it. Otherwise ask:

"What pipeline are you managing?"
1. **Sales** — B2B/B2C sales pipeline
2. **Fundraising** — Investor outreach
3. **Hiring** — Recruiting candidates
4. **BD / Partnerships** — Strategic partnerships
5. **Job Search** — Finding your next role

## Step 3: Name the Pipeline

Ask: "What should this pipeline be called? (e.g., 'paas-sales', 'series-a', 'eng-hiring')"

The workspace will be created at: `[workspace_directory]/vibe-closer/pipeline-[pipeline-name]`

**Before creating:**
- Check if `[workspace_directory]/vibe-closer/pipeline-[pipeline-name]` already exists
- If it exists: ask the user — "A pipeline named '[pipeline-name]' already exists at [path]. Would you like to:"
  1. "Update the existing pipeline" → only modify the specific settings the user requests, do NOT overwrite all files
  2. "Choose a different name" → ask for a new name
- If it does not exist: proceed with creation

## Step 4: Copy Template

Copy the matching template from `workspace-templates/{UseCase}/` to `[workspace_directory]/vibe-closer/pipeline-[pipeline-name]/`.

## Step 5: Configure MCP Providers

Walk through each `{{VARIABLE}}` in `config.md` and ask the user to set values:

### Required
1. `{{PIPELINE_NAME}}` — Set to the pipeline name from Step 3
2. `{{CRM_TRACKER}}` — Which CRM MCP? (e.g., Attio MCP, HubSpot MCP)
   - Pull all leads tool hint
   - Follow-up date field name
   - Status field name
   - Notes field name
3. `{{EMAIL_SENDING}}` — Email provider MCP (e.g., Gmail MCP)
4. `{{EMAIL_INBOX}}` — Email inbox MCP (e.g., Gmail MCP)

### Optional
5. `{{EMAIL_ENRICHMENT}}` — Default: Use CRM
6. `{{PROFILE_ENRICHMENT}}` — Default: Open LinkedIn in browser
7. `{{WEBSITE_CRAWLING}}` — Default: Open website in browser
8. `{{FETCH_RELATIONSHIPS}}` — Default: Village MCP
9. `{{NOTETAKER}}` — Default: Fathom, Granola

For each variable, update `config.md` with the value: `{{VARIABLE_NAME : user_value}}`.

## Step 6: Create Activities Database

Using `{{ACTIONS_DB}}` provider (default: Supabase MCP), create the activities table.

Replace `{{PIPELINE_NAME}}` with the actual pipeline name and execute:

```sql
CREATE TABLE IF NOT EXISTS vibe_closer_{{PIPELINE_NAME}}_activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  approval_status TEXT NOT NULL DEFAULT 'pending' CHECK (approval_status IN ('pending', 'approved')),
  execution_status TEXT NOT NULL DEFAULT 'pending' CHECK (execution_status IN ('pending', 'running', 'finished')),
  activity_type TEXT NOT NULL CHECK (activity_type IN ('send_email', 'send_linkedin', 'update_followup_date', 'change_pipeline_stage', 'add_lead')),
  contacts JSONB NOT NULL DEFAULT '[]',
  account JSONB NOT NULL DEFAULT '{}',
  scheduled_date TIMESTAMPTZ,
  summary TEXT,
  full_lead_context TEXT,
  learnings TEXT,
  body JSONB NOT NULL DEFAULT '{}',
  body_history JSONB NOT NULL DEFAULT '[]',
  notes TEXT[] NOT NULL DEFAULT '{}',
  needs_regeneration BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_activities_approval ON vibe_closer_{{PIPELINE_NAME}}_activities (approval_status);
CREATE INDEX idx_activities_execution ON vibe_closer_{{PIPELINE_NAME}}_activities (execution_status);
CREATE INDEX idx_activities_scheduled ON vibe_closer_{{PIPELINE_NAME}}_activities (scheduled_date);
CREATE INDEX idx_activities_type_status ON vibe_closer_{{PIPELINE_NAME}}_activities (activity_type, execution_status);
```

### Body Schemas by Activity Type

#### send_email
```json
{"subject": "string", "message": "string", "recipients": [{"name": "string", "email": "string"}], "fingerprint": "string"}
```

#### send_linkedin
```json
{"message": "string", "profile_url": "string", "fingerprint": "string"}
```

#### update_followup_date
```json
{"new_date": "ISO 8601 date", "reason": "string"}
```

#### change_pipeline_stage
```json
{"from_stage": "string", "to_stage": "string", "reason": "string"}
```

#### add_lead
```json
{"contacts": [{"name": "string", "email": "string"}], "account": {"company": "string", "domain": "string"}, "initial_stage": "string", "source": "string"}
```

## Step 7: Build Pipeline Content

Execute `actions/update-content.md`. This will:
1. Ask foundational questions about your business, goals, and targets
2. Research available sources (website, emails, meetings, network) using configured MCPs
3. Generate workspace content in 3 rounds (profile → strategy → messaging), pausing after each for your feedback
4. Present a final summary of everything generated

Wait for update-content to complete before proceeding.

## Step 8: Confirm

Print a summary:
```
Pipeline created at: [workspace_directory]/vibe-closer/pipeline-[pipeline-name]
Pipeline: [name]
Use case: [type]
CRM: [provider]
Email: [provider]
Database: [provider] — table: vibe_closer_[name]_activities

Run /followup to process due leads, or /discover-leads to find new ones.
```
