# Workflow Planner

> **Note:** Channels referenced below (email, LinkedIn, etc.) correspond to entries in `config.md` → `## Channels`. If a referenced channel is not configured, skip that step. If additional channels are configured, the user's workflow preferences determine when to use them.

## Outreach Sequencing Rules

1. Always prioritize warm introductions — portfolio founders, co-investors, and advisors introducing you to promising startups converts at 10x the rate of cold outreach
2. Fetch paths using {{FETCH_RELATIONSHIPS}} to find mutual connections to founders
3. When a warm path exists, request the intro and include a brief note on why you're interested in the company specifically
4. Cold outreach is acceptable for strong thesis-fit startups — personalize heavily with specific observations about their product, market, or traction
5. After an intro or cold email, follow up once if no reply — never more than once per channel
6. After a first meeting, follow up within 24 hours with notes and next steps
7. Respect founders' time — be direct about your interest level and timeline

## Execution Sequence

For each lead, follow these steps:

1. Fetch warm paths via {{FETCH_RELATIONSHIPS}}
2. Send initial outreach via the 1st path — warm intros preferred, cold outreach for strong thesis fits
3. If no reply after 3 days, send follow-up (in recipient's timezone)
4. If no reply after 1 day, move to the next path and repeat from step 2
5. Always draft a reply and follow-up on the last message
6. If the last email is from me, never follow-up more than once
7. If the lead replies and is not interested, mark as Closed Lost in {{CRM_TRACKER}}
8. If no reply after completing all paths, set follow-up date to 6 months from now
9. If still no reply after the 6-month follow-up, set follow-up date to 1 year from now

## Pipeline Stages

1. **Sourced** — Startup identified, matches thesis criteria
2. **Intro Requested** — Asked for warm intro; awaiting connector response
3. **Contacted** — Initial outreach sent (warm intro, cold email, or LinkedIn)
4. **First Meeting** — First call/meeting scheduled or completed
5. **Partner Meeting** — Brought to investment committee or additional partners
6. **Due Diligence** — Reviewing materials, data room, customer references
7. **Term Sheet** — Term sheet sent or in negotiation
8. **Closed Won** — Investment completed, funds wired
9. **Closed Lost** — Passed on the opportunity (record reason)

## Stage Transition Rules

| From | To | Trigger |
|------|-----|---------|
| Sourced | Intro Requested | Identify mutual connection and request intro |
| Sourced | Contacted | Send cold email or LinkedIn (when no warm path) |
| Intro Requested | Contacted | Connector makes the introduction |
| Contacted | First Meeting | Founder agrees to meet, calendar invite sent |
| First Meeting | Partner Meeting | Internal conviction to bring to committee |
| First Meeting | Closed Lost | Not a fit after first meeting |
| Partner Meeting | Due Diligence | Committee agrees to proceed, request data room |
| Partner Meeting | Closed Lost | Committee passes |
| Due Diligence | Term Sheet | Conviction confirmed, send terms |
| Due Diligence | Closed Lost | Issues found during review |
| Term Sheet | Closed Won | Terms agreed, docs signed, funds wired |
| Term Sheet | Closed Lost | Founder selects another investor |

## Key Principles

- Warm intros from portfolio founders are your strongest signal — founders trust other founders
- Be transparent about your process and timeline — founders are juggling multiple investors
- When you pass, do it quickly and gracefully — today's pass could be next round's lead deal
- Take detailed meeting notes — they drive your follow-up strategy and IC memo
- Move fast when you have conviction — speed wins competitive deals
