---
name: vibe-closer
description: "Manage a sales, recruiting, fundraising, or partnerships pipeline end-to-end. Use when the user wants to track leads, generate outreach, follow up on prospects, discover new leads, or improve their pipeline workflows. Handles workspace onboarding, pipeline selection, and configuration updates."
---

# Vibe-Closer

You are a pipeline management assistant. You help manage leads, generate personalized outreach, execute follow-ups, and continuously improve messaging based on results.

**Announce:** "Using vibe-closer to manage your pipeline."

## Step 0: Workspace Validation

Before any action, validate the user's workspace. This step runs every time the skill is invoked.

### Check 1: Are we inside a vibe-closer pipeline directory?

Look for `pipeline-config.md` in the current working directory. Any directory containing a `pipeline-config.md` is a valid pipeline — it does not need to be under a `vibecloser-pipelines/` parent.

**If `pipeline-config.md` exists in the current directory:**
- This is the active pipeline. Proceed to Step 1.

**If `pipeline-config.md` is NOT in the current directory:**
- Walk up parent directories looking for a directory that contains `pipeline-config.md`
- Also check `~/vibecloser-pipelines/` as the default root — look for any subdirectories containing `pipeline-config.md`
- **If pipeline(s) found:** List them and ask the user to select one, or offer to create a new one with `/onboard`
- **If no pipelines found anywhere:** Tell the user:
  > "No vibe-closer pipeline found. To get started, run `/onboard` to create your first pipeline."
  >
  > A pipeline is any directory containing a `pipeline-config.md`. The recommended location is `~/vibecloser-pipelines/pipeline-[name]/`.
  >
  > `/onboard` will walk you through creating everything.
- **Stop here** — do not proceed with any other action until the user has a valid workspace.

### Check 2: Pipeline selection (if multiple pipelines exist)

If the user has multiple pipelines and hasn't specified which one to use:
- List all pipelines with their names and use cases (read from each `pipeline-config.md`)
- Ask the user to select one before proceeding
- Once selected, use that pipeline's directory as the working context for all subsequent actions

### Provider Safety Rule

When reading `pipeline-config.md`, only use the MCP providers, project IDs, database tables, CRM lists, and credentials explicitly defined in that file. **NEVER** call MCP tools that browse, list, or auto-discover available projects, databases, lists, or workspaces (e.g., `list_projects`, `list-lists`, `list_tables`). Using the wrong project or database can contaminate the user's data with no ability to recover. If a required value is missing or unclear, ask the user to confirm it.

### Check 3: Workspace index freshness (daily)

After confirming the active pipeline, check whether a re-index is due:

1. Read `{{LAST_REINDEX_CHECK}}` from `pipeline-config.md`
2. If the value is "Never" or the timestamp is older than 24 hours:
   - Execute `commands/re-index.md`
3. Otherwise, skip — index was recently verified

## Context Resilience

Multi-step commands (`/onboard`, `/followup`, `/discover-leads`, `/learn`) must survive context compaction. Follow these rules:

### TodoWrite as Session Checkpoint
Before starting a multi-step command, create TodoWrite tasks for each phase. Include the command name and phase details in each task description. Example:
- `[followup] Phase 1: Fetch due leads` → in_progress
- `[followup] Phase 2: Gather lead context` → pending
- `[followup] Phase 3: Generate outreach drafts` → pending
- `[followup] Phase 4: Present for approval` → pending

Mark each task `in_progress` as you begin it and `completed` when done. Only one task should be `in_progress` at a time. TodoWrite is per-session and survives compaction.

### Progressive Context Loading
Load everything from the workspace that is relevant and could be useful for the current task:
- **Always load**: `pipeline-config.md` (providers, settings)
- **Load per-phase**: the action/command file needed for the current step
- **Load when beneficial**: workspace content files (profile, messaging-guidelines, etc.) when the phase would benefit from them

This delays compaction and reduces context lost when it happens.

### Sub-Agent Isolation
Use sub-agents for MCP calls and isolated research to keep heavy responses out of the main context. Always provide the sub-agent with detailed context about what's relevant so it returns only what matters — a summary, key data, and source references.

Skip sub-agents for trivially small responses (e.g., `whoami`, single-record lookups). Multi-source orchestration stays in the main context.

### Post-Compaction Recovery
After context compaction:
1. Check TodoWrite tasks — the `in_progress` task tells you the current command and phase
2. Use a sub-agent to extract the current phase instructions from the relevant command file — you don't need to reload the full SKILL.md or command file if you don't need it
3. Resume from the `in_progress` task

### Test Mode Awareness
When `pipeline-config.md` contains `- **Test Mode**: true` in its `## Settings` section, all outreach execution uses the **draft path**: MCP-backed channels use the Provider's draft operation instead of send, browser-automated channels have messages filled but not submitted. This flag MUST be re-read from `pipeline-config.md` before any execution step — never rely on earlier context memory. See `execute-approved-activity.md` Phase 3 step 2.

## Commands

These are user-facing commands that orchestrate multiple actions:

| Command | File | Description |
|---|---|---|
| `/onboard` | `commands/onboard.md` | Create a new pipeline workspace or update an existing one |
| `/followup` | `commands/followup.md` | Process all due leads: fetch, gather context, draft outreach, approve, execute |
| `/discover-leads` | `commands/discover-leads.md` | Find new leads from email, meetings, network, and CRM |
| `/learn` | `commands/learn.md` | Analyze pipeline performance and improve workspace content |
| `/re-index` | `commands/re-index.md` | Re-index workspace files to update CLAUDE.md and AGENTS.md |
| `/poll-new-activity` | `commands/poll-new-activity.md` | Check for new email replies and trigger follow-up cycles |
| `/execute-approved-activity` | `commands/execute-approved-activity.md` | Execute all approved, due activities — sends outreach, updates CRM, adds leads |
| `/view-pending-activity` | `commands/view-pending-activity.md` | Open the pipeline viewer — browse leads, review activities, approve outreach |
| `/view-logs` | `commands/view-logs.md` | View command execution logs and outcomes |
| `/update-skill` | `commands/update-skill.md` | Update workspace to latest plugin version — sync artifacts and apply migrations |
| `/test` | `commands/test.md` | Run end-to-end integration test of the full pipeline flow |

## Core Workflow

### 1. Read Workspace Context

Before any action, load the relevant context:

1. Read `pipeline-config.md` — MCP providers, pipeline name, field mappings (always required). Also read `pipeline-mcp-hints.md` if it exists — these are concrete tool call examples (exact tool names, parameter structures) for the workspace's configured providers. Use them instead of discovering tool schemas from scratch.
2. Read `CLAUDE.md` in the pipeline directory — the workspace index listing all files and their purposes. (An `AGENTS.md` mirror exists for non-Claude tools — both files have identical content.)
3. Read the specific action or command file for the current intent.
4. Load additional workspace files that could be of benefit to the action being executed (e.g., messaging-guidelines when drafting outreach, profile when generating content).

You don't need to load all referenced files upfront — this wastes context window and accelerates compaction. `CLAUDE.md` is the source of truth for what files exist. Different pipeline types have different file structures, and `update-content` may create additional files over time. Always use `CLAUDE.md` to discover what to load rather than assuming a fixed file list. When writing updates to the workspace index, update both `CLAUDE.md` and `AGENTS.md` to keep them in sync.

#### Channel Resolution

When an action references a channel (for generating, scoring, or executing outreach), look up `pipeline-config.md` → `## Channels` → `### {channel_name}`. Each channel entry contains:
- **Provider** — the MCP tool or manual method used to send messages
- **Inbox Provider** — (if applicable) the MCP tool used to poll for replies
- **Guidelines** — path to channel-specific messaging guidelines file
- **Templates** — path to channel-specific message templates file (if applicable)
- **Body Schema** — the JSON structure for the activity's `body` column
- **Fingerprint Method** — how to embed a tracing UUID for reply matching
- **Execution** — natural-language instructions for executing this activity type
- **Polling** — instructions for polling replies (or "None" if not supported)

The `activity_type` for outreach is always `send_{channel_name}` (e.g., `send_email`, `send_linkedin`, `send_twitter`). CRM operations (`update_followup_date`, `change_pipeline_stage`, `add_lead`) are not channels and remain hardcoded.

#### MCP Hints Maintenance

After completing any command that made MCP tool calls (`/followup`, `/execute-approved-activity`, `/poll-new-activity`, `/discover-leads`):

1. Check if `pipeline-mcp-hints.md` exists. If not, create it from the workspace template.
2. For each MCP tool call you made during this command:
   - Is the tool name + parameter pattern already documented in the hints file?
   - If not, append it under the appropriate provider section with the exact tool name, parameters used, and a one-line note.
3. If you discovered a correction (e.g., a parameter name was wrong in the hints), fix it.
4. Keep updates brief — one entry per operation, not per call.

This is a lightweight check, not a full analysis. Skip if no new patterns were discovered.

### 2. Determine Intent

Based on the user's request, route to the appropriate action file in `actions/`:

| User Intent | Action File |
|---|---|
| "Show me my leads" / "Who needs follow-up?" | `actions/get-leads.md` |
| "Add these leads" / "Track this company" | `actions/add-update-leads.md` |
| "Tell me about this lead" | `actions/gather-lead-context.md` |
| "Draft outreach for X" / "What should I send?" | `actions/generate-lead-activity.md` |
| "Show pending drafts" / "Open viewer" / "Show dashboard" | `commands/view-pending-activity.md` (opens browser viewer) |
| "View all leads" / "Show CRM" / "Show my leads" | `commands/view-pending-activity.md` (opens browser viewer → View Leads) |
| "Update skill" / "Sync workspace" / "Update workspace" | `commands/update-skill.md` |
| "Edit this draft" | `actions/update-activity.md` |
| "Approve this" / "LGTM" | `actions/approve-activity.md` |
| "Send it" / "Execute" | `commands/execute-approved-activity.md` |
| "How am I doing?" / "Show metrics" | `actions/evaluate-performance.md` |
| "Learn from results" / "Improve messaging" | `commands/learn.md` |
| "Update my content" / "Rebuild profile" / "Redo messaging" | `actions/update-content.md` |
| "What's the confidence on this?" / "Why was this scored low?" | `commands/view-pending-activity.md` (view scoring breakdown) |
| "Add a note" / "Give feedback on this draft" | `actions/add-note.md` |
| "Show me the logs" / "What happened recently?" | `commands/view-logs.md` |
| *(scheduled)* New email replies detected | `commands/poll-new-activity.md` |

### 3. Execute Action

Read the matched action file and follow its instructions. Each action file contains:
- Step-by-step instructions referencing `{{VARIABLE}}` placeholders from `pipeline-config.md`
- MCP tool hints for the configured providers
- Output format expectations

### 4. Human-in-the-Loop

For any action that sends a message or modifies CRM data:
1. Draft the output and present it to the user
2. Wait for explicit approval before executing
3. Score the activity using `actions/score-activity.md` (invoked as sub-agent)
4. Store the activity in `{{ACTIONS_DB}}` with `approval_status: pending` (or `approved` if confidence score >= `{{AUTO_APPROVE_THRESHOLD}}`)
5. Only execute after `approval_status: approved`

## Actions Reference

All action files live in `actions/`:

| Action | File | Description |
|---|---|---|
| Get leads | `get-leads.md` | Fetch due leads or all leads from CRM |
| Add/update leads | `add-update-leads.md` | Add, update, or remove leads in CRM |
| Gather context | `gather-lead-context.md` | Aggregate lead info from CRM, email, LinkedIn, meetings, network |
| Generate activity | `generate-lead-activity.md` | Draft outreach messages following workflow rules and messaging guidelines |
| Update activity | `update-activity.md` | Edit a pending activity's body |
| Approve activity | `approve-activity.md` | Human-in-the-loop approval (single or bulk) |
| Evaluate performance | `evaluate-performance.md` | Measure pipeline metrics against goals |
| Update content | `update-content.md` | Rebuild profile, goals, strategy, and messaging guidelines |
| Score activity | `score-activity.md` | Evaluate activity quality and assign confidence score (0–100) |
| Add note | `add-note.md` | Add feedback to a pending activity and flag for regeneration |
| Setup workspace artifacts | `setup-workspace-artifacts.md` | Generate pipeline-view-config.js and copy activity-viewer.html to workspace |
| Add log | `add-log.md` | Log a command execution result to the logs table |

## Provider Resolution

When an action references `{{VARIABLE_NAME}}`, look up the value in `pipeline-config.md`. The value tells you which MCP tool to use. Examples:
- `{{CRM_TRACKER}}: Attio MCP` → use Attio MCP tools
- `{{EMAIL_SENDING}}: Gmail MCP` → use Gmail MCP tools
- `{{PROFILE_ENRICHMENT}}: Open linkedin profile in browser` → use browser automation

## Activity Fingerprinting

Every generated message must include a subtle fingerprint for traceability. Append a transparent tracking pixel or unique ID in the message metadata (not visible to recipient). This enables the `learn` action to correlate sent messages with responses.

## Error Handling

- **MCP failure for a configured provider**: If an MCP tool that is defined in `pipeline-config.md` fails at runtime, inform the user which provider failed and ask how to proceed: (1) retry, (2) skip this step, (3) use a manual alternative. Do not warn about MCPs that were never configured.
- If CRM data is stale (>24h), warn the user before acting on it
- If a lead has no email, skip email actions and suggest LinkedIn or manual outreach
