# Workflow Planner

## Outreach Sequencing Rules

1. Always reach out directly to the candidate
2. Fetch paths using {{FETCH_RELATIONSHIPS}} to find mutual connections
3. When a mutual connection exists, mention them in the outreach as social proof ("Sarah on our team mentioned you'd be great for this")
4. If no reply after 4 days, send a follow-up email with a different angle (new project detail, team info, or specific challenge they'd work on)
5. If still no reply, send a LinkedIn message 3 days later
6. If the last message is from us, never follow-up more than once per channel
7. After a positive reply, move fast — schedule the call within 48 hours

---

## Execution Sequence

For each lead, follow these steps:

1. Fetch warm paths via {{FETCH_RELATIONSHIPS}}
2. Send initial outreach directly to the candidate — if warm path exists, mention them as social proof in the email
3. If no reply after 3 days, send follow-up (in recipient's timezone)
4. If no reply after 1 day, move to the next path and repeat from step 2
5. Always draft a reply and follow-up on the last message
6. If the last email is from me, never follow-up more than once
7. If the lead replies and is not interested, mark as Declined in {{CRM_TRACKER}}
8. If no reply after completing all paths, set follow-up date to 6 months from now
9. If still no reply after the 6-month follow-up, set follow-up date to 1 year from now

---

## Pipeline Stages

1. **Sourced** — Candidate identified, not yet contacted
2. **Contacted** — First outreach sent (email or LinkedIn)
3. **Replied** — Candidate responded (positive, neutral, or "not now")
4. **Phone Screen** — Initial 30-min call scheduled or completed
5. **Technical Interview** — Technical assessment scheduled or completed
6. **Team Interview** — Culture/team fit interviews
7. **Offer Prep** — Preparing offer package
8. **Offer Extended** — Offer sent to candidate
9. **Offer Accepted** — Candidate accepted, start date confirmed
10. **Declined** — Candidate passed or rejected (add reason)
11. **Nurture** — Not right now, but strong candidate for future roles

## Stage Transition Rules

| From | To | Trigger |
|------|-----|---------|
| Sourced | Contacted | First outreach sent |
| Contacted | Replied | Candidate responds |
| Replied | Phone Screen | Call scheduled |
| Phone Screen | Technical Interview | Passed phone screen, technical scheduled |
| Phone Screen | Declined | Not a fit after phone screen |
| Technical Interview | Team Interview | Passed technical |
| Team Interview | Offer Prep | Team says yes |
| Offer Prep | Offer Extended | Offer sent |
| Offer Extended | Offer Accepted | Candidate signs |
| Offer Extended | Declined | Candidate declines |
| Declined | Nurture | Strong candidate, wrong timing (auto after 90 days) |

## Frequency Rules
- Max 1 email per candidate per 4 days
- Max 1 LinkedIn message per candidate per 5 days
- Max 2 channels active simultaneously
- Stop outreach after 2 unanswered touches across channels
- Nurture: max 1 touch per 60 days (share company news, new roles)
