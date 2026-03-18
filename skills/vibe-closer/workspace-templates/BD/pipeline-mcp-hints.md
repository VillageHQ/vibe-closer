# MCP Hints

Concrete MCP tool call examples for this workspace. Loaded alongside pipeline-config.md.
When executing any MCP tool call, check here first for the exact tool name and parameters.

## CRM: {{CRM_TRACKER}}
<!-- Populated during onboard or after first use -->

## Email: {{email Provider}}
<!-- Populated during onboard or after first use -->

## Database: {{ACTIONS_DB}}
<!-- Populated during onboard — includes project_id and table names -->

## Meeting Notes: {{NOTETAKER}}
<!-- Populated during onboard or after first use -->

## Browser Automation: LinkedIn
- **Provider**: `claude-in-chrome` (`mcp__claude-in-chrome__*` tools)
- **Usage**: Navigate to LinkedIn profile URLs, detect connection status, send DMs or connection requests
- **Cooldown**: Wait 60–90 seconds between LinkedIn actions
<!-- Additional hints populated after first use -->
