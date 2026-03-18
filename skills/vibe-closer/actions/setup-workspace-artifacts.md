# Setup Workspace Artifacts

Generate and copy workspace artifacts that the pipeline viewer depends on. This action is shared by `/onboard` (initial setup) and `/update-skill` (migrations).

## Prerequisites

- `pipeline-config.md` must exist and be fully configured (CRM, Supabase, stages)
- MCP providers must be accessible

## Step 1: Ensure `.config/` directory

Create `{WORKSPACE_DIR}/.config/` if it does not exist.

## Step 2: Generate `pipeline-view-config.js`

This file is generated from scratch — NOT token-replaced from a template. It contains all the config the HTML pipeline viewer needs to talk to Supabase and the CRM.

### 2a. Resolve Supabase credentials

Via `{{ACTIONS_DB}}` provider (Supabase MCP):
- Call `get_project_url` → Supabase URL (e.g., `https://xxx.supabase.co`)
- Call `get_publishable_keys` → anon key

### 2b. Resolve CRM credentials and API details

Read `pipeline-config.md` → `## CRM Tracker` section to determine:
- Provider name (e.g., "Attio MCP")
- Lead list query (e.g., `list sales_3, parent object: companies`)
- Follow-up date field name
- Status/stage field name
- Notes field name
- Parent object type

Based on the CRM provider, resolve:
- **API base URL** (e.g., `https://api.attio.com` for Attio)
- **API key** — attempt to read from MCP connection config. If not available, ask the user to provide it.
- **Auth header** — pre-built (e.g., `Bearer {apiKey}`)
- **List endpoint** — the full API path for fetching leads, with list/object IDs baked in
- **Update record endpoint template** — with `{recordId}` placeholder for record-level field updates
- **Update entry endpoint template** — with `{entryId}` placeholder for list-entry field updates (stage)
- **Request body templates** — with `{fieldSlug}` and `{value}` placeholders
- **Response path** — dot-path to the leads array in the API response
- **Field paths** — dot-paths for extracting id, entryId, name, email, company, followupDate, stage, notes from each lead in the response

The skill has provider-specific knowledge to resolve all of the above. The generated config file must be fully resolved — the HTML viewer contains zero CRM-specific code.

### 2c. Resolve pipeline info

From `pipeline-config.md`:
- `{{PIPELINE_NAME}}`
- `{{USER_EMAIL}}`
- `{{AUTO_APPROVE_THRESHOLD}}`
- Pipeline Stages → serialize to JSON: `[{name: "Prospecting", description: "Initial outreach"}, ...]`

### 2d. Write the config file

Generate a complete JavaScript file and write it to `{WORKSPACE_DIR}/.config/pipeline-view-config.js`:

```js
const PIPELINE_VIEW_CONFIG = {
  pipeline: '{resolved_pipeline_name}',
  userEmail: '{resolved_email}',
  autoApproveThreshold: {resolved_threshold},
  supabase: {
    url: '{resolved_supabase_url}',
    anonKey: '{resolved_anon_key}',
    activitiesTable: '{resolved_table_name}',
  },
  crm: {
    apiBaseUrl: '{resolved_api_base}',
    apiKey: '{resolved_api_key}',
    authHeader: '{resolved_auth_header}',
    list: {
      method: '{resolved_method}',
      endpoint: '{resolved_endpoint}',
      body: {resolved_body},
      responsePath: '{resolved_response_path}',
    },
    updateRecord: {
      method: '{resolved_method}',
      endpointTemplate: '{resolved_endpoint_template}',
      bodyTemplate: {resolved_body_template},
    },
    updateEntry: {
      method: '{resolved_method}',
      endpointTemplate: '{resolved_endpoint_template}',
      bodyTemplate: {resolved_body_template},
    },
    fieldPaths: {
      id: '{resolved_path}',
      entryId: '{resolved_path}',
      name: '{resolved_path}',
      email: '{resolved_path}',
      company: '{resolved_path}',
      followupDate: '{resolved_path}',
      stage: '{resolved_path}',
      notes: '{resolved_path}',
    },
  },
  stages: [{resolved_stages}],
};
```

## Step 3: Copy `activity-viewer.html`

Copy `skills/vibe-closer/views/activity-viewer.html` directly to `{WORKSPACE_DIR}/activity-viewer.html`. This is a static copy — no token replacement.

## Step 4: Report

Print:
```
Workspace artifacts updated:
- .config/pipeline-view-config.js — generated with Supabase + CRM config
- activity-viewer.html — copied from skill (static)
```
