# Pipeline Configuration

## Pipeline
- **{{PIPELINE_NAME}}**:
  <!-- Example: Seed Round, Series A, etc. -->
- **{{USER_EMAIL}}**:

## CRM Tracker (Required)
- **{{CRM_TRACKER}}**: Attio MCP
  - Lead list query: investors in current funnel
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
- **{{WEBSITE_CRAWLING}}**: Open firm website in browser

## Relationships (Optional)
- **{{FETCH_RELATIONSHIPS}}**: Village MCP
  <!-- Use this to find warm paths to investors -->

## Meeting Notes (Optional)
- **{{NOTETAKER}}**: Fathom, Granola
  <!-- Track investor conversations for follow-ups and signals -->

## Scoring
- **{{AUTO_APPROVE_THRESHOLD}}**: 80

## Polling
- **{{POLL_CURSOR}}**: Never
  - Source: {{EMAIL_INBOX}}

## Meta
- **{{LAST_LEARNING_DATE}}**: Never
- **{{LAST_REINDEX_CHECK}}**: Never
