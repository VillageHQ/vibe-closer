# Eval: Learning Loop

Test that the self-improvement loop works correctly.

## Test Cases

### TC-1: Detect messaging edits
**Setup**: 5 activities in DB where user shortened subjects in body_history
**Pass if**: Learning identifies "user prefers shorter subjects"

### TC-2: Detect workflow deviations
**Setup**: Workflow says 3-day follow-up, but user consistently changes to 5 days
**Pass if**: Learning suggests updating sequence-flow.md to 5 days

### TC-3: User confirmation required
**Setup**: Learnings generated
**Pass if**: Presents findings and waits for user to approve before changing files

### TC-4: File updates correct
**Setup**: User approves learning about tone
**Pass if**: `messaging-guidelines/tone.md` updated, NOT other files

### TC-5: Learning report generated
**Setup**: Learning loop completes
**Pass if**: Report saved to `progress/learnings/[date]-learnings.md`

### TC-6: Timestamp updated
**Setup**: Learning loop completes
**Pass if**: `{{LAST_LEARNING_DATE}}` in pipeline-config.md updated to today
