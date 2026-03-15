# Sequence Flow

> Messaging tone, email rules, and LinkedIn rules → `messaging-guidelines/`
> Pipeline stages and transition rules → `pipeline-config.md` → `## Pipeline Stages`

## Execution Sequence

For each lead, follow these steps:

1. Fetch warm paths via {{FETCH_RELATIONSHIPS}} — exhaust all warm options before cold outreach
2. Send initial outreach via the 1st path — always prioritize warm intros; cold email only as last resort
3. If no reply after 3 days, send follow-up (in recipient's timezone)
4. If no reply after 1 week, send a LinkedIn message
5. Always draft a reply and follow-up on the last message
6. If the last message is from me, never follow-up more than once per channel
7. Max 2 follow-ups before moving to "no reply" status
8. If the lead replies and is not interested, mark as Closed Lost in {{CRM_TRACKER}}
9. If no reply after completing all paths, set follow-up date to 6 months from now
10. If still no reply after the 6-month follow-up, set follow-up date to 1 year from now

## Frequency Rules

- Max 2 follow-ups total before moving to "no reply" status
- Aim for 8-10 investor meetings per week during peak outreach

## Key Principles

- **Warm always beats cold** — a warm intro converts at 10-20x the rate of cold email (<5% response rate). Spend energy finding paths before going cold.
- **Forwardable blurbs are essential** — make it easy for connectors to introduce you. They should just forward, not write.
- **Data room is your demo** — once an investor expresses interest, send data room access with a cover email highlighting thesis-relevant sections.
- **Manage competitive dynamics transparently** — when 2+ firms are in process, communicate timeline without naming names. Never bluff about competing term sheets.
- **Capture meeting notes immediately** — after every investor meeting, record key questions, concerns, and next steps. These drive follow-up strategy.
