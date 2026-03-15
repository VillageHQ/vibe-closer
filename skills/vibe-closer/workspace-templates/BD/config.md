# Partnership Pipeline Configuration

## Pipeline
- **{{PIPELINE_NAME}}**:
  <!-- Example: "BD and Partnerships" or "Strategic Partners" -->

## CRM Tracker (Required)
- **{{CRM_TRACKER}}**: Attio MCP
  - Partnership list query:
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
- **{{COMPANY_ENRICHMENT}}**: Village MCP or open website in browser
- **{{PROFILE_ENRICHMENT}}**: Open LinkedIn profile in browser
- **{{WEBSITE_CRAWLING}}**: Open website in browser

## Relationships (Optional)
- **{{FETCH_RELATIONSHIPS}}**: Village MCP
  <!-- Use to find warm intros to BD/partnership contacts -->

## Meeting Notes (Optional)
- **{{NOTETAKER}}**: Fathom, Granola
  <!-- Track partnership conversations and exploratory calls -->

## Polling
- **{{POLL_CURSOR}}**: Never
  - Source: {{EMAIL_INBOX}}

## Meta
- **{{LAST_LEARNING_DATE}}**: Never
- **{{LAST_REINDEX_CHECK}}**: Never

