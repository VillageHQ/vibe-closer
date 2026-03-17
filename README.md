# vibe-closer

**A fully autonomous pipeline manager that runs from lead discovery to closing deals — with a human-in-the-loop for approving outreach.**

vibe-closer is an LLM-first pipeline manager. It can be installed on **Claude Code** as a plugin, or imported as a **skill** on Claude, OpenAI, and other AI coding tools.

It manages end-to-end pipelines for Sales, Hiring, Fundraising, BD/Partnerships, Job Search, VC Deal Flow, and more — discovering leads, researching context, drafting personalized outreach, following up, and improving itself over time.

- 🌐 **Open-source**
- 🤝 **Full end-to-end pipeline management** — from lead discovery to deal close
- 🦸 **Easy onboarding** — zero to hero in under 5 minutes
- 📖 **Build world-class pipeline collateral** from scratch or from simple resources
- 🗃️ **System-of-record agnostic** — use any CRM (Attio, HubSpot, Salesforce, Notion, etc.)
- 💪 **Context awareness & intelligence** more capable than any other tool out there
- 👥 **Use-case agnostic** — inbound/outbound sales, job search, recruiting, VC/LP fundraising, deal flow, expert interviews, and more

## Install

### Claude Code Plugin

```bash
claude plugin add --git https://github.com/VillageHQ/vibe-closer
```

### Import as a Skill on Claude

Copy the contents of `skills/vibe-closer/SKILL.md` into your Claude project's custom instructions or system prompt.

### Import as a Skill on OpenAI (Codex, ChatGPT)

Copy the contents of `skills/vibe-closer/SKILL.md` into your project's system instructions. The skill references `AGENTS.md` (the cross-platform standard) which is compatible with Codex, Copilot, Cursor, Zed, and other AI coding tools.

## Quick Start

1. Run `/onboard` to create a pipeline workspace
2. That's it — everything else runs on autopilot

## How It Runs

Ideally, all commands run automatically on a schedule (via cron, Claude Code hooks, or any scheduler):

```
/discover-leads     →  finds new prospects from email, meetings, conversations
/followup           →  drafts personalized outreach for due leads
/poll-new-activity  →  detects replies and triggers next steps
/execute-approved-activity  →  sends approved outreach
/learn              →  improves messaging from edits, feedback, and outcomes
```

**The only thing you need to do is open the `activity-viewer.html` file in your workspace to approve pending activity.** Everything else — discovery, drafting, scoring, sending, reply detection, learning — runs autonomously.

## Onboarding

`/onboard` is a 5-minute guided conversation that builds your entire pipeline workspace. Here's how it goes:

```
vibe-closer:  What kind of pipeline are you building?
              (Sales / Hiring / Fundraising / BD / Job Search / VC Deal Flow)

you:          Sales

vibe-closer:  What's your company name, and where are you based?

you:          Acme Corp, San Francisco

vibe-closer:  Tell me about what you sell and who you sell to.
              Any links to your website, pitch deck, or docs are helpful.

you:          We sell developer tools to engineering teams at Series B+ startups.
              Here's our website: acme.dev

vibe-closer:  Got it. Let me pull context from your website...
              Now — what does a great customer look like for you?
              Think: title, company size, industry, pain points.

you:          VP Eng or CTO, 50-500 engineers, struggling with CI/CD speed.

vibe-closer:  What tone should outreach have? Casual, professional, technical?

you:          Technical but friendly. No buzzwords.

vibe-closer:  Perfect. I've built your workspace with:
              ✓ Company profile and ICP definitions
              ✓ Email and LinkedIn templates in your voice
              ✓ Outreach sequence (intro → follow-up → break-up)
              ✓ Lead discovery rules
              ✓ Goals and tracking
              Ready to find your first leads — run /discover-leads.
```

vibe-closer takes whatever you give it — a website URL, a pitch deck, rough notes, or just a conversation — and builds production-ready pipeline collateral: ICPs, messaging guidelines, outreach templates, sequence flows, and discovery rules. All stored as editable markdown files in your workspace.

## Commands

| Command | Description |
|---------|-------------|
| `/onboard` | Create a new pipeline workspace or update an existing one |
| `/followup` | Draft personalized outreach for all due leads |
| `/discover-leads` | Find new leads from email, meetings, and conversations |
| `/execute-approved-activity` | Send all approved outreach, update CRM |
| `/view-pending-activity` | Review pending activities in browser or chat |
| `/poll-new-activity` | Detect replies, update leads, trigger next follow-up |
| `/learn` | Improve workspace files from edit patterns and outcomes |
| `/view-logs` | View execution logs with filtering |
| `/re-index` | Sync workspace index files with filesystem |
| `/test` | Run end-to-end integration test of the full pipeline |

## Core Workflow

```
Discover leads → Gather context → Draft outreach → Score confidence
    → Human review (approve / edit / reject)
    → Execute approved activities → Poll for replies → Follow up
    → Learn from edits and outcomes → Improve workspace files
```

Every activity goes through a **draft → review → approve → execute** loop. Activities are scored 0–100 on personalization, ICP match, tone, channel fit, and CTA clarity. High-confidence activities can be auto-approved.

## Use Cases

| Use Case | What Gets Built |
|----------|-----------------|
| **Sales** | ICP definitions, email/LinkedIn templates, sequence flow, lead discovery rules |
| **Hiring** | Company brief, candidate ICPs, recruiting message templates |
| **Fundraising** | Company brief, investor ICPs, fundraising outreach templates |
| **BD / Partnerships** | Company brief, ideal partner profiles, partnership templates |
| **Job Search** | Candidate brief, target company profiles, job search templates |
| **VC Deal Flow** | Fund brief, startup ICPs, deal sourcing templates |

All templates include goals, messaging guidelines, lead preferences, and progress tracking.

## Key Features

### Multi-Channel Outreach
Email, LinkedIn, and custom channels — each configured with its own provider, templates, body schema, and fingerprint method.

### Lead Context Aggregation
Pulls from 6 sources before drafting: CRM records, email history, profile enrichment, website crawling, meeting transcripts, and relationship graph (warm paths and mutual connections).

### Confidence Scoring
Every activity is scored 0–100 across 5 dimensions (20 pts each): personalization quality, ICP match, on-tone, channel appropriateness, CTA clarity.

### Human-in-the-Loop Approval
All outreach is reviewed before sending. Approve, edit (with version history), add notes (triggers regeneration), reject, snooze, or remove from sequence.

### Browser-Based Activity Viewer
Interactive HTML viewer with real-time Supabase integration. Bulk operations, filtering by type/date/company/confidence, and per-activity actions.

### Self-Improving Workflows
`/learn` analyzes edit patterns, rejection reasons, reply rates, and feedback notes. Proposes and applies updates to messaging guidelines, tone, profile, ICPs, and workflow rules.

### Reply Detection & Fingerprinting
Sent activities are fingerprinted (UUID v4 per channel). `/poll-new-activity` matches replies by fingerprint or domain/sender heuristics, updates lead follow-up dates, and triggers the next cycle.

### Skip Detection
Before generating outreach, checks: recent manual outreach, prospect requested delay, pending next steps, or workflow paused.

## Actions

Actions are the granular operations that power commands:

| Action | Description |
|--------|-------------|
| Get leads | Fetch due leads or all leads from CRM |
| Add/update leads | Add, update, or remove leads in CRM |
| Gather context | Aggregate lead info from CRM, email, LinkedIn, meetings, network, website |
| Generate activity | Draft outreach with personalization, fingerprinting, and skip detection |
| Update activity | Edit a pending activity's body with version history |
| Approve activity | Human-in-the-loop approval — single or bulk |
| Score activity | Evaluate quality across 5 dimensions |
| Add note | Attach feedback to an activity, flag for regeneration |
| Evaluate performance | Measure pipeline metrics against goals |
| Update content | Rebuild workspace content through expert discovery conversation |
| Sync with skill | Re-sync workspace artifacts from skill source |
| View pending activity | Display activities in browser viewer or chat |
| Poll new activity | Detect email replies via fingerprint or heuristic matching |
| Add log | Record command execution results |

## Workspace Structure

After onboarding, your pipeline workspace:

```
my-pipeline/
  pipeline-config.md          # Central config: providers, channels, stages, settings
  activity-viewer.html        # Open in browser to approve pending activity
  CLAUDE.md                   # Workspace index (auto-maintained)
  AGENTS.md                   # Mirror for non-Claude tools
  goals.md                    # Pipeline goals and targets
  sequence-flow.md            # Multi-step outreach sequence
  profile/
    company-brief.md          # Your company/fund/candidate description
    icps.md                   # Ideal customer/candidate/investor profiles
    scheduling-links.md       # Booking links
  messaging-guidelines/
    tone.md                   # Voice and tone rules
    email-templates.md        # Email outreach templates
    email-guidelines.md       # Email-specific rules
    linkedin-dm-guidelines.md # LinkedIn message rules
  lead_preferences/
    lead-discovery.md         # Where and how to find leads
    research-lead.md          # How to research a new lead
  progress/
    learnings/                # Learning reports from /learn
    performance/              # Performance evaluation reports
```

## Requirements

### Required MCP Connections
- **CRM** (e.g., Attio, HubSpot, Notion) — lead tracking, pipeline stages, field updates
- **Email** (e.g., Gmail) — inbox polling, message sending
- **Database** (e.g., Supabase) — activity tracking, execution logs, polling cursors

### Optional MCP Connections
- **Network/Relationships** (e.g., Village) — warm path detection, mutual connections
- **Meeting Transcripts** (e.g., Fathom, Granola) — prior call context
- **Profile Enrichment** (e.g., LinkedIn via browser automation) — role, seniority, recent activity
- **Browser Automation** — website crawling, manual outreach execution

## Plugin Structure

```
.claude-plugin/plugin.json              # Plugin manifest
commands/                               # Thin wrappers for slash command discovery
skills/vibe-closer/
  SKILL.md                              # Main skill: intent routing + execution
  commands/                             # Canonical command logic (10 commands)
  actions/                              # Action instruction files (14 actions)
  workspace-templates/                  # Per-use-case templates (6 templates)
  evaluations/                          # Quality eval test suite (8 evaluations)
  views/                                # HTML templates (activity-viewer.html)
```

## Evaluations

8 evaluation categories in `skills/vibe-closer/evaluations/`:

| Evaluation | Coverage |
|------------|----------|
| Workflow Routing | Intent routing to correct actions |
| Outreach Quality | Personalization, tone, template adherence |
| Onboarding Flow | Workspace creation, provider config, DB setup |
| Learning Loop | Pattern detection, workspace updates |
| Context Gathering | Lead context aggregation from all sources |
| Poll New Activity | Fingerprint matching, reply detection |
| Add Note & Regenerate | Feedback capture, regeneration flagging |
| Update Content | Content audit, discovery conversation |

Run with `skills/vibe-closer/evaluations/run-evals.sh`.

## Version

Current version: **1.22.4**

## Contact

Questions? Reach us at [team@village.ai](mailto:team@village.ai).

## License

[Elastic License 2.0](LICENSE)
