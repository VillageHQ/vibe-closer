---
description: "Onboard into a new vibe-closer pipeline workspace, or update an existing one"
argument-hint: "[use-case: sales|hiring|fundraising|bd|jobsearch|vcdealflow] or [update]"
---

# Onboard

Walk the user through creating or updating a vibe-closer pipeline workspace.

## Mode Detection

Before starting, determine which mode to run in:

### Update mode

Trigger update mode if ANY of these are true:
- `$ARGUMENTS` contains "update"
- The current working directory is inside a `vibe-closer/pipeline-*/` directory with a `config.md`
- The user explicitly asks to update or change settings on an existing pipeline

**In update mode**, skip to the [Update Existing Pipeline](#update-existing-pipeline) section below.

### First-time onboarding mode

If none of the update conditions are met, proceed with the full onboarding flow below.

---

## First-Time Onboarding

### Step 1: Choose Location

Ask: "Where should I create your vibe-closer directory? This will be the root for all your pipelines."

Recommend `~/vibe-closer` as the default:
> "Recommended: `~/vibe-closer/` — this keeps all your pipelines in one place at your home directory."

If `~/vibe-closer/` already exists:
- List any existing pipelines inside it (`pipeline-*/`)
- Ask: "You already have pipelines here. Would you like to:"
  1. "Create a new pipeline alongside them"
  2. "Update an existing one" → switch to update mode with the selected pipeline

If user provides a custom path, use it. Otherwise use `~/vibe-closer`.

### Step 2: Choose Use Case

If `$ARGUMENTS` specifies a use case, use it. Otherwise ask:

"What pipeline are you managing?"
1. **Sales** — B2B/B2C sales pipeline
2. **Fundraising** — Investor outreach
3. **Hiring** — Recruiting candidates
4. **BD / Partnerships** — Strategic partnerships
5. **Job Search** — Finding your next role
6. **VC Deal Flow** — Investor sourcing startups

### Step 3: Name the Pipeline

Ask: "What should this pipeline be called? (e.g., 'paas-sales', 'series-a', 'eng-hiring')"

The workspace will be created at: `[vibe-closer-root]/pipeline-[pipeline-name]`

**Before creating:**
- Check if `[vibe-closer-root]/pipeline-[pipeline-name]` already exists
- If it exists: ask the user — "A pipeline named '[pipeline-name]' already exists at [path]. Would you like to:"
  1. "Update the existing pipeline" → switch to update mode
  2. "Choose a different name" → ask for a new name
- If it does not exist: proceed with creation

### Step 4: Copy Template

Copy the matching template from `workspace-templates/{UseCase}/` to `[vibe-closer-root]/pipeline-[pipeline-name]/`.

### Step 5: Configure MCP Providers

Walk through each `{{VARIABLE}}` in `config.md` and ask the user to set values:

#### Required
1. `{{PIPELINE_NAME}}` — Set to the pipeline name from Step 3
2. `{{CRM_TRACKER}}` — Which CRM MCP? (e.g., Attio MCP, HubSpot MCP)
   - Pull all leads tool hint
   - Follow-up date field name
   - Status field name
   - Notes field name
3. `{{EMAIL_SENDING}}` — Email provider MCP (e.g., Gmail MCP)
4. `{{EMAIL_INBOX}}` — Email inbox MCP (e.g., Gmail MCP)

#### Optional
5. `{{EMAIL_ENRICHMENT}}` — Default: Use CRM
6. `{{PROFILE_ENRICHMENT}}` — Default: Open LinkedIn in browser
7. `{{WEBSITE_CRAWLING}}` — Default: Open website in browser
8. `{{FETCH_RELATIONSHIPS}}` — Default: Village MCP
9. `{{NOTETAKER}}` — Default: Fathom, Granola

For each variable, update `config.md` with the value: `{{VARIABLE_NAME : user_value}}`.

### Step 6: Create Activities Database

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
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_activities_approval ON vibe_closer_{{PIPELINE_NAME}}_activities (approval_status);
CREATE INDEX idx_activities_execution ON vibe_closer_{{PIPELINE_NAME}}_activities (execution_status);
CREATE INDEX idx_activities_scheduled ON vibe_closer_{{PIPELINE_NAME}}_activities (scheduled_date);
```

#### Body Schemas by Activity Type

##### send_email
```json
{"subject": "string", "message": "string", "recipients": [{"name": "string", "email": "string"}], "fingerprint": "string"}
```

##### send_linkedin
```json
{"message": "string", "profile_url": "string", "fingerprint": "string"}
```

##### update_followup_date
```json
{"new_date": "ISO 8601 date", "reason": "string"}
```

##### change_pipeline_stage
```json
{"from_stage": "string", "to_stage": "string", "reason": "string"}
```

##### add_lead
```json
{"contacts": [{"name": "string", "email": "string"}], "account": {"company": "string", "domain": "string"}, "initial_stage": "string", "source": "string"}
```

### Step 7: Build Pipeline Content

Execute `actions/update-content.md`. This will:
1. Ask foundational questions about your business, goals, and targets
2. Research available sources (website, emails, meetings, network) using configured MCPs
3. Generate workspace content in 3 rounds (profile → strategy → messaging), pausing after each for your feedback
4. Present a final summary of everything generated

Wait for update-content to complete before proceeding.

### Step 8: Confirm

Print a summary:
```
Pipeline created at: [vibe-closer-root]/pipeline-[pipeline-name]
Pipeline: [name]
Use case: [type]
CRM: [provider]
Email: [provider]
Database: [provider] — table: vibe_closer_[name]_activities

Run /followup to process due leads, or /discover-leads to find new ones.
```

---

## Update Existing Pipeline

This flow runs when the user wants to modify an existing pipeline's configuration.

### Identify the Pipeline

If not already inside a pipeline directory:
- Check `~/vibe-closer/` for existing `pipeline-*/` directories
- List them and ask the user to select one
- Read the selected pipeline's `config.md` to understand current configuration

### Ask What to Update

Present the current pipeline summary (name, use case, providers) and ask:

"What would you like to update?"
1. **MCP providers** — Change CRM, email, enrichment, or other provider connections
2. **Pipeline content** — Update profile, messaging guidelines, goals, or strategy
3. **Database schema** — Recreate or migrate the activities table
4. **Use case / template** — Switch to a different pipeline type (warning: this may overwrite custom content)

### Execute the Selected Update

#### Option 1: MCP Providers
- Show current provider values from `config.md`
- Ask which specific providers to change
- Update only the selected `{{VARIABLE}}` entries in `config.md`
- Do NOT touch any other files

#### Option 2: Pipeline Content
- Execute `actions/update-content.md` — it will audit current workspace files and ask targeted questions to rebuild or refine content
- This covers: `profile/`, `goals.md`, `workflow-planner.md`, `messaging-guidelines/`, `lead_preferences/`

#### Option 3: Database Schema
- Show current table name from `config.md`
- Ask if they want to:
  - Recreate the table (warning: this drops existing data)
  - Add columns or indexes (provide the ALTER TABLE statements)
- Execute the chosen SQL via `{{ACTIONS_DB}}`

#### Option 4: Use Case / Template
- Warn: "Switching use cases will overwrite template files (profile, messaging guidelines, workflow planner, lead preferences). Your config.md and database will be preserved. Custom changes to overwritten files will be lost."
- If confirmed: copy new template files, preserve `config.md`
- Recommend running "Pipeline content" update afterward to personalize the new template

### Confirm Update

Print a summary of what was changed:
```
Updated pipeline: [name] at [path]
Changes: [list of what was modified]

Your pipeline is ready. Run /followup to continue working.
```
