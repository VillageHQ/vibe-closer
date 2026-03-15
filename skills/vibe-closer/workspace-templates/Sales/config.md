# Pipeline Configuration

## Pipeline
- **{{PIPELINE_NAME}}**:

## CRM Tracker (Required)
- **{{CRM_TRACKER}}**: Attio MCP
  - Lead list query:
  - Follow-up date field:
  - Status field:
  - Notes field:

## Actions Database
- **{{ACTIONS_DB}}**: Supabase
  - Table name: vibe_closer_{{PIPELINE_NAME}}_activities

## Email (Required)
- **{{EMAIL_SENDING}}**: Gmail MCP
- **{{EMAIL_INBOX}}**: Gmail MCP

## Enrichment (Optional)
- **{{EMAIL_ENRICHMENT}}**: Use CRM
- **{{PROFILE_ENRICHMENT}}**: Open LinkedIn profile in browser
- **{{WEBSITE_CRAWLING}}**: Open website in browser

## Relationships (Optional)
- **{{FETCH_RELATIONSHIPS}}**: Village MCP

## Meeting Notes (Optional)
- **{{NOTETAKER}}**: Fathom, Granola

## Polling
- **{{POLL_CURSOR}}**: Never
  - Source: {{EMAIL_INBOX}}

## Meta
- **{{LAST_LEARNING_DATE}}**: Never
