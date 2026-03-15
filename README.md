# vibe-closer

Pipeline management skill for Claude Code. Manages sales, recruiting, fundraising, or partnerships pipelines end-to-end — lead tracking, personalized outreach, follow-ups, and self-improving workflows.

## Quick Start

1. Install as a Claude Code plugin
2. Run `/onboard` to create a workspace
3. Run `/followup` to process due leads
4. Run `/discover-leads` to find new prospects
5. Run `/learn` to improve over time

## Structure

```
.claude-plugin/plugin.json                      # Plugin manifest
commands/                                        # Thin wrappers (plugin slash command discovery)
skills/vibe-closer/
  SKILL.md                                       # Main skill (intent routing + execution)
  commands/                                      # Canonical command logic
  actions/                                       # Action instruction files
  workspace-templates/                           # Per-use-case templates (Sales, Hiring, etc.)
  evaluations/                                   # Quality eval test cases
```

## Requirements

- Claude Code with MCP connections
- CRM MCP (e.g., Attio) — required
- Email MCP (e.g., Gmail) — required
- Database MCP (e.g., Supabase) — for activity tracking
- Optional: Village MCP, Fathom/Granola, browser automation