<!-- EXAMPLE CONTENT — This file contains example content from the template.
     ALL content below must be replaced with real content during onboarding.
     Remove this marker once real content has been written. -->

# Sequence Flow

> Messaging tone, email rules, and LinkedIn rules → `messaging-guidelines/`
> Pipeline stages and transition rules → `pipeline-config.md` → `## Pipeline Stages`

## Execution Sequence

For each lead, follow these steps:

1. Fetch warm paths via {{FETCH_RELATIONSHIPS}}
2. Send initial outreach via the 1st path — warm intros preferred; cold outreach for strong thesis fits
3. If no reply after 3 days, send follow-up (in recipient's timezone)
4. If no reply after 1 day, move to the next path and repeat from step 2
5. Always draft a reply and follow-up on the last message
6. If the last message is from me, never follow-up more than once per channel
7. After first meeting, follow up within 24 hours with notes and next steps
8. If the lead replies and is not interested, mark as Closed Lost in {{CRM_TRACKER}}
9. If no reply after completing all paths, set follow-up date to 6 months from now
10. If still no reply after the 6-month follow-up, set follow-up date to 1 year from now

## Frequency Rules

- Max 1 follow-up per channel before stopping

## Key Principles

- **Warm intros from portfolio founders are strongest** — founders trust other founders.
- **Be transparent about process and timeline** — founders are juggling multiple investors.
- **Pass quickly and gracefully** — today's pass could be next round's lead deal.
- **Take detailed meeting notes** — they drive follow-up strategy and IC memo.
- **Move fast when you have conviction** — speed wins competitive deals.
