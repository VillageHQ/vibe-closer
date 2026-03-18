# Partnership Pipeline Configuration

> **CRITICAL — Provider Safety:** Only use the MCP providers, project IDs, database tables, CRM lists, and credentials explicitly defined in this file. NEVER browse, list, or auto-discover available projects, databases, lists, or workspaces from any MCP provider at runtime. Using the wrong project or database can contaminate the user's data with no ability to recover. If a required value is missing or unclear, ask the user to confirm it rather than discovering it automatically.

## Pipeline
- **{{PIPELINE_NAME}}**:
  <!-- Example: "BD and Partnerships" or "Strategic Partners" -->
- **{{USER_EMAIL}}**:

## CRM Tracker (Required)
- **{{CRM_TRACKER}}**: Attio MCP
  - Partnership list query:
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
- **Execution**: Send via Provider. Pass threadId from body when reply_in_thread is true, pass cc if present. In **Test Mode**, create as draft instead of sending.
- **Polling**: Read inbox via Inbox Provider, match replies by sender email, domain, or fingerprint

### linkedin
- **Provider**: claude-in-chrome (Browser automation)
- **Guidelines**: messaging-guidelines/linkedin-dm-guidelines.md
- **Body Schema**: {"message": "string", "connection_note": "string (max 300 chars, for connection requests)", "profile_url": "string", "fingerprint": "string"}
- **Fingerprint Method**: None (manual matching)
- **Execution**: Navigate to profile_url in Chrome, detect connection status. If connected: send message as DM. If not connected: send connection request with connection_note. If already pending: skip. Falls back to manual on failure. See execute-approved-activity.md → Browser Automation Execution.
- **Polling**: None

## Enrichment (Optional)
- **{{COMPANY_ENRICHMENT}}**: Village MCP or open website in browser
- **{{PROFILE_ENRICHMENT}}**: Open LinkedIn profile in browser
- **{{WEBSITE_CRAWLING}}**: Open website in browser

## Relationships (Optional)
- **{{FETCH_RELATIONSHIPS}}**: Village MCP
  <!-- Use to find warm intros to BD/partnership contacts -->

## Meeting Notes (Optional)
- **{{NOTETAKER}}**: Fathom, Granola
  <!-- Track partnership conversations and exploratory calls -->

## Scoring
- **{{AUTO_APPROVE_THRESHOLD}}**: 80

## Polling
- **{{POLL_CURSOR}}**: Never
  - Source: {{EMAIL_INBOX}}

## Meta
- **{{LAST_LEARNING_DATE}}**: Never
- **{{LAST_REINDEX_CHECK}}**: Never
- **{{MCP_HINTS}}**: pipeline-mcp-hints.md

