# Job Search Configuration

> **CRITICAL — Provider Safety:** Only use the MCP providers, project IDs, database tables, CRM lists, and credentials explicitly defined in this file. NEVER browse, list, or auto-discover available projects, databases, lists, or workspaces from any MCP provider at runtime. Using the wrong project or database can contaminate the user's data with no ability to recover. If a required value is missing or unclear, ask the user to confirm it rather than discovering it automatically.

## Pipeline
- **{{PIPELINE_NAME}}**:
- **{{USER_EMAIL}}**:

## CRM Tracker (Required)
- **{{CRM_TRACKER}}**: Attio MCP
  - Opportunity list query:
  - Follow-up date field:
  - Status field:
  - Notes field:

## Pipeline Stages
<!-- Imported from CRM during onboard. Stages must be configured in your CRM first. -->

### Stages
<!-- numbered list of stages with descriptions, populated from CRM status field -->

### Stage Transition Rules
<!-- From → To → Trigger table, populated during onboard -->

## Actions Database
- **{{ACTIONS_DB}}**: Supabase
- **{{ACTIVITIES_TABLE}}**: vibe_closer_{{PIPELINE_NAME}}_activities
- **{{LOGS_TABLE}}**: vibe_closer_{{PIPELINE_NAME}}_logs

## Channels

### email
- **Provider**: Gmail MCP
- **Inbox Provider**: Gmail MCP
- **Guidelines**: messaging-guidelines/email-guidelines.md
- **Templates**: messaging-guidelines/email-templates.md
- **Body Schema**: {"subject": "string (omit when reply_in_thread is true)", "message": "string", "recipients": [{"name": "string", "email": "string"}], "cc": [{"name": "string", "email": "string"}], "fingerprint": "string", "reply_in_thread": "boolean (optional, default false)", "thread_id": "string (optional, Gmail thread ID for in-thread replies)"}
- **Fingerprint Method**: Embed `<!-- vc:UUID -->` as hidden HTML comment in email signature
- **Execution**: Draft via Provider (P0: create as draft — pass threadId from body when reply_in_thread is true, pass cc if present; P1: send directly)
- **Polling**: Read inbox via Inbox Provider, match replies by sender email, domain, or fingerprint

### linkedin
- **Provider**: Browser automation / manual
- **Guidelines**: messaging-guidelines/linkedin-dm-guidelines.md
- **Body Schema**: {"message": "string", "profile_url": "string", "fingerprint": "string"}
- **Fingerprint Method**: None (manual matching)
- **Execution**: Present message and profile URL, user sends manually or via browser automation
- **Polling**: None

## Enrichment (Optional)
- **{{COMPANY_RESEARCH}}**: Open company website in browser
- **{{PROFILE_ENRICHMENT}}**: Open LinkedIn profile in browser
- **{{CONTACT_FINDER}}**: Use Village MCP or LinkedIn search

## Relationships (Optional)
- **{{FETCH_RELATIONSHIPS}}**: Village MCP

## Meeting Notes (Optional)
- **{{NOTETAKER}}**: Fathom, Granola

## Scoring
- **{{AUTO_APPROVE_THRESHOLD}}**: 80

## Polling
- **{{POLL_CURSOR}}**: Never
  - Source: {{EMAIL_INBOX}}

## Meta
- **{{LAST_LEARNING_DATE}}**: Never
- **{{LAST_REINDEX_CHECK}}**: Never
- **{{MCP_HINTS}}**: pipeline-mcp-hints.md
