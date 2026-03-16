<!-- EXAMPLE CONTENT — This file contains example content from the template.
     ALL content below must be replaced with real content during onboarding.
     Remove this marker once real content has been written. -->

# Sequence Flow

> Messaging tone, email rules, and LinkedIn rules → `messaging-guidelines/`
> Pipeline stages and transition rules → `pipeline-config.md` → `## Pipeline Stages`

## Execution Sequence

For each lead, follow these steps:

1. Fetch warm paths via {{FETCH_RELATIONSHIPS}}
2. Send initial outreach directly to the target — if warm path exists, mention them as social proof in the email
3. If no reply after 3 days, send follow-up AND send a LinkedIn connection request with a personalized note
4. If no reply after 1 day, move to the next path and repeat from step 2
5. Always draft a reply and follow-up on the last message
6. If the last message is from me, never follow-up more than once per channel
7. If the lead replies and is not interested, mark as Closed Lost in {{CRM_TRACKER}}
8. After 1 email follow-up + 1 LinkedIn message with no response, move to "Paused" and revisit in 30 days with a new angle
9. If no reply after completing all paths, set follow-up date to 6 months from now
10. If still no reply after the 6-month follow-up, set follow-up date to 1 year from now

## Frequency Rules

- Max 1 email follow-up + 1 LinkedIn message per sequence before pausing
- Revisit paused leads after 30 days with a new angle

## Key Principles

- **Direct outreach is primary** — do not wait for warm intros to build pipeline. Warm intros are leverage, not a prerequisite.
- **Mutual connections are social proof, not gatekeepers** — mention them in outreach to build credibility, but don't depend on them to make the introduction.
- **Speed matters** — when a prospect replies, respond within 4 hours during business hours. Include a scheduling link with availability within the next 3 business days.
- **Multi-thread on high-value accounts** — for companies with 500+ employees, identify 2-3 potential champions across teams and engage in parallel with tailored messaging.
