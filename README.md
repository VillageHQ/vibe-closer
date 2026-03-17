# vibe-closer

Pipeline management plugin for Claude Code. Manages end-to-end pipelines for **Sales**, **Hiring**, **Fundraising**, **BD/Partnerships**, **Job Search**, and **VC Deal Flow** — lead tracking, personalized outreach, follow-ups, and self-improving workflows.

## Quick Start

1. Install as a Claude Code plugin
2. Run `/onboard` to create a pipeline workspace
3. Run `/discover-leads` to find new prospects
4. Run `/followup` to draft outreach for due leads
5. Run `/view-pending-activity` to review and approve drafts
6. Run `/execute-approved-activity` to send approved outreach
7. Run `/learn` to improve over time

## Commands

| Command | Description |
|---------|-------------|
| `/onboard` | Create a new pipeline workspace or update an existing one. Walks through use case selection, tool connections, database setup, content generation, and automation setup. |
| `/followup` | Process all due leads — gathers context, drafts personalized outreach, and presents for approval. Handles regeneration requests from prior feedback. |
| `/discover-leads` | Find new leads from email, meetings, and conversations. Deduplicates against existing CRM records before adding. |
| `/learn` | Analyze pipeline performance (edit patterns, feedback, reply rates) and update workspace files — messaging guidelines, profile, tone, and workflow rules. |
| `/poll-new-activity` | Check for new email replies, match them to sent activities via fingerprinting, update leads, and trigger follow-up cycles. |
| `/execute-approved-activity` | Execute all approved, due activities — sends outreach, updates CRM, adds new leads. Recovers stale activities stuck in execution. |
| `/view-pending-activity` | View pending activities in a browser-based viewer or chat fallback. Filter, approve, edit, add notes, reject, snooze, or remove from sequence. |
| `/view-logs` | View command execution logs with filtering (today, failed, limit). |
| `/re-index` | Re-index workspace files to keep CLAUDE.md and AGENTS.md in sync with the filesystem. |
| `/test` | Run end-to-end integration test of the full pipeline flow — onboard, followup, discover, execute, with DB/CRM checkpoint validation. |

## Core Workflow

```
Discover leads → Gather context → Draft outreach → Score confidence
    → Human review (approve / edit / add note / reject)
    → Execute approved activities → Poll for replies → Follow up
    → Learn from edits and outcomes → Improve workspace files
```

Every outreach activity goes through a **draft → review → approve → execute** loop. Activities are scored on 5 dimensions (personalization, ICP match, tone, channel fit, CTA clarity) with a 0–100 confidence score. High-confidence activities can be auto-approved based on a configurable threshold.

## Use Cases

Each use case has a dedicated workspace template with tailored content:

| Use Case | Template Contents |
|----------|-------------------|
| **Sales** | ICP definitions, email/LinkedIn templates, sequence flow, scheduling links, lead discovery rules |
| **Hiring** | Company brief, candidate ICPs, recruiting message templates, sequence flow |
| **Fundraising** | Company brief, investor ICPs, fundraising outreach templates, sequence flow |
| **BD / Partnerships** | Company brief, ideal partner profiles, partnership outreach templates, sequence flow |
| **Job Search** | Candidate brief, target company profiles, job search outreach templates, sequence flow |
| **VC Deal Flow** | Fund brief, startup ICPs, deal sourcing templates, sequence flow |

All templates include: goals, messaging guidelines (tone, email guidelines, LinkedIn DM guidelines), lead/partner preferences (discovery rules, research instructions), and progress tracking directories (learnings, performance reports).

## Actions

Actions are the granular operations that power commands. Each action follows a step-by-step instruction file.

| Action | Description |
|--------|-------------|
| **Get leads** | Fetch due leads (by follow-up date) or all leads from CRM |
| **Add/update leads** | Add, update, or remove leads in CRM with full field support |
| **Gather context** | Aggregate lead info from CRM, email, LinkedIn, meetings, network, and website crawling. Identifies warm introduction paths. |
| **Generate activity** | Draft outreach following workflow rules, messaging guidelines, and personalization. Embeds fingerprint for reply tracking. Includes skip detection (manual outreach, prospect delay, pending next steps, workflow pause). |
| **Update activity** | Edit a pending activity's body with version history tracking |
| **Approve activity** | Human-in-the-loop approval — single or bulk. Flags low-confidence activities. |
| **Score activity** | Evaluate quality across 5 dimensions (20 pts each): personalization, ICP match, tone, channel fit, CTA clarity |
| **Add note** | Attach user feedback to a pending activity and flag it for regeneration on next `/followup` |
| **Evaluate performance** | Measure pipeline metrics (conversion rates, reply rates, edit/rejection rates) against goals |
| **Update content** | Rebuild workspace content through expert discovery conversation — replaces all placeholder content with specific, grounded content |
| **Sync with skill** | Re-sync workspace artifacts (activity viewer, templates) from the skill source |
| **View pending activity** | Display pending activities in browser viewer or chat with filtering and per-activity actions |
| **Poll new activity** | Detect email replies via fingerprint matching or domain/sender heuristics, update leads accordingly |
| **Add log** | Record command execution results (status, summary, errors) to the logs table |

## Key Features

### Multi-Channel Outreach
Supports email, LinkedIn, and custom channels. Each channel is configured in `pipeline-config.md` with its own provider, guidelines, templates, body schema, fingerprint method, and execution instructions.

### Lead Context Aggregation
Pulls from 6 sources before drafting outreach:
- CRM records (stage, notes, history)
- Email history (prior conversations)
- Profile enrichment (role, seniority, recent activity)
- Website crawling (company intelligence)
- Meeting transcripts (prior call context)
- Relationship graph (warm paths, mutual connections)

### Confidence Scoring
Every activity is scored 0–100 across 5 dimensions (20 points each):
- **Personalization quality** — specific references to the lead's context
- **ICP match** — alignment with ideal customer/candidate profile
- **On-tone** — adherence to messaging guidelines
- **Channel appropriateness** — right channel for the message type
- **CTA clarity** — clear, actionable next step

### Human-in-the-Loop Approval
All outreach goes through review before sending. Activities can be approved, edited (with version history), annotated with notes (triggering regeneration), rejected, snoozed, or removed from sequence.

### Browser-Based Activity Viewer
Interactive HTML viewer with real-time Supabase integration for reviewing pending activities. Supports bulk operations, filtering by type/date/company/confidence, and per-activity actions.

### Self-Improving Workflows
`/learn` analyzes patterns from user edits, rejection reasons, reply rates, and feedback notes. It proposes updates to messaging guidelines, tone, profile, ICPs, and workflow rules — then applies approved changes to workspace files.

### Reply Detection
Sent activities are fingerprinted (UUID v4 embedded per channel's method). `/poll-new-activity` matches incoming replies by fingerprint or domain/sender heuristics, updates lead follow-up dates, and triggers the next follow-up cycle.

### Skip Detection
Before generating outreach, checks whether the lead should be skipped: recent manual outreach detected, prospect requested a delay, pending next steps exist, or workflow is paused.

### Stale Activity Recovery
`/execute-approved-activity` detects activities stuck in `execution_status = 'running'` for over 30 minutes and recovers them.

## Workspace Structure

After onboarding, a pipeline workspace looks like:

```
my-pipeline/
  pipeline-config.md          # Central config: providers, channels, stages, settings
  CLAUDE.md                   # Workspace index (auto-maintained by /re-index)
  AGENTS.md                   # Mirror of CLAUDE.md for non-Claude tools
  goals.md                    # Pipeline goals and targets
  sequence-flow.md            # Multi-step outreach sequence definition
  profile/
    company-brief.md          # Your company/fund/candidate description
    icps.md                   # Ideal customer/candidate/investor profiles
    scheduling-links.md       # Booking links for meetings
  messaging-guidelines/
    tone.md                   # Voice and tone rules
    email-templates.md        # Email outreach templates
    email-guidelines.md       # Email-specific rules
    linkedin-dm-guidelines.md # LinkedIn message rules
  lead_preferences/
    lead-discovery.md         # Where and how to find leads
    research-lead.md          # How to research a new lead
  progress/
    learnings/                # Timestamped learning reports from /learn
    performance/              # Performance evaluation reports
```

## Requirements

### Required MCP Connections
- **CRM** (e.g., Attio) — lead tracking, pipeline stages, field updates
- **Email** (e.g., Gmail) — inbox polling, message sending
- **Database** (e.g., Supabase) — activity tracking, execution logs, polling cursors

### Optional MCP Connections
- **Network/Relationships** (e.g., Village) — warm path detection, mutual connections
- **Meeting Transcripts** (e.g., Fathom, Granola) — prior call context
- **Profile Enrichment** (e.g., LinkedIn via browser automation) — role, seniority, recent activity
- **Browser Automation** — website crawling, manual outreach execution

## Plugin Structure

```
.claude-plugin/plugin.json              # Plugin manifest (name, version, author)
commands/                               # Thin wrappers for plugin slash command discovery
skills/vibe-closer/
  SKILL.md                              # Main skill: intent routing + execution
  commands/                             # Canonical command logic (10 commands)
  actions/                              # Action instruction files (14 actions)
  workspace-templates/                  # Per-use-case templates (6 templates)
  evaluations/                          # Quality eval test suite (8 evaluations)
  views/                                # HTML templates (activity-viewer.html)
```

Root `commands/` contains thin wrappers that delegate to `skills/vibe-closer/commands/` — required because plugin slash command discovery only checks the plugin root.

## Evaluations

The plugin includes 8 evaluation categories in `skills/vibe-closer/evaluations/`:

| Evaluation | Coverage |
|------------|----------|
| Workflow Routing | Intent routing to correct actions |
| Outreach Quality | Personalization, tone, template adherence |
| Onboarding Flow | Workspace creation, provider config, DB setup |
| Learning Loop | Pattern detection, workspace updates, learnings capture |
| Context Gathering | Lead context aggregation from all sources |
| Poll New Activity | Email polling, fingerprint matching, reply detection |
| Add Note & Regenerate | Feedback capture, regeneration flagging |
| Update Content | Content audit, discovery conversation, placeholder replacement |

Run evaluations with `skills/vibe-closer/evaluations/run-evals.sh`.

## Version

Current version: **1.22.2**
