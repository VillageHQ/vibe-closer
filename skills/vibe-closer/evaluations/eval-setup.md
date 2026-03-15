# Eval: Setup Flow

Test that workspace setup works end-to-end.

## Test Cases

### TC-1: Default location
**Input**: User accepts default location
**Pass if**: Workspace created at `~/.vibe-closer/`

### TC-2: Custom location
**Input**: User specifies `~/my-pipeline/`
**Pass if**: Workspace created at specified path

### TC-3: Template selection
**Input**: User selects "Sales"
**Pass if**: Sales template files copied (not Hiring or Fundraising)

### TC-4: Config variables
**Input**: User provides CRM = "Attio MCP", Email = "Gmail MCP"
**Pass if**: All `{{VARIABLE}}` placeholders in config.md updated to `{{VARIABLE : value}}`

### TC-5: Database creation
**Input**: Supabase MCP available
**Pass if**: SQL executed matching schema from references/db-schema.md with correct table name

### TC-6: Missing required MCP
**Input**: User has no CRM MCP configured
**Pass if**: Setup warns user and does NOT proceed without required providers

### TC-7: Idempotent setup
**Input**: Run setup twice on same location
**Pass if**: Does NOT overwrite existing customized files, asks user what to do
