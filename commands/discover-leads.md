---
description: "Discover new leads from email, meetings, and conversations"
---

# Discover New Leads

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

1. Read `lead_preferences/lead-discovery.md` for discovery instructions
2. Search for potential leads using configured sources:
   - `{{NOTETAKER}}` — recent meeting transcripts
   - `{{EMAIL_INBOX}}` — recent email conversations
   - `{{FETCH_RELATIONSHIPS}}` — relationship graph
3. For each potential lead:
   a. Check if already tracked in `{{CRM_TRACKER}}`
   b. If not tracked, draft an `add_lead` activity
4. Present discovered leads to user for review
5. For approved leads: read `actions/add-leads.md` → add to CRM
