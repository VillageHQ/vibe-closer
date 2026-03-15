# Workflow Planner

## Outreach Sequencing Rules

1. **Always reach out to the target directly first.** Cold email is the primary channel. Do not wait for a warm intro before making contact — direct outreach is how pipeline gets built.
2. **Fetch relationship paths** using `{{FETCH_RELATIONSHIPS}}` to identify mutual connections. Use these for social proof in the email body (e.g., "I noticed you're connected with [mutual] — they've been using Metricflow for their metrics layer").
3. **When a warm connection exists, mention them as social proof** — but still send the outreach yourself. Only request a forwardable intro if the connection is strong and the prospect is high-value (Director+ at 500+ employee company).
4. **If no reply after 3 business days**, send a follow-up email (in recipient's timezone, Tue-Thu, 9-11am local) AND send a LinkedIn connection request with a personalized note.
5. **Always draft replies and follow-ups on the last message** — never let a thread go cold without a planned next touch.
6. **Never follow up more than once per channel** if the last message is from you. After 1 email follow-up + 1 LinkedIn message with no response, move to "Paused" and revisit in 30 days with a new angle.

---

## Execution Sequence

For each lead, follow these steps:

1. Fetch warm paths via {{FETCH_RELATIONSHIPS}}
2. Send initial outreach directly to the target — if warm path exists, mention them as social proof in the email
3. If no reply after 3 days, send follow-up (in recipient's timezone)
4. If no reply after 1 day, move to the next path and repeat from step 2
5. Always draft a reply and follow-up on the last message
6. If the last email is from me, never follow-up more than once
7. If the lead replies and is not interested, mark as Closed Lost in {{CRM_TRACKER}}
8. If no reply after completing all paths, set follow-up date to 6 months from now
9. If still no reply after the 6-month follow-up, set follow-up date to 1 year from now

---

## Pipeline Stages

| Stage | Description | Entry Criteria |
|-------|-------------|---------------|
| 1. New Lead | Identified, matches ICP, not yet contacted | Passes qualification criteria in `lead_preferences/lead-discovery.md` |
| 2. Researched | Background research complete, outreach drafted | Company context, pain points, and personalization hooks documented |
| 3. Contacted | First outreach sent (email or LinkedIn) | Initial email or LinkedIn message delivered |
| 4. Engaged | Prospect has replied (positive or neutral) | Any non-automated reply received |
| 5. Meeting Scheduled | Demo or intro call on the calendar | Calendar invite sent and accepted |
| 6. Demo Complete | Demo delivered, next steps discussed | Demo meeting occurred, notes captured |
| 7. Proposal / Evaluation | Prospect evaluating, POC or proposal in progress | Prospect requested pricing, POC, or technical review |
| 8. Closed Won | Deal signed | Contract executed |
| 9. Closed Lost | Prospect declined or went dark after engagement | Explicit "no" or 60+ days of no response after engagement |
| 10. Paused | Timing not right, revisit later | Prospect said "not now" or no reply after full sequence |

## Stage Transition Rules

| From | To | Trigger |
|------|----|---------|
| New Lead | Researched | Personalization hooks and pain points documented |
| Researched | Contacted | First outreach message sent |
| Contacted | Engaged | Prospect replies (non-bounce, non-OOO) |
| Contacted | Paused | No reply after 1 follow-up email + 1 LinkedIn message (wait 30 days) |
| Engaged | Meeting Scheduled | Prospect agrees to a call/demo and calendar invite is confirmed |
| Engaged | Closed Lost | Prospect explicitly declines with no future interest |
| Engaged | Paused | Prospect says "not right now" — set 30-60 day revisit |
| Meeting Scheduled | Demo Complete | Meeting occurs and notes are logged |
| Meeting Scheduled | Closed Lost | Prospect no-shows twice or cancels with no reschedule |
| Demo Complete | Proposal / Evaluation | Prospect requests pricing, POC, or involves additional stakeholders |
| Demo Complete | Closed Lost | Prospect declines after demo |
| Proposal / Evaluation | Closed Won | Contract signed |
| Proposal / Evaluation | Closed Lost | Prospect selects competitor or kills initiative |
| Paused | Researched | 30-60 days elapsed, re-research with fresh angle |

## Key Principles

- **Direct outreach is primary.** Do not wait for warm intros to start building pipeline. Warm intros are leverage, not a prerequisite.
- **Mutual connections are social proof, not gatekeepers.** Mention them in your outreach to build credibility, but don't depend on them to make the introduction.
- **Every touch adds value.** Never send a "just checking in" message. Each follow-up must include a new insight, case study, or relevant observation about the prospect's business.
- **Speed matters.** When a prospect replies, respond within 4 hours during business hours. Meeting requests should include a scheduling link with availability within the next 3 business days.
- **Multi-thread on high-value accounts.** For companies with 500+ employees, identify 2-3 potential champions across engineering and data teams. Engage them in parallel with tailored messaging.
