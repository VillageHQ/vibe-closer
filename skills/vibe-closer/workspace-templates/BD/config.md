# Partnership Pipeline Configuration

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

## Actions Database
- **{{ACTIONS_DB}}**: Supabase
  - Table name: vibe_closer_{{PIPELINE_NAME}}_activities
  - Logs table: vibe_closer_{{PIPELINE_NAME}}_logs

## Channels

### email
- **Provider**: Gmail MCP
- **Inbox Provider**: Gmail MCP
- **Guidelines**: messaging-guidelines/email-guidelines.md
- **Templates**: messaging-guidelines/email-templates.md
- **Body Schema**: {"subject": "string", "message": "string", "recipients": [{"name": "string", "email": "string"}], "fingerprint": "string"}
- **Fingerprint Method**: Embed `<!-- vc:UUID -->` as hidden HTML comment in email signature
- **Execution**: Draft via Provider (P0: create as draft, P1: send directly)
- **Polling**: Read inbox via Inbox Provider, match replies by sender email, domain, or fingerprint

### linkedin
- **Provider**: Browser automation / manual
- **Guidelines**: messaging-guidelines/linkedin-dm-guidelines.md
- **Body Schema**: {"message": "string", "profile_url": "string", "fingerprint": "string"}
- **Fingerprint Method**: None (manual matching)
- **Execution**: Present message and profile URL, user sends manually or via browser automation
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

