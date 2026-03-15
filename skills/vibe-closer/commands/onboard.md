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

### Welcome & Roadmap

Before asking any questions, welcome the user and lay out what's ahead:

> **Welcome to vibe-closer!**
>
> I'm going to help you set up an AI-powered pipeline assistant that handles outreach, follow-ups, and continuously learns from your results.
>
> Here's what we'll do together:
>
> 1. **Setup basics** — Pick a location, use case, and pipeline name (~1 min)
> 2. **Connect your tools** — Link your CRM, email, and other integrations (~3 min)
> 3. **Create your database** — Set up the activities table that tracks all outreach (~1 min)
> 4. **Build your pipeline content** — This is the big one: your profile, ICPs, messaging style, and strategy (~10 min)
> 5. **Learn your commands** — I'll walk you through everything you can do
> 6. **Set up automation** — Schedule recurring tasks so things run on autopilot
>
> Let's get started!

### Phase 1: Setup Basics

#### Step 1: Choose Location

Ask: "Where should I create your vibe-closer directory? This will be the root for all your pipelines."

Recommend `~/vibe-closer` as the default:
> "Recommended: `~/vibe-closer/` — this keeps all your pipelines in one place at your home directory."

If `~/vibe-closer/` already exists:
- List any existing pipelines inside it (`pipeline-*/`)
- Ask: "You already have pipelines here. Would you like to:"
  1. "Create a new pipeline alongside them"
  2. "Update an existing one" → switch to update mode with the selected pipeline

If user provides a custom path, use it. Otherwise use `~/vibe-closer`.

#### Step 2: Choose Use Case

If `$ARGUMENTS` specifies a use case, use it. Otherwise ask:

"What pipeline are you managing?"
1. **Sales** — B2B/B2C sales pipeline
2. **Fundraising** — Investor outreach
3. **Hiring** — Recruiting candidates
4. **BD / Partnerships** — Strategic partnerships
5. **Job Search** — Finding your next role
6. **VC Deal Flow** — Investor sourcing startups

#### Step 3: Name the Pipeline

Ask: "What should this pipeline be called? (e.g., 'paas-sales', 'series-a', 'eng-hiring')"

The workspace will be created at: `[vibe-closer-root]/pipeline-[pipeline-name]`

**Before creating:**
- Check if `[vibe-closer-root]/pipeline-[pipeline-name]` already exists
- If it exists: ask the user — "A pipeline named '[pipeline-name]' already exists at [path]. Would you like to:"
  1. "Update the existing pipeline" → switch to update mode
  2. "Choose a different name" → ask for a new name
- If it does not exist: proceed with creation

### Phase 2: Connect Your Tools

#### Step 4: Copy Template

Copy the matching template from `workspace-templates/{UseCase}/` to `[vibe-closer-root]/pipeline-[pipeline-name]/`.

#### Step 5: Configure MCP Providers

Walk through each `{{VARIABLE}}` in `config.md`. Explain what each provider does and why it matters, then ask the user to set its value.

#### Essential Providers (must configure)

1. `{{PIPELINE_NAME}}` — Set to the pipeline name from Step 3
2. `{{USER_EMAIL}}` — "What's your email address? I'll use this to detect replies to your outreach and match them to leads."
3. `{{CRM_TRACKER}}` — "Which CRM do you use? This is where your leads live — I'll read follow-up dates, pipeline stages, and notes from it."
   - Which MCP? (e.g., Attio MCP, HubSpot MCP)
   - Pull all leads tool hint
   - Follow-up date field name
   - Status field name
   - Notes field name
4. `{{EMAIL_SENDING}}` — "Which email provider should I use to draft and send outreach? (e.g., Gmail MCP)"
5. `{{EMAIL_INBOX}}` — "Which email provider should I read incoming emails from? (e.g., Gmail MCP — usually the same as sending)"

#### Optional Providers (can add later)

Tell the user: "These are optional — each has a sensible default. You can always change them later with `/onboard update`. Want to configure any of these now?"

6. `{{EMAIL_ENRICHMENT}}` — Find email addresses for leads. Default: Use CRM.
7. `{{PROFILE_ENRICHMENT}}` — Research lead profiles. Default: Open LinkedIn in browser.
8. `{{WEBSITE_CRAWLING}}` — Crawl company websites. Default: Open website in browser.
9. `{{FETCH_RELATIONSHIPS}}` — Find mutual connections. Default: Village MCP.
10. `{{NOTETAKER}}` — Pull meeting transcripts. Default: Fathom, Granola.

#### Scoring

11. `{{AUTO_APPROVE_THRESHOLD}}` — "Minimum confidence score (0–100) for auto-approving generated outreach. Default: 80. Set to 101 to disable auto-approval entirely."

For each variable, update `config.md` with the value: `{{VARIABLE_NAME : user_value}}`.

### Phase 3: Create Activities Database

> "Now I'll create the database table that tracks every outreach draft, approval decision, and execution result. This is how I remember what's been sent and learn from the results."

Using `{{ACTIONS_DB}}` provider (default: Supabase MCP), create the activities table.

Replace `{{PIPELINE_NAME}}` with the actual pipeline name and execute:

```sql
CREATE TABLE IF NOT EXISTS vibe_closer_{{PIPELINE_NAME}}_activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  approval_status TEXT NOT NULL DEFAULT 'pending' CHECK (approval_status IN ('pending', 'approved', 'rejected')),
  execution_status TEXT NOT NULL DEFAULT 'pending' CHECK (execution_status IN ('pending', 'running', 'finished')),
  activity_type TEXT NOT NULL CHECK (activity_type IN ('send_email', 'send_linkedin', 'update_followup_date', 'change_pipeline_stage', 'add_lead')),
  contacts JSONB NOT NULL DEFAULT '[]',
  account JSONB NOT NULL DEFAULT '{}',
  scheduled_date TIMESTAMPTZ,
  summary TEXT,
  full_lead_context TEXT,
  learnings TEXT,
  notes JSONB NOT NULL DEFAULT '[]',
  needs_regeneration BOOLEAN NOT NULL DEFAULT false,
  body JSONB NOT NULL DEFAULT '{}',
  body_history JSONB NOT NULL DEFAULT '[]',
  confidence_score INTEGER CHECK (confidence_score >= 0 AND confidence_score <= 100),
  scoring_breakdown JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_activities_approval ON vibe_closer_{{PIPELINE_NAME}}_activities (approval_status);
CREATE INDEX idx_activities_execution ON vibe_closer_{{PIPELINE_NAME}}_activities (execution_status);
CREATE INDEX idx_activities_scheduled ON vibe_closer_{{PIPELINE_NAME}}_activities (scheduled_date);
CREATE INDEX idx_activities_regeneration ON vibe_closer_{{PIPELINE_NAME}}_activities (needs_regeneration) WHERE needs_regeneration = true;
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

### Phase 4: Build Pipeline Content

Before delegating to `actions/update-content.md`, help the user understand what this phase does and what sources they can point you at:

> "Now comes the most important part — building your pipeline content. I'll ask you questions about your business, goals, and targets, then research available sources to generate your profile, ICPs, messaging guidelines, and strategy."
>
> **To make this really good, you can point me at existing materials.** The more context I have, the better your outreach will be. Here are some ideas:
>
> - "Go through all my Apollo campaigns and extract what's working"
> - "Check my ICPs from this doc: [paste a link or file path]"
> - "Check my pitch deck in this folder: [path]"
> - "Review my last 50 emails to understand my communication style"
> - "Check the LinkedIn profiles of 50 customers you get from our Customer.io / CRM to analyze their ICP"
> - "Look at my last 10 Fathom/Granola meeting transcripts for how I pitch"
> - "Read through my Notion sales playbook"
> - "Analyze my Outreach.io / Salesloft sequence performance data"
> - "Check my company website and blog for positioning"
> - "Look at my competitor's websites: [URLs]"
> - "Review this Google Doc with my sales methodology: [link]"
>
> **What sources should I pull from?** You can list multiple, or just say "let's start from scratch" and I'll ask you everything directly.

Wait for the user to respond, then execute `actions/update-content.md`. This will:
1. Ask foundational questions about your business, goals, and targets
2. Research available sources (website, emails, meetings, network) using configured MCPs
3. Generate workspace content in 3 rounds (profile → strategy → messaging), pausing after each for your feedback
4. Present a final summary of everything generated

Wait for update-content to complete before proceeding.

### Phase 5: Your Command Toolkit

After content building is complete, educate the user on everything they can do:

> **Here's your full command toolkit.** These are all the slash commands you can use:
>
> **Daily workflow:**
> - `/followup` — Process all leads due for follow-up. Fetches their context, drafts personalized outreach, presents it for your approval, then executes approved activities.
> - `/discover-leads` — Find new leads from your email, meetings, network, and CRM sources.
>
> **Pipeline management:**
> - `/view-pending-activity` — See all drafted activities waiting for your review. Filter by type, date, contact, or confidence score. Approve, edit, or reject from here.
> - `/execute-actions` — Run all approved activities right now (send emails, update CRM, etc.). Also great as a scheduled command.
> - `/poll-new-activity` — Check for new email replies and automatically trigger follow-up cycles for leads who responded.
>
> **Improvement:**
> - `/learn` — Analyze what's working in your outreach. Looks at your edits, notes, and results to find patterns, then updates your messaging guidelines, ICPs, and workflow rules.
>
> **Maintenance:**
> - `/onboard update` — Change providers, update content, modify database schema, or switch use cases.
> - `/re-index` — Refresh the workspace file index after you've made manual edits to any files.

### Phase 6: Recommended Automation

> **To get the most out of vibe-closer, I recommend setting up these automations:**
>
> 1. **`/followup`** — Run daily (e.g., every morning at 9am)
>    Processes all due leads so nothing falls through the cracks.
>
> 2. **`/poll-new-activity`** — Run every 15 minutes
>    Detects email replies and moves leads back into your follow-up queue automatically.
>
> 3. **`/execute-actions`** — Run every 15 minutes
>    Sends approved activities automatically so there's no delay after you approve something.
>
> 4. **`/learn`** — Run once daily (e.g., end of day)
>    Reviews your edits and results to continuously improve outreach quality over time.
>
> **Would you like me to set up any or all of these schedules now?**

If the user wants to set up schedules, use the CronCreate tool to create them with the appropriate intervals.

### Confirmation

Print a final summary:
```
🎉 Pipeline created at: [vibe-closer-root]/pipeline-[pipeline-name]

Pipeline: [name]
Use case: [type]
CRM: [provider]
Email: [provider]
Database: [provider] — table: vibe_closer_[name]_activities

Schedules: [list any that were set up, or "None — you can set these up anytime with /onboard update"]

What's next?
- Run /followup to process any due leads
- Run /discover-leads to find new prospects
- Run /view-pending-activity to review drafted outreach
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

If upgrading to v1.8.0+ (confidence scoring), run this migration:
```sql
ALTER TABLE vibe_closer_{{PIPELINE_NAME}}_activities
  ADD COLUMN IF NOT EXISTS confidence_score INTEGER CHECK (confidence_score >= 0 AND confidence_score <= 100),
  ADD COLUMN IF NOT EXISTS scoring_breakdown JSONB NOT NULL DEFAULT '{}';
```

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
