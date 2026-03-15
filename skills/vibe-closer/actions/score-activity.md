# Score Activity

Evaluate a generated activity for quality and confidence before storing it in the database. This action is invoked as a **sub-agent** by `generate-lead-activity.md` — keep your output concise and structured.

## Inputs (provided by caller)

- The generated activity (type, body, summary, contacts, account)
- Lead context snapshot used during generation
- Workspace files for scoring context

## Scoring Dimensions

Evaluate each dimension on a 0–20 scale. The total (0–100) is the confidence score.

### 1. Personalization Quality (0–20)

Does the message reference specific details about the lead or company — role, recent news, mutual connections, stated pain points? Is it distinguishable from a generic template?

| Range | Meaning |
|-------|---------|
| 0–5 | Generic / templated — no lead-specific details |
| 6–10 | Light personalization — mentions company name or title only |
| 11–15 | Good — references specific context (recent funding, role change, etc.) |
| 16–20 | Deeply researched — weaves multiple lead-specific signals naturally |

### 2. ICP Match (0–20)

How well does this lead match the ideal customer profiles in `profile/icps.md`? Is the value proposition aligned to the lead's likely pain points?

| Range | Meaning |
|-------|---------|
| 0–5 | Poor match — lead doesn't fit any ICP |
| 6–10 | Partial — matches some criteria but missing key signals |
| 11–15 | Good match — fits an ICP with clear alignment |
| 16–20 | Ideal customer — strong multi-signal match |

### 3. Timing Appropriateness (0–20)

Is the scheduled date reasonable given `workflow-planner.md` rules? Is the channel appropriate for the current stage? Has enough time passed since last contact?

| Range | Meaning |
|-------|---------|
| 0–5 | Wrong timing — too early, too late, or wrong channel for stage |
| 6–10 | Acceptable — meets minimum spacing but not optimal |
| 11–15 | Well-timed — follows workflow rules cleanly |
| 16–20 | Optimal — perfect window based on context signals |

### 4. Messaging Guideline Adherence (0–20)

Does the tone match `messaging-guidelines/tone.md`? Does the format follow `email-guidelines.md` or `linkedin-dm-guidelines.md`? Are template structures from `email-templates.md` respected?

| Range | Meaning |
|-------|---------|
| 0–5 | Off-brand — tone, length, or structure violates guidelines |
| 6–10 | Partially aligned — mostly correct but noticeable deviations |
| 11–15 | Well-aligned — follows guidelines with minor flexibility |
| 16–20 | Exemplary — could serve as a reference example |

### 5. Workflow Compliance (0–20)

Does this follow the expected workflow sequence from `workflow-planner.md`? Is the activity type appropriate for the current stage? No duplicate outreach on the same channel recently?

| Range | Meaning |
|-------|---------|
| 0–5 | Violates rules — wrong sequence step, duplicate channel, or skipped stage |
| 6–10 | Minor deviations — mostly correct with small gaps |
| 11–15 | Compliant — follows all rules |
| 16–20 | Perfectly sequenced — optimal step given full history |

## CRM-Only Activities

For non-outreach activities (`update_followup_date`, `change_pipeline_stage`, `add_lead`):
- Auto-score **Personalization Quality** at 15
- Auto-score **Messaging Guideline Adherence** at 15
- Score the remaining 3 dimensions normally

These activities have fewer subjective dimensions and will typically score higher.

## Output Format

Return as JSON:

```json
{
  "confidence_score": 82,
  "scoring_breakdown": {
    "personalization_quality": { "score": 16, "reasoning": "References recent Series B and CTO hire" },
    "icp_match": { "score": 18, "reasoning": "VP Eng at B2B SaaS, 200 employees, hiring data roles" },
    "timing_appropriateness": { "score": 14, "reasoning": "5 business days since last touch, email channel appropriate" },
    "messaging_guideline_adherence": { "score": 17, "reasoning": "Matches casual-professional tone, under 150 words" },
    "workflow_compliance": { "score": 17, "reasoning": "Correct follow-up step after initial cold email" }
  },
  "overall_reasoning": "Strong outreach with deep personalization to a well-matched ICP; timing and compliance are solid."
}
```
