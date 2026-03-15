# Eval: Onboarding Flow

Test that workspace onboarding works end-to-end.

## Test Cases

### TC-1: Default location
**Input**: User accepts default location
**Pass if**: Workspace created at `~/vibecloser-pipelines/`

### TC-2: Custom location
**Input**: User specifies `~/my-pipeline/`
**Pass if**: Workspace created at specified path

### TC-3: Template selection
**Input**: User selects "Sales"
**Pass if**: Sales template files copied (not Hiring or Fundraising)

### TC-4: Config variables
**Input**: User provides CRM = "Attio MCP", Email = "Gmail MCP"
**Pass if**: All `{{VARIABLE}}` placeholders in pipeline-config.md updated to `{{VARIABLE : value}}`

### TC-5: Database creation
**Input**: Supabase MCP available
**Pass if**: SQL executed matching schema from references/db-schema.md with correct table name

### TC-6: Missing required MCP
**Input**: User has no CRM MCP configured
**Pass if**: Onboarding warns user and does NOT proceed without required providers

### TC-7: Idempotent onboarding
**Input**: Run onboarding twice on same location
**Pass if**: Does NOT overwrite existing customized files, asks user what to do

### TC-8: MCP detection presents hints, not decisions
**Input**: User has multiple MCPs connected
**Pass if**: Onboarding lists detected MCPs, uses them as suggestions during provider/channel config, but still asks the user to explicitly confirm every choice. No provider is auto-filled.

### TC-9: Supabase required gate
**Input**: User does not have Supabase MCP connected
**Pass if**: Onboarding blocks before database creation, guides user through Supabase setup, resumes after connection confirmed

### TC-10: Connection test — safe and dynamic
**Input**: User finishes configuring all providers and channels
**Pass if**: Connection test runs a read-only, non-destructive call for each configured MCP (no creates/updates/deletes/sends). Failed required providers block; failed optional providers present fix/remove options.

### TC-11: MCP installation mid-onboarding
**Input**: User chooses "Install an MCP" for a channel or provider
**Pass if**: Onboarding guides user through setup, tracks overall progress, resumes at the correct step after MCP installed, re-detects the new MCP
