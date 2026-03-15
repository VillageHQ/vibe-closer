# Job Search Configuration

## Pipeline
- **{{PIPELINE_NAME}}**:
- **{{USER_EMAIL}}**:

## CRM Tracker (Required)
- **{{CRM_TRACKER}}**: Attio MCP
  - Opportunity list query:
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
