<!-- EXAMPLE CONTENT — This file contains example content from the template.
     ALL content below must be replaced with real content during onboarding.
     Remove this marker once real content has been written. -->

# Sequence Flow

> Messaging tone, email rules, and LinkedIn rules → `messaging-guidelines/`
> Pipeline stages and transition rules → `pipeline-config.md` → `## Pipeline Stages`

## Execution Sequence

For each lead, follow these steps:

1. Fetch warm paths via {{FETCH_RELATIONSHIPS}}
2. Send initial outreach directly to the candidate — if warm path exists, mention them as social proof in the email
3. If no reply after 4 days, send follow-up with a different angle (new project detail, team info, or specific challenge)
4. If still no reply after 3 days, send a LinkedIn message
5. Always draft a reply and follow-up on the last message
6. If the last message is from me, never follow-up more than once per channel
7. If the lead replies and is not interested, mark as Declined in {{CRM_TRACKER}}
8. If no reply after completing all paths, set follow-up date to 6 months from now
9. If still no reply after the 6-month follow-up, set follow-up date to 1 year from now

## Frequency Rules

- Max 1 email per candidate per 4 days
- Max 1 LinkedIn message per candidate per 5 days
- Max 2 channels active simultaneously
- Stop outreach after 2 unanswered touches across channels
- Nurture: max 1 touch per 60 days (share company news, new roles)

## Key Principles

- **Move fast on positive replies** — schedule call within 48 hours of a candidate responding.
- **Direct outreach is primary** — warm paths are social proof to strengthen your message, not a prerequisite.
