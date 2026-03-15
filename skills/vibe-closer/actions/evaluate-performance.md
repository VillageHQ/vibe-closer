# Evaluate Performance

Measure pipeline effectiveness against goals.

## Steps

1. **Read goals** — Load `goals.md` for success criteria

2. **Gather metrics** from available sources:

   ### Pipeline metrics (via `{{CRM_TRACKER}}`)
   - Total leads in pipeline
   - Leads by stage (distribution)
   - Stage conversion rates
   - Average time in each stage
   - Leads managed through vibe-closer vs manually added

   ### Outreach metrics (via `{{ACTIONS_DB}}`)
   - Activities generated vs approved vs executed
   - Activities by type breakdown
   - Edit rate (how often user modifies drafts)
   - Rejection rate

   ### Response metrics (via `{{EMAIL_INBOX}}` and LinkedIn)
   - Emails sent vs replied — use the same matching logic as `poll-new-activity.md` (build matching sets of known_emails, known_domains, known_fingerprints from `{{ACTIONS_DB}}`, then match against inbox)
   - Reply rate by template/approach
   - Average time to reply
   - LinkedIn messages sent vs accepted/replied

3. **Compare against goals** — Map metrics to success criteria from `goals.md`

4. **Generate report**:

```markdown
## Pipeline Performance Report — [Date]

### Goal Progress
- [Goal 1]: [metric] / [target] — [status]

### Pipeline Health
- Active leads: [N]
- Due for follow-up: [N]
- Stale (>14 days no activity): [N]

### Outreach Effectiveness
- Messages sent: [N]
- Reply rate: [X%]
- Best performing template: [name]
- Approval rate: [X%] (higher = better drafts)

### Recommendations
- [Actionable recommendation 1]
- [Actionable recommendation 2]
```

5. Save report to `progress/performance/[date]-report.md`
