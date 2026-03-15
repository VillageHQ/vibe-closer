# Generate Lead Activity

## Steps

1. **Load workflow rules** — Read `workflow-planner.md` for sequencing logic
2. **Load lead context** — Run `gather-lead-context.md` → `fetch-full-lead-context`
3. **Check previous activity** — Query `{{ACTIONS_DB}}` for this lead's activity history
4. **Check for regeneration requests** — Query `{{ACTIONS_DB}}` for activities where `needs_regeneration = true` for this lead. If found:
   - Load the existing activity's `notes` array as user feedback context
   - Delete the existing pending activity
   - Include all notes as guidance when generating the new activity (e.g., "User feedback on previous draft: [notes]")
   - After generating the replacement activity, ensure `needs_regeneration` is `false` on the new record

5. **Determine workflow step** — Based on:
   - Previous activities and their outcomes
   - Workflow planner rules
   - Time since last contact
   - Channel history (email vs LinkedIn)

6. **If not yet connected** — Run `gather-lead-context.md` → `research-lead` first

7. **Generate activity** — Based on the determined step:

   ### For outreach messages:
   a. Select appropriate template from `messaging-guidelines/email-templates.md`
   b. Apply tone from `messaging-guidelines/tone.md`
   c. Follow channel-specific guidelines (`email-guidelines.md` or `linkedin-dm-guidelines.md`)
   d. Personalize using lead context and ICP match from `profile/icps.md`
   e. Add fingerprint for traceability
   f. Check for warm paths — if found, mention mutual connection as social proof

   ### For CRM updates:
   a. Determine new follow-up date based on workflow rules
   b. Draft note summarizing rationale
   c. Update pipeline stage if warranted

8. **Score activity** — Invoke `actions/score-activity.md` as a sub-agent, passing:
   - The generated activity (type, body, summary, contacts, account)
   - The `full_lead_context` used for generation
   - Relevant workspace files: `profile/icps.md`, `messaging-guidelines/tone.md`, applicable channel guidelines, `workflow-planner.md`

   The sub-agent returns `confidence_score`, `scoring_breakdown`, and `overall_reasoning`.

9. **Store in DB** — Insert into `{{ACTIONS_DB}}`:
   - `approval_status`: if `confidence_score` >= `{{AUTO_APPROVE_THRESHOLD}}` from `config.md`, set to `'approved'`; otherwise `'pending'`
   - `execution_status`: pending
   - `activity_type`: determined type
   - `contacts`: lead contacts
   - `account`: company info
   - `scheduled_date`: determined date
   - `summary`: human-readable description
   - `full_lead_context`: snapshot of context used
   - `body`: action-specific payload
   - `confidence_score`: score from scoring step
   - `scoring_breakdown`: full breakdown JSON from scoring step

10. **Present to user** — Show the drafted activity with its confidence score:
   - Display: "Confidence: [score]/100 — [overall_reasoning]"
   - If auto-approved (score >= threshold): "Auto-approved (score [X] >= threshold [Y]). Will execute on scheduled date."
   - If pending (score < threshold): show for manual review as before

## Activity Quality Checks

Before presenting, verify:
- [ ] Message is personalized (not generic)
- [ ] Tone matches `messaging-guidelines/tone.md`
- [ ] Follows workflow sequencing rules
- [ ] Doesn't duplicate recent outreach on same channel
- [ ] Respects follow-up frequency limits from workflow planner
- [ ] Confidence score is reasonable (flag if scoring seems miscalibrated)
