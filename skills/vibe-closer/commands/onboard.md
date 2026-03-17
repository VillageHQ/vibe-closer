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
- The current working directory is inside a `vibecloser-pipelines/pipeline-*/` directory with a `pipeline-config.md`
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

Ask: "Where should I create your vibecloser-pipelines directory? This will be the root for all your pipelines."

Recommend `~/vibecloser-pipelines` as the default:
> "Recommended: `~/vibecloser-pipelines/` — this keeps all your pipelines in one place at your home directory."

If `~/vibecloser-pipelines/` already exists:
- List any existing pipelines inside it (`pipeline-*/`)
- Ask: "You already have pipelines here. Would you like to:"
  1. "Create a new pipeline alongside them"
  2. "Update an existing one" → switch to update mode with the selected pipeline

If user provides a custom path, use it. Otherwise use `~/vibecloser-pipelines`.

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

The workspace will be created at: `[vibecloser-pipelines-root]/pipeline-[pipeline-name]`

**Before creating:**
- Check if `[vibecloser-pipelines-root]/pipeline-[pipeline-name]` already exists
- If it exists: ask the user — "A pipeline named '[pipeline-name]' already exists at [path]. Would you like to:"
  1. "Update the existing pipeline" → switch to update mode
  2. "Choose a different name" → ask for a new name
- If it does not exist: proceed with creation

### Phase 2: Connect Your Tools

#### Step 4: Copy Template

Copy the matching template from `workspace-templates/{UseCase}/` to `[vibecloser-pipelines-root]/pipeline-[pipeline-name]/`.

#### Step 4b: Detect Available MCPs

Before configuring providers, discover what tools the user already has connected:

1. Call `ListMcpResourcesTool` with no `server` parameter to get all resources from all connected MCP servers. Extract the unique `server` names from the results.
2. Supplement with a tool-name scan: look through available tools for names starting with `mcp__` and extract the server segment (the part between the first and second `__`). Merge with the servers found from resources to build a complete list.
3. Present the findings as **context, not decisions**:

> "Before we configure your tools, let me check what you already have connected..."
>
> "I can see these tools available: [list the detected MCP server names]. I'll use these as suggestions as we go — **you'll decide what to use for each step**."

4. Ask: "Are there any other tools you'd like to connect that aren't listed? (e.g., HubSpot, Outlook, Superhuman, a browser extension)"

If the user wants to connect a new MCP right now, guide them through the setup process. Keep track of where you are in onboarding so you can resume seamlessly afterward. Re-run detection to confirm the new MCP is available.

**Key principle:** Detection results are **hints only**. The user still explicitly chooses every provider and channel. Never skip a decision or auto-fill without the user's confirmation.

**Required MCP — Supabase:** Check if Supabase is among the detected MCPs. If not, inform the user early:
> "vibe-closer requires a Supabase MCP to store your activities and logs. I don't see one connected yet — let's get that set up before we continue."

Guide them through connecting Supabase MCP. Do not proceed past Phase 2 without Supabase connected.

#### Step 5: Configure MCP Providers

Walk through each `{{VARIABLE}}` in `pipeline-config.md`. For each variable, check if any of the detected MCPs could plausibly serve that role based on its name and capabilities. If so, mention it as a **suggestion** — but always ask the user to confirm or choose differently.

#### Essential Providers (must configure)

1. `{{PIPELINE_NAME}}` — Set to the pipeline name from Step 3
2. `{{USER_EMAIL}}` — If an email-related MCP was detected, suggest: "I see you have [MCP] connected — would you like me to pull your email from there, or would you prefer to enter it manually?" Wait for user choice. If they agree, use a safe read-only call (e.g., get profile) and confirm the result with them. Otherwise ask directly: "What's your email address?"
3. `{{CRM_TRACKER}}` — If a CRM-like MCP was detected, suggest: "I see you have [MCP] connected — would you like to use it as your CRM?" The user decides. If no CRM MCP was detected, ask the full question and offer to help install one.
   - Which MCP? (e.g., Attio MCP, HubSpot MCP)
   - Pull all leads tool hint
   - Follow-up date field name
   - Status field name
   - Notes field name

#### Step 5a: Import Pipeline Stages from CRM

After the CRM_TRACKER is configured (MCP name, status field name), import the pipeline stages:

1. **Query CRM for available stages** — Use the CRM MCP to discover the available values for the status field:
   - For Attio: use `list-attribute-definitions` to find the status field's select options on the relevant object/list
   - For HubSpot: query the deal stage pipeline options
   - For other CRMs: use the appropriate MCP tool to retrieve field options

2. **If stages are found:**
   - Present them: "I found these pipeline stages in your CRM: [list]. Want to use these as-is?"
   - Write confirmed stages to `pipeline-config.md` → `## Pipeline Stages` → `### Stages` as a numbered list with descriptions

3. **If no stages found** (CRM has no predefined status values):
   - Tell the user: "Your CRM doesn't have predefined stages for the status field '[field name]'. Please set up your pipeline stages in your CRM first, then run `/onboard update` to import them."
   - Do NOT proceed with onboarding until stages are configured in the CRM

4. **Collect transition rules** — For each stage, ask: "What triggers a lead moving from [Stage A] to [Stage B]?"
   - Write the transition rules to `pipeline-config.md` → `## Pipeline Stages` → `### Stage Transition Rules` as a From → To → Trigger table

5. **Validate** — Ensure that stage names in `sequence-flow.md` references (e.g., "mark as Closed Lost") use the exact stage names from the CRM import.

#### Step 5b: Configure Outreach Channels

Present the standard channel list. For each channel, dynamically check if any of the detected MCPs could plausibly serve as a provider for that channel — if so, add a hint. Do NOT hardcode which MCP maps to which channel; infer it from the MCP's name and capabilities at runtime.

> "Which channels would you like to execute actions on? (select all that apply)"
> 1. **Email** {if a relevant MCP detected: "(available — you have [MCP name] connected)"}
> 2. **LinkedIn** {if browser automation detected: "(available — you have browser automation)"}
> 3. **Twitter/X**
> 4. **Slack** {if a relevant MCP detected: "(available — you have [MCP name] connected)"}
> 5. **WhatsApp**
> 6. **Other** — describe your channel

For each selected channel, ask how they'd like to execute it:

**If a relevant MCP was detected for this channel:**
> "How would you like to execute **{channel}** outreach?"
> 1. **Use your [MCP name]** (already connected)
> 2. Use browser automation (a bit slower but effective)
> 3. Install a different MCP — I'll help you set it up
> 4. Remove channel for now (you can re-add via `/onboard update`)

**If no relevant MCP was detected:**
> "How would you like to execute **{channel}** outreach?"
> 1. Use browser automation (effective for {channel})
> 2. Install an MCP — I'll help you set it up
> 3. Manual (I'll present the message, you send it yourself)
> 4. Remove channel for now (you can re-add via `/onboard update`)

For **email** specifically: also ask about **Inbox Provider** for reply polling. Suggest using the same provider as for sending, but let the user decide.

**If user chooses "Install an MCP":** Guide them through the setup process. Keep track of where you are in onboarding so you can resume seamlessly after the MCP is connected. Re-run MCP detection to confirm the new MCP works, then continue.

Then populate the `## Channels` section in `pipeline-config.md` with one entry per channel. Each channel entry includes:
- **Provider**: the MCP or method
- **Inbox Provider** (email only): for polling replies
- **Guidelines**: path to `messaging-guidelines/{channel}-guidelines.md`
- **Templates**: path to templates file (if applicable)
- **Body Schema**: the JSON structure for the activity body (see default schemas below)
- **Fingerprint Method**: how to embed tracing fingerprints (or "None" for manual channels)
- **Execution**: natural-language instructions for how to execute this activity type
- **Polling**: how to poll for replies (or "None" if not supported)

For new channels beyond email and linkedin (e.g., twitter, whatsapp), create a `messaging-guidelines/{channel}-guidelines.md` file with sensible defaults for that channel's constraints (character limits, tone, timing).

##### Default Body Schemas by Channel

**email:**
```json
{"subject": "string", "message": "string", "recipients": [{"name": "string", "email": "string"}], "fingerprint": "string"}
```

**linkedin:**
```json
{"message": "string", "profile_url": "string", "fingerprint": "string"}
```

**twitter:**
```json
{"message": "string", "handle": "string", "fingerprint": "string"}
```

**Generic (other channels):**
```json
{"message": "string", "recipient_id": "string", "fingerprint": "string"}
```

#### Optional Providers (can add later)

Tell the user: "These are optional — each has a sensible default. You can always change them later with `/onboard update`. Want to configure any of these now?"

For each optional provider, dynamically check if any detected MCP looks relevant based on its name/capabilities. If so, mention it as a suggestion: "I see you have [MCP] connected — would you like to use it for [this role]? Or keep the default / skip?" The user decides.

4. `{{EMAIL_ENRICHMENT}}` — Find email addresses for leads. Default: Use CRM.
5. `{{PROFILE_ENRICHMENT}}` — Research lead profiles. Default: Open LinkedIn in browser.
6. `{{WEBSITE_CRAWLING}}` — Crawl company websites. Default: Open website in browser.
7. `{{FETCH_RELATIONSHIPS}}` — Find mutual connections. Default: Village MCP.
8. `{{NOTETAKER}}` — Pull meeting transcripts. Default: Fathom, Granola.

If no relevant MCP detected for a provider, present the default and ask if they want to configure it now or keep the default. If user wants to install a new MCP for any optional provider, guide them through setup, then resume.

#### Scoring

9. `{{AUTO_APPROVE_THRESHOLD}}` — "Minimum confidence score (0–100) for auto-approving generated outreach. Default: 80. Set to 101 to disable auto-approval entirely."

For each variable, update `pipeline-config.md` with the value: `{{VARIABLE_NAME : user_value}}`.

#### Step 5c: Connection Test

After all providers and channels are configured, run a connection test for every configured MCP.

1. For each MCP provider referenced in `pipeline-config.md`, run a **read-only, non-destructive** test call:
   - Look at the MCP's available tools and dynamically pick the safest read-only operation (prefer tools named like `whoami`, `get_profile`, `list_*`, `search_*` — anything that only reads data)
   - **Never** call tools that create, update, delete, or send anything
   - If no obviously safe read-only tool exists for an MCP, skip the test and note it as "untested (no safe read-only operation available)"

2. Present a summary:
   > "Connection test results:"
   > - [MCP name]: Connected [+ any useful detail like email or project name]
   > - [MCP name]: Connected
   > - [MCP name]: Failed — [error message]
   > - [MCP name]: Untested (no safe read-only test available)

3. For any **failed** connection:
   - If it's a **required** provider (Supabase): Block and help fix. Options:
     > 1. Retry the connection test
     > 2. Help me troubleshoot / reconnect this MCP
     > 3. I'll fix it myself and come back (`/onboard update`)
   - If it's an **optional** provider or channel: Options:
     > 1. Retry the connection test
     > 2. Help me troubleshoot / reconnect this MCP
     > 3. Remove this provider/channel for now (you can re-add via `/onboard update`)
     > 4. Keep it configured and I'll fix it later

4. Only proceed to Phase 3 (database creation) once all **required** providers pass the connection test.

#### Step 5d: Bootstrap MCP Hints

After the connection test, populate `pipeline-mcp-hints.md` with concrete examples from every provider that passed:

For each provider, record:
1. The exact MCP tool name used in the test (e.g., `mcp__claude_ai_Attio__list-records-in-list`)
2. The parameter structure that worked (with actual values like project_id, list name)
3. A brief note on what the response looks like

Also record the common operations for each provider (not just the test call):
- **CRM**: list leads, search lead, update lead, add note
- **Email**: search messages, read thread, create draft
- **Database**: execute SQL (include project_id and table names)
- **Meeting notes**: list meetings, search meetings

For operations not tested during connection test, note the likely tool name based on the MCP's available tools (the AI can see them) and mark as "untested — verify on first use".

### Phase 3: Create Activities Database

> "Now I'll create the database table that tracks every outreach draft, approval decision, and execution result. This is how I remember what's been sent and learn from the results."

Using `{{ACTIONS_DB}}` provider (default: Supabase MCP), create the activities and logs tables.

#### Step 1: Suggest Table Names

Derive table names from the pipeline name: lowercase it and replace hyphens/spaces with underscores.

Example: pipeline name `paas-sales` → `vibe_closer_paas_sales_activities` and `vibe_closer_paas_sales_logs`.

Present to user:
> "I'll create these database tables:"
> - Activities: `vibe_closer_[slug]_activities`
> - Logs: `vibe_closer_[slug]_logs`
>
> "Sound good, or would you prefer different names?"

#### Step 2: Check for Existing Tables

Query `{{ACTIONS_DB}}` to check if either table already exists:

```sql
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public' AND table_name IN ('[suggested_activities_name]', '[suggested_logs_name]')
```

**If one or both tables already exist**, ask:
1. "Drop the existing table(s) and recreate from scratch" (warning: deletes all data)
2. "Use a different slug" — ask for a new name, re-check, repeat until available
3. "Reuse the existing table(s) as-is" — skip CREATE for that table, just record the name

#### Step 3: Write Table Names to Config

Update `pipeline-config.md` with the resolved table names:
- `{{ACTIVITIES_TABLE}}`: the final activities table name
- `{{LOGS_TABLE}}`: the final logs table name

#### Step 4: Create Tables

For each table that needs creation (not reused), execute the SQL below via `{{ACTIONS_DB}}`:

```sql
CREATE TABLE IF NOT EXISTS {{ACTIVITIES_TABLE}} (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  approval_status TEXT NOT NULL DEFAULT 'pending' CHECK (approval_status IN ('pending', 'approved', 'rejected')),
  execution_status TEXT NOT NULL DEFAULT 'pending' CHECK (execution_status IN ('pending', 'running', 'finished')),
  activity_type TEXT NOT NULL,
  -- Convention: 'send_{channel}' for outreach (e.g., send_email, send_linkedin, send_twitter),
  -- or CRM ops: 'update_followup_date', 'change_pipeline_stage', 'add_lead'
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

CREATE INDEX idx_activities_approval ON {{ACTIVITIES_TABLE}} (approval_status);
CREATE INDEX idx_activities_execution ON {{ACTIVITIES_TABLE}} (execution_status);
CREATE INDEX idx_activities_scheduled ON {{ACTIVITIES_TABLE}} (scheduled_date);
CREATE INDEX idx_activities_regeneration ON {{ACTIVITIES_TABLE}} (needs_regeneration) WHERE needs_regeneration = true;
```

Also create the logs table for tracking command execution history:

```sql
CREATE TABLE IF NOT EXISTS {{LOGS_TABLE}} (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  action_name TEXT NOT NULL,
  action_type TEXT NOT NULL CHECK (action_type IN ('action', 'command')),
  status TEXT NOT NULL CHECK (status IN ('successful', 'failed', 'partial')),
  summary TEXT NOT NULL,
  lead_context JSONB DEFAULT '{}',
  error_detail TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_logs_action ON {{LOGS_TABLE}} (action_name);
CREATE INDEX idx_logs_status ON {{LOGS_TABLE}} (status);
CREATE INDEX idx_logs_created ON {{LOGS_TABLE}} (created_at DESC);
```

#### Body Schemas by Activity Type

##### Outreach Activities (`send_{channel}`)

Each channel defines its own body schema in `pipeline-config.md` → `## Channels` → `### {channel}` → `Body Schema`. See Step 5b above for default schemas.

##### CRM Operations

###### update_followup_date
```json
{"new_date": "ISO 8601 date", "reason": "string"}
```

###### change_pipeline_stage
```json
{"from_stage": "string", "to_stage": "string", "reason": "string"}
```

###### add_lead
```json
{"contacts": [{"name": "string", "email": "string"}], "account": {"company": "string", "domain": "string"}, "initial_stage": "string", "source": "string", "followup_date": "ISO 8601 date (default: today)"}
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

**Important context for update-content:** This is a FRESH onboarding — the workspace was just created from a template. All content files contain example content marked with `<!-- EXAMPLE CONTENT` markers. Every file must be rebuilt from scratch based on the user's actual business. Do NOT preserve or refine template example content — replace it entirely.

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
> - `/execute-approved-activity` — Run all approved activities right now (send emails, update CRM, etc.). Also great as a scheduled command.
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
> 3. **`/execute-approved-activity`** — Run every 15 minutes
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
🎉 Pipeline created at: [vibecloser-pipelines-root]/pipeline-[pipeline-name]

Pipeline: [name]
Use case: [type]
CRM: [provider]
Email: [provider]
Database: [provider] — tables: [{{ACTIVITIES_TABLE}} value], [{{LOGS_TABLE}} value]

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
- Check `~/vibecloser-pipelines/` for existing `pipeline-*/` directories
- List them and ask the user to select one
- Read the selected pipeline's `pipeline-config.md` to understand current configuration

### Ask What to Update

Present the current pipeline summary (name, use case, providers) and ask:

"What would you like to update?"
1. **MCP providers** — Change CRM, email, enrichment, or other provider connections
2. **Pipeline content** — Update profile, messaging guidelines, goals, or strategy
3. **Database schema** — Recreate or migrate the activities table
4. **Use case / template** — Switch to a different pipeline type (warning: this may overwrite custom content)
5. **Pipeline stages** — Re-import stages from CRM or manually edit the stage list in pipeline-config.md

### Execute the Selected Update

#### Option 1: MCP Providers
- First, run MCP detection (same as Step 4b): call `ListMcpResourcesTool` and scan tool names to discover all connected MCPs
- Show current provider values from `pipeline-config.md` alongside detected MCPs. If any newly detected MCP could be relevant to an existing provider, mention it as a suggestion: "I can see you now have [MCP] connected — would you like to use it for [role]?"
- Ask which specific providers to change — user decides
- Update only the selected `{{VARIABLE}}` entries in `pipeline-config.md`
- After changes, run the connection test (same as Step 5c) for all modified providers
- Do NOT touch any other files

#### Option 2: Pipeline Content
- Execute `actions/update-content.md` — it will audit current workspace files and ask targeted questions to rebuild or refine content
- This covers: `profile/`, `goals.md`, `sequence-flow.md`, `messaging-guidelines/`, `lead_preferences/`

#### Option 3: Database Schema
- Show current table name from `pipeline-config.md`
- Ask if they want to:
  - Recreate the table (warning: this drops existing data)
  - Add columns or indexes (provide the ALTER TABLE statements)
- Execute the chosen SQL via `{{ACTIONS_DB}}`

If upgrading to v1.12.0+ (channel-agnostic activities), run this migration:
```sql
ALTER TABLE {{ACTIVITIES_TABLE}}
  DROP CONSTRAINT IF EXISTS {{ACTIVITIES_TABLE}}_activity_type_check;
```
Then add the `## Channels` section to `pipeline-config.md` with entries for each channel the user wants to use (email and linkedin as defaults). Existing `send_email` and `send_linkedin` activity data remains valid.

If upgrading to v1.13.0+ (command logging), run this migration:
```sql
CREATE TABLE IF NOT EXISTS {{LOGS_TABLE}} (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  action_name TEXT NOT NULL,
  action_type TEXT NOT NULL CHECK (action_type IN ('action', 'command')),
  status TEXT NOT NULL CHECK (status IN ('successful', 'failed', 'partial')),
  summary TEXT NOT NULL,
  lead_context JSONB DEFAULT '{}',
  error_detail TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_logs_action ON {{LOGS_TABLE}} (action_name);
CREATE INDEX IF NOT EXISTS idx_logs_status ON {{LOGS_TABLE}} (status);
CREATE INDEX IF NOT EXISTS idx_logs_created ON {{LOGS_TABLE}} (created_at DESC);
```

If upgrading to v1.8.0+ (confidence scoring), run this migration:
```sql
ALTER TABLE {{ACTIVITIES_TABLE}}
  ADD COLUMN IF NOT EXISTS confidence_score INTEGER CHECK (confidence_score >= 0 AND confidence_score <= 100),
  ADD COLUMN IF NOT EXISTS scoring_breakdown JSONB NOT NULL DEFAULT '{}';
```

#### Option 5: Pipeline Stages
- Re-run the CRM stage import from Step 5a:
  1. Query CRM for current status field values
  2. Present discovered stages and compare with current `pipeline-config.md` → `## Pipeline Stages`
  3. Update stages and transition rules in `pipeline-config.md`
  4. Validate that `sequence-flow.md` references still use valid stage names

#### Option 4: Use Case / Template
- Warn: "Switching use cases will overwrite template files (profile, messaging guidelines, sequence flow, lead preferences). Your pipeline-config.md and database will be preserved. Custom changes to overwritten files will be lost."
- If confirmed: copy new template files, preserve `pipeline-config.md`
- Recommend running "Pipeline content" update afterward to personalize the new template

### Confirm Update

Print a summary of what was changed:
```
Updated pipeline: [name] at [path]
Changes: [list of what was modified]

Your pipeline is ready. Run /followup to continue working.
```

## Final: Log

Log a summary of this entire execution using `actions/add-log.md`.
