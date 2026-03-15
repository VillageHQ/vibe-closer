---
description: "Discover new leads from email, meetings, and conversations"
---

# Discover New Leads

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

## Phase 1: Load Discovery Instructions
Read `lead_preferences/lead-discovery.md` for discovery instructions.

## Phase 2: Search for Potential Leads
Search for potential leads using configured sources:
- `{{NOTETAKER}}` — recent meeting transcripts
- `{{EMAIL_INBOX}}` — recent email conversations
- `{{FETCH_RELATIONSHIPS}}` — relationship graph

## Phase 3: Deduplicate Against CRM
For each potential lead, check if already tracked in `{{CRM_TRACKER}}` using the CRM's native record lookup. Skip leads that already exist. For new leads, draft an `add_lead` activity.

## Phase 4: Present for Review
Present discovered leads to user for review.

## Phase 5: Add Approved Leads
For approved leads: read `actions/add-update-leads.md` → add to CRM.
