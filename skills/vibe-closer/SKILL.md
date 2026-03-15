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

Look for `config.md` in the current working directory. A valid pipeline directory lives at `*/vibe-closer/pipeline-*/` and contains a `config.md`.

**If `config.md` exists in the current directory:**
- This is the active pipeline. Proceed to Step 1.

**If the current directory is inside a `vibe-closer/` folder but has no `config.md`:**
- Tell the user: "This directory is inside a vibe-closer workspace but doesn't have a configured pipeline. Would you like to:"
  1. "Run `/onboard` to create a new pipeline here"
  2. "Switch to an existing pipeline" — list any sibling `pipeline-*/` directories that do have `config.md`

**If the current directory is NOT inside a vibe-closer directory at all:**
- Check if `~/vibe-closer/` exists and contains any `pipeline-*/config.md` directories
- **If pipelines exist:** List them and ask the user to select one, or offer to create a new one with `/onboard`
- **If no pipelines exist anywhere:** Tell the user:
  > "No vibe-closer workspace found. To get started, run `/onboard` to create your first pipeline."
  >
  > A vibe-closer workspace requires:
  > - A root `vibe-closer/` directory (recommended: `~/vibe-closer/`)
  > - At least one pipeline inside it (`pipeline-[name]/`) with a `config.md`
  >
  > `/onboard` will walk you through creating everything.
- **Stop here** — do not proceed with any other action until the user has a valid workspace.

### Check 2: Pipeline selection (if multiple pipelines exist)

If the user has multiple pipelines under their `vibe-closer/` root and hasn't specified which one to use:
- List all pipelines with their names and use cases (read from each `config.md`)
- Ask the user to select one before proceeding
- Once selected, use that pipeline's directory as the working context for all subsequent actions

### Check 3: Workspace index freshness (daily)

After confirming the active pipeline, check whether a re-index is due:

1. Read `{{LAST_REINDEX_CHECK}}` from `config.md`
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
- **Always load**: `config.md` (providers, settings)
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
| `/execute-actions` | `commands/execute-actions.md` | Execute all approved activities (send emails, update CRM, etc.) |
| `/view-pending-activity` | `commands/view-pending-activity.md` | View pending activities awaiting approval |

## Core Workflow

### 1. Read Workspace Context

Before any action, load the relevant context:

1. Read `config.md` — MCP providers, pipeline name, field mappings (always required).
2. Read `CLAUDE.md` in the pipeline directory — the workspace index listing all files and their purposes. (An `AGENTS.md` mirror exists for non-Claude tools — both files have identical content.)
3. Read the specific action or command file for the current intent.
4. Load additional workspace files that could be of benefit to the action being executed (e.g., messaging-guidelines when drafting outreach, profile when generating content).

You don't need to load all referenced files upfront — this wastes context window and accelerates compaction. `CLAUDE.md` is the source of truth for what files exist. Different pipeline types have different file structures, and `update-content` may create additional files over time. Always use `CLAUDE.md` to discover what to load rather than assuming a fixed file list. When writing updates to the workspace index, update both `CLAUDE.md` and `AGENTS.md` to keep them in sync.

### 2. Determine Intent

Based on the user's request, route to the appropriate action file in `actions/`:

| User Intent | Action File |
|---|---|
| "Show me my leads" / "Who needs follow-up?" | `actions/get-leads.md` |
| "Add these leads" / "Track this company" | `actions/add-leads.md` |
| "Tell me about this lead" | `actions/gather-lead-context.md` |
| "Draft outreach for X" / "What should I send?" | `actions/generate-lead-activity.md` |
| "Show pending drafts" | `commands/view-pending-activity.md` |
| "Edit this draft" | `actions/update-activity.md` |
| "Approve this" / "LGTM" | `actions/approve-activity.md` |
| "Send it" / "Execute" | `commands/execute-actions.md` |
| "How am I doing?" / "Show metrics" | `actions/evaluate-performance.md` |
| "Learn from results" / "Improve messaging" | `commands/learn.md` |
| "Update my content" / "Rebuild profile" / "Redo messaging" | `actions/update-content.md` |
| "What's the confidence on this?" / "Why was this scored low?" | `commands/view-pending-activity.md` (view scoring breakdown) |
| "Add a note" / "Give feedback on this draft" | `actions/add-note.md` |
| *(scheduled)* New email replies detected | `commands/poll-new-activity.md` |

### 3. Execute Action

Read the matched action file and follow its instructions. Each action file contains:
- Step-by-step instructions referencing `{{VARIABLE}}` placeholders from `config.md`
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
| Add leads | `add-leads.md` | Add, update, or remove leads in CRM |
| Gather context | `gather-lead-context.md` | Aggregate lead info from CRM, email, LinkedIn, meetings, network |
| Generate activity | `generate-lead-activity.md` | Draft outreach following workflow rules and messaging guidelines |
| Update activity | `update-activity.md` | Edit a pending activity's body |
| Approve activity | `approve-activity.md` | Human-in-the-loop approval (single or bulk) |
| Evaluate performance | `evaluate-performance.md` | Measure pipeline metrics against goals |
| Update content | `update-content.md` | Rebuild profile, goals, strategy, and messaging guidelines |
| Score activity | `score-activity.md` | Evaluate activity quality and assign confidence score (0–100) |
| Add note | `add-note.md` | Add feedback to a pending activity and flag for regeneration |

## Provider Resolution

When an action references `{{VARIABLE_NAME}}`, look up the value in `config.md`. The value tells you which MCP tool to use. Examples:
- `{{CRM_TRACKER}}: Attio MCP` → use Attio MCP tools
- `{{EMAIL_SENDING}}: Gmail MCP` → use Gmail MCP tools
- `{{PROFILE_ENRICHMENT}}: Open linkedin profile in browser` → use browser automation

## Activity Fingerprinting

Every generated message must include a subtle fingerprint for traceability. Append a transparent tracking pixel or unique ID in the message metadata (not visible to recipient). This enables the `learn` action to correlate sent messages with responses.

## Error Handling

- **MCP failure for a configured provider**: If an MCP tool that is defined in `config.md` fails at runtime, inform the user which provider failed and ask how to proceed: (1) retry, (2) skip this step, (3) use a manual alternative. Do not warn about MCPs that were never configured.
- If CRM data is stale (>24h), warn the user before acting on it
- If a lead has no email, skip email actions and suggest LinkedIn or manual outreach
