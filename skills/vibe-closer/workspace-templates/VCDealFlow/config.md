# Pipeline Configuration

## Pipeline
- **{{PIPELINE_NAME}}**:
- **{{USER_EMAIL}}**:

## CRM Tracker (Required)
- **{{CRM_TRACKER}}**: Attio MCP
  - Lead list query: startups in current pipeline
  - Follow-up date field: next_outreach_date
  - Status field: stage
  - Notes field: conversation_notes

## Actions Database
- **{{ACTIONS_DB}}**: Supabase
  - Table name: vibe_closer_{{PIPELINE_NAME}}_activities

## Email (Required)
- **{{EMAIL_SENDING}}**: Gmail MCP
- **{{EMAIL_INBOX}}**: Gmail MCP

## Enrichment (Optional)
- **{{EMAIL_ENRICHMENT}}**: Use CRM or manual research
- **{{PROFILE_ENRICHMENT}}**: Open LinkedIn profile in browser
- **{{WEBSITE_CRAWLING}}**: Open company website in browser

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
