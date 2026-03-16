# vibe-closer Plugin

## Architecture
- This is a Claude Code **plugin** that wraps a self-contained **skill** at `skills/vibe-closer/`
- All capabilities live inside the skill folder (SKILL.md, commands/, actions/, workspace-templates/, evaluations/)
- Root `commands/` contains thin wrappers that delegate to `skills/vibe-closer/commands/` — required because plugin slash command discovery only checks the plugin root
- Claude Code plugin discovery does NOT follow symlinks (`lstatSync` is used)

## Version Bumping
- When making changes to any file within the plugin, bump the `version` in `.claude-plugin/plugin.json` (semver: patch for fixes, minor for features, major for breaking changes)

## Workspace Template Index Files (CLAUDE.md + AGENTS.md)
- Each directory under `skills/vibe-closer/workspace-templates/` has both a `CLAUDE.md` and an `AGENTS.md` with quick reference links and commands
- `AGENTS.md` mirrors `CLAUDE.md` content — it is the cross-platform standard read by Codex, Copilot, Zed, Cursor, and other AI coding tools
- When modifying files in a workspace-template directory, update **both** `CLAUDE.md` and `AGENTS.md` to reflect the changes

## Key Files
- `.claude-plugin/plugin.json` — plugin manifest (name, version, description)
- `skills/vibe-closer/SKILL.md` — main skill: intent routing, workspace validation, provider resolution
- `skills/vibe-closer/commands/` — canonical command logic (onboard, followup, discover-leads, learn)
- `skills/vibe-closer/actions/` — 14 action files referenced by SKILL.md routing table
- `commands/` — thin wrappers for plugin discovery (mirror frontmatter, delegate to skill)
- `FUTURE-PLANS.md` — living record of planned improvements, gaps, and future work

## Future Plans
- `FUTURE-PLANS.md` tracks planned improvements, known gaps, and deferred work
- When building new features or modifying existing ones, consult FUTURE-PLANS.md to check for related planned work, avoid conflicts, and update entries as they're completed
