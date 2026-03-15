---
description: "Analyze pipeline performance and improve workspace files"
---

# Learn & Improve

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

Self-improvement loop that updates workspace files based on real results.

## Step 1: Generate Learnings

### Learn about messaging
1. Query `{{ACTIONS_DB}}` for activities where:
   - `execution_status = 'finished'`
   - `body_history` is not empty (was edited before approval) OR `notes` is not empty
   - `learnings` field is empty
2. For each activity:
   - Compare original `body` (from `body_history[0]`) with final approved `body`
   - Identify patterns: what did the user change? (tone, length, structure, personalization)
   - **Review `notes` array** — these are explicit user feedback (higher signal than edit diffs). Treat each note as a direct instruction: "User said: [note]". Notes on regenerated activities are especially valuable as they show what the user disliked about the AI-generated draft.
   - Check response data if available (via `{{EMAIL_INBOX}}`)
   - Write a learning: "User prefers X over Y in Z context"
   - Update the activity's `learnings` field in DB: `SET learnings = '[concise summary of what was learned from this activity]'` — this marks the activity as processed so it won't be analyzed again

### Learn about profile
1. Fetch all recent communication via `{{EMAIL_INBOX}}` and `{{NOTETAKER}}`
2. Compare how the user describes themselves/product vs what's in `profile/icps.md`
3. Identify gaps or evolving positioning

### Learn about workflow
1. Review activity history for pattern breaks:
   - Did the user skip suggested steps?
   - Did they change the follow-up timing?
   - Did they prefer certain channels over others?
2. Compare actual workflow vs `workflow-planner.md` rules

## Step 2: Clarify with User

Present findings as a numbered list:

```
Based on recent activity, I noticed:
1. You consistently shorten email subjects to <5 words
2. You always remove the "mutual connection" line when there's no strong tie
3. Follow-ups seem to work better at 5 days vs the current 3-day rule
4. Your ICP description doesn't mention [new pattern I noticed]

Which of these should I incorporate into the workspace? (e.g., "1,3" or "all")
```

Wait for user confirmation before making changes.

## Step 3: Update Workspace Files

For each approved learning, update the relevant file:
- Messaging patterns → `messaging-guidelines/` files
- Profile/ICP changes → `profile/icps.md`
- Workflow changes → `workflow-planner.md`
- Tone adjustments → `messaging-guidelines/tone.md`

## Step 4: Record & Timestamp

1. Generate a learning report in `progress/learnings/[date]-learnings.md`
2. Update `{{LAST_LEARNING_DATE}}` in `config.md` to today's date

## Learning Report Format

```markdown
## Learnings — [Date]

### Messaging
- [Learning 1]: [change made to which file]

### Profile
- [Learning 1]: [change made]

### Workflow
- [Learning 1]: [change made]

### Skipped (user declined)
- [Learning 1]: [reason]
```
