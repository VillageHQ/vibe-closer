# Future Plans

Living record of planned improvements, known gaps, and deferred work.
When building new features, check this file for related items and update as work is completed.

---

## Testing Capabilities

### V2 Test Scenarios (deferred from /test v1)

These were identified during the e2e test audit but deferred from the initial `/test` command:

#### 1. `/discover-leads` deep testing
- Lead discovery across all 3 sources (NOTETAKER, EMAIL_INBOX, FETCH_RELATIONSHIPS)
- Deduplication accuracy: same person found in email + meetings → single lead
- User partial approval: approve 2 of 5 discovered leads → only those 2 added
- Zero results handling: no leads found → clean "no results" message

#### 2. `/poll-new-activity` with real replies
- Seed a real outbound email (not mocked), wait for a test reply
- Fingerprint matching: `<!-- vc:UUID -->` in email body correctly matched to activity
- Domain matching fallback when fingerprint not found
- Multiple replies to same activity → each adds note, single followup trigger
- POLL_CURSOR initialization when no cursor exists yet

#### 3. Skip detection in `/followup`
- Manual outreach detected: user sent email without vc: fingerprint → activity skipped
- Prospect requested delay: "check back in 2 weeks" parsed → correct followup date
- Pending meeting next steps: meeting within 5 business days → skip with reason
- Workflow pause stage: pipeline stage marked as "pause" → skip
- Mixed results: 1 skipped + 1 generated + 1 auto-approved in same run

#### 4. Stale activity recovery
- Activity stuck in `execution_status = 'running'` for > 30 minutes
- Phase 1 of `/execute-approved-activity` resets it to 'pending'
- Recovered count reported correctly in execution summary

#### 5. Bulk operations in HTML viewer
- Select multiple activities via checkboxes
- "Approve selected" button → all selected approved in single batch
- "Deselect all" → selection cleared
- Bulk approve with mixed confidence scores

#### 6. Viewer dropdown actions
- Snooze activity: 1 day, 3 days, 1 week, custom
  - Verify system note added with correct snooze duration
  - Verify needs_regeneration = true
  - Verify next /followup respects the snooze date
- Remove from sequence
  - Verify system note added
  - Verify needs_regeneration = true
  - Verify next /followup removes the followup date from CRM

#### 7. Multi-channel test
- Generate activities for both email + LinkedIn in same followup run
- Verify channel-specific fingerprint methods (HTML comment vs metadata)
- Verify channel-specific body schemas
- Execute both: email via Gmail MCP (mocked), LinkedIn as manual action
- Verify manual_actions list contains LinkedIn message ready to copy

#### 8. Auto-approve threshold boundary
- Activity scoring exactly at AUTO_APPROVE_THRESHOLD (e.g., 75/100)
- Score = threshold → should auto-approve
- Score = threshold - 1 → should remain pending
- Threshold = 0 → all auto-approved
- Threshold = 100 → none auto-approved

#### 9. Error handling & recovery
- DB unavailable mid-followup → graceful failure with log
- CRM unavailable during lead fetch → error reported, not silent
- Channel provider fails during execution → activity reset to pending, added to failures list
- Partial execution: 3 succeed, 1 fails → status = 'partial' in log

#### 10. `/learn` deep testing
- Multiple activities with different edit patterns → consolidated learnings
- User declines some learnings → "Skipped" section with reasons
- Profile learning: user describes product differently than icps.md
- Workflow learning: user consistently changes follow-up timing
- File update verification: messaging-guidelines, tone.md, sequence-flow.md all updated correctly

---

## Other Planned Work

(Add new sections here as work is identified)
