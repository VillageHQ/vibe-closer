# vibe-closer Plugin

## Architecture
- This is a Claude Code **plugin** that wraps a self-contained **skill** at `skills/vibe-closer/`
- All capabilities live inside the skill folder (SKILL.md, commands/, actions/, workspace-templates/, evaluations/)
- Root `commands/` contains thin wrappers that delegate to `skills/vibe-closer/commands/` — required because plugin slash command discovery only checks the plugin root
- Claude Code plugin discovery does NOT follow symlinks (`lstatSync` is used)

## Version Bumping
- When making changes to any file within the plugin, bump the `version` in `.claude-plugin/plugin.json` (semver: patch for fixes, minor for features, major for breaking changes)

## Workspace Template CLAUDE.md
- Each directory under `skills/vibe-closer/workspace-templates/` has a `CLAUDE.md` with quick reference links and commands
- When modifying files in a workspace-template directory, update that template's `CLAUDE.md` to reflect the changes

## Key Files
- `.claude-plugin/plugin.json` — plugin manifest (name, version, description)
- `skills/vibe-closer/SKILL.md` — main skill: intent routing, workspace validation, provider resolution
- `skills/vibe-closer/commands/` — canonical command logic (setup, followup, discover-leads, learn)
- `skills/vibe-closer/actions/` — 12 action files referenced by SKILL.md routing table
- `commands/` — thin wrappers for plugin discovery (mirror frontmatter, delegate to skill)
