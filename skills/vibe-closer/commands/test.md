---
description: "Run end-to-end integration test of the full pipeline flow"
argument-hint: "[from-scratch|with-config|with-workspace] [--cleanup]"
---

# End-to-End Pipeline Test

Run every user-facing command in a realistic journey, validate DB and CRM state at each checkpoint, and use browser automation to test the HTML Activity Viewer.

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

## Test Mode

This command uses a `**Test Mode**: true` flag in `pipeline-config.md`. When active, outreach sends (`send_{channel}`) are skipped during execution — everything else (DB writes, CRM updates, context gathering, scoring, approval) runs for real. See `commands/execute-approved-activity.md` Phase 3 for details.

## Pre-flight: Parse Arguments

If `$ARGUMENTS` contains `--cleanup`, skip to the [Cleanup](#cleanup) section.

Otherwise, ask the user which test level to run:

1. **From scratch** — Run `/onboard` to create a new test workspace, then run the full flow
2. **With ready config** — Copy a workspace template to `.tests/`, fill config with real providers, then run
3. **With ready workspace** — Point to an existing workspace, seed test leads, and run commands/actions only

If `$ARGUMENTS` specifies a level (`from-scratch`, `with-config`, `with-workspace`), use it without asking.

---

## Phase 0: Setup

### Test workspace

1. Create `.tests/pipeline-test-{unix_timestamp}/` in the plugin root directory
2. Record the test start timestamp for checkpoint validation later

### Level-specific setup

**From scratch:**
- The `/onboard` command in Phase 1 will create the workspace content

**With ready config:**
- Ask the user which pipeline type (Sales, Hiring, Fundraising, BD, JobSearch, VCDealFlow)
- Copy the corresponding template from `skills/vibe-closer/workspace-templates/{type}/` into the `.tests/pipeline-test-{ts}/` directory
- Ask the user for MCP provider values to fill `pipeline-config.md` (or reuse from an existing pipeline if they have one — read its `pipeline-config.md` and copy provider values)
- Fill all `{{VARIABLE}}` placeholders in `pipeline-config.md`

**With ready workspace:**
- Ask the user for the path to their existing workspace
- Use that workspace directly (do NOT create under `.tests/`)

### Connectivity checks

1. Read `pipeline-config.md` → resolve `{{ACTIONS_DB}}` and `{{CRM_TRACKER}}`
2. Test DB: `SELECT 1` via `{{ACTIONS_DB}}`
3. Test CRM: list or whoami via `{{CRM_TRACKER}}`
4. If either fails → report error and stop

### Enable test mode

Add `- **Test Mode**: true` to the `## Settings` section of `pipeline-config.md` (create the section if it doesn't exist). This flag is checked by `execute-approved-activity.md` to skip outreach sends.

---

## Phase 1: `/onboard` (from-scratch only)

*Skip this phase for with-config and with-workspace levels.*

Run the `/onboard` command targeting the `.tests/pipeline-test-{ts}/` directory. Let it walk through the full onboarding flow.

### Checkpoints

**CP1a**: Verify `pipeline-config.md` exists in the test workspace with all `{{VARIABLE}}` placeholders filled
**CP1b**: Query `{{ACTIONS_DB}}` — verify `{{ACTIVITIES_TABLE}}` and `{{LOGS_TABLE}}` exist (`SELECT 1 FROM {{ACTIVITIES_TABLE}} LIMIT 0`)
**CP1c**: Verify `CLAUDE.md` and `AGENTS.md` exist in the workspace with a Quick Reference section

Log pass/fail for each checkpoint.

---

## Phase 2: `/discover-leads`

Run the `/discover-leads` command. This searches configured sources (email, meetings, relationships) for potential leads.

Since this is a test environment, discovery may or may not find leads from the user's connected sources. Handle both cases:

1. If leads are found: auto-approve 2 of them, tag with `[VC-TEST-{ts}]` in their CRM notes field
2. If no leads are found: seed 2 test leads directly in CRM via `{{CRM_TRACKER}}`:
   - Lead 1: company = "[TEST] Alpha Corp", contact = "Test Alpha", follow-up date = today, notes = `[VC-TEST-{ts}]`
   - Lead 2: company = "[TEST] Beta Inc", contact = "Test Beta", follow-up date = today, notes = `[VC-TEST-{ts}]`
   - Use the first pipeline stage from `pipeline-config.md` → `## Pipeline Stages`

### Checkpoints

**CP2a**: `/discover-leads` command completed without error
**CP2b**: At least 2 leads exist in CRM tagged `[VC-TEST-{ts}]` with `followup_date = today`

---

## Phase 3: `/followup` (first run)

Run the `/followup` command. This triggers the full multi-phase flow:
- Phase 1: Check regeneration requests (none yet)
- Phase 2: Fetch due leads → should pick up the test leads
- Phase 3: Gather context → generate activities → score → store in DB
- Phase 4: Present for approval → opens the HTML Activity Viewer

**Important:** When `/followup` reaches Phase 4 and opens the HTML Activity Viewer, do NOT let it proceed to Phase 5 (execution). The test takes over to perform browser-based interactions first.

### Checkpoints

**CP3**: Query `{{ACTIONS_DB}}`:
```sql
SELECT id, activity_type, approval_status, execution_status, confidence_score, contacts
FROM {{ACTIVITIES_TABLE}}
WHERE created_at > '[test_start_timestamp]'
```
Verify: at least 2 activities exist with `approval_status = 'pending'` and `execution_status = 'pending'`

---

## Phase 4: Browser Automation — HTML Viewer

The Activity Viewer should be open in the browser from Phase 3. Use browser automation tools (`mcp__claude-in-chrome__*` or `mcp__plugin_playwright_playwright__*`) to interact with it.

**If browser automation tools are not available:** Fall back to direct DB operations for the approval steps, skip UI-specific checkpoints (CP4a), and log a warning: "Browser automation unavailable — skipping viewer interaction tests."

### Test 4a: View Scoring Breakdown

1. Find the first test activity row (search for text matching the test lead names)
2. Click the confidence score number in that row
3. Verify the scoring modal opens and contains bars for all 5 dimensions: personalization_quality, icp_match, timing_appropriateness, messaging_guideline_adherence, workflow_compliance
4. Close the modal

**CP4a**: Scoring modal rendered with all 5 scoring dimensions visible

### Test 4b: Add Note (first activity)

1. On the first test activity row, click the "Other" dropdown button (⋯ or similar)
2. Click "Add note / replan"
3. Type into the note textarea: "[TEST] Make the tone more casual and shorter"
4. Click the confirm/save button
5. Wait for the toast notification

**CP4b**: Query DB for the first test activity:
```sql
SELECT notes, needs_regeneration FROM {{ACTIVITIES_TABLE}} WHERE id = '[first_activity_id]'
```
Verify: `notes` array contains the test note text, `needs_regeneration = true`

### Test 4c: Edit Activity Body (second activity)

1. On the second test activity row, click the Edit button (✏)
2. In the side panel that slides in:
   - Modify the subject field: append " - Updated" to the existing subject
   - Modify the body text: change some words in the message
3. Click "Save changes" (NOT the approve button)
4. Wait for the toast notification

**CP4c**: Query DB for the second test activity:
```sql
SELECT body, body_history FROM {{ACTIVITIES_TABLE}} WHERE id = '[second_activity_id]'
```
Verify: `body` contains the updated subject with " - Updated", `body_history` has at least one entry with the previous body version and a timestamp

### Test 4d: Edit + Approve (second activity)

1. The edit panel should still be open for the second activity
2. Click the "✓ Approve" button in the edit panel footer
3. Wait for the toast notification

**CP4d**: Query DB for the second test activity:
```sql
SELECT approval_status, body, body_history FROM {{ACTIVITIES_TABLE}} WHERE id = '[second_activity_id]'
```
Verify: `approval_status = 'approved'`

---

## Phase 5: `/followup` (second run — regeneration)

The first test activity has `needs_regeneration = true` from the note added in Phase 4b.

Run `/followup` again. Phase 1 should detect the regeneration request, pick up the notes, and regenerate the activity.

### Checkpoints

**CP5a**: Query DB:
```sql
SELECT id, approval_status, needs_regeneration, created_at
FROM {{ACTIVITIES_TABLE}}
WHERE created_at > '[test_start_timestamp]'
ORDER BY created_at
```
Verify:
- The original first activity now has `approval_status = 'rejected'`
- A new activity exists for the same lead with `needs_regeneration = false`

### Approve the regenerated activity

Open the Activity Viewer again (it should open as part of `/followup` Phase 4). Using browser automation:

1. Find the regenerated activity row (new activity for the first test lead)
2. Click the ✓ Approve button directly from the table row
3. Wait for the toast notification

**CP5b**: Query DB for the regenerated activity:
```sql
SELECT approval_status FROM {{ACTIVITIES_TABLE}} WHERE id = '[regenerated_activity_id]'
```
Verify: `approval_status = 'approved'`

---

## Phase 6: `/execute-approved-activity`

Run the `/execute-approved-activity` command.

Test Mode is active → outreach sends are skipped and marked `execution_status = 'finished'`. CRM operations (follow-up date updates, stage changes) execute normally.

### Checkpoints

**CP6a**: Query DB:
```sql
SELECT id, execution_status FROM {{ACTIVITIES_TABLE}}
WHERE approval_status = 'approved'
  AND created_at > '[test_start_timestamp]'
```
Verify: all approved test activities have `execution_status = 'finished'`

**CP6b**: Query CRM for the test leads (search by `[VC-TEST-{ts}]` notes tag). Verify their follow-up dates have moved forward from today.

---

## Phase 7: `/poll-new-activity`

Run the `/poll-new-activity` command. Since outreach was mocked (no actual emails sent), no real replies exist. This validates the command runs cleanly with empty results.

### Checkpoints

**CP7a**: Command completed without error (no crash, no unhandled exception)

**CP7b**: Read `pipeline-config.md` and check `{{POLL_CURSOR}}`. Verify it was updated to a timestamp near the current time (within the last few minutes).

---

## Phase 8: `/learn`

Run the `/learn` command. It should find finished activities with:
- `body_history` (the edit made in Phase 4c/4d on the second activity)
- `notes` (the note added in Phase 4b on the first activity, now on the rejected activity — the regenerated one was approved without edits)

The test should auto-accept all proposed learnings (respond "all" when asked which learnings to incorporate).

### Checkpoints

**CP8a**: Query DB:
```sql
SELECT id, learnings FROM {{ACTIVITIES_TABLE}}
WHERE execution_status = 'finished'
  AND learnings IS NOT NULL
  AND learnings != ''
  AND created_at > '[test_start_timestamp]'
```
Verify: at least one activity has a populated `learnings` field

**CP8b**: Check the workspace for a new learning report file at `progress/learnings/` (list files, look for one with today's date)

**CP8c**: Read `pipeline-config.md` and check `{{LAST_LEARNING_DATE}}`. Verify it was updated to today's date.

---

## Phase 9: `/re-index`

Run the `/re-index` command. After `/learn` may have created new files (the learning report), re-index should detect them and update the workspace index.

### Checkpoints

**CP9a**: Command completed and reported results (either "N added, M removed" or "index is up to date")

**CP9b**: Read `CLAUDE.md` and `AGENTS.md` in the workspace — verify they exist and contain a Quick Reference section. If `/learn` created files, verify they appear in the index.

**CP9c**: Read `pipeline-config.md` and check `{{LAST_REINDEX_CHECK}}`. Verify it was updated to a recent timestamp.

---

## Phase 10: `/view-logs`

Run the `/view-logs today` command. This queries the logs table filtered to today's entries.

### Checkpoints

**CP10**: Verify the log output contains entries for the commands run during the test. Check for these `action_name` values:
- `discover-leads` (or equivalent lead seeding)
- `followup` (should appear at least twice — initial + regeneration run)
- `execute-approved-activity`
- `poll-new-activity`
- `learn`
- `re-index`

---

## Phase 11: Test Report

Present the full test report to the user:

```
E2E Test Results — [ISO timestamp]
Pipeline: [name] | Level: [from-scratch|with-config|with-workspace]
Workspace: [path]
Duration: [X min]

Command Coverage: 9/9

Phase 1 — /onboard:
  [PASS/FAIL/SKIP] CP1a: Workspace created with pipeline-config.md
  [PASS/FAIL/SKIP] CP1b: DB tables created
  [PASS/FAIL/SKIP] CP1c: CLAUDE.md + AGENTS.md created

Phase 2 — /discover-leads:
  [PASS/FAIL] CP2a: Discovery ran without error
  [PASS/FAIL] CP2b: Test leads in CRM with today's followup date

Phase 3 — /followup (initial):
  [PASS/FAIL] CP3:  Activities generated for test leads

Phase 4 — HTML Viewer:
  [PASS/FAIL/SKIP] CP4a: Scoring modal renders 5 dimensions
  [PASS/FAIL] CP4b: Add note → needs_regeneration set
  [PASS/FAIL] CP4c: Edit body → body_history updated
  [PASS/FAIL] CP4d: Edit + approve → approved with edits

Phase 5 — /followup (regeneration):
  [PASS/FAIL] CP5a: Old activity rejected, new created
  [PASS/FAIL] CP5b: Regenerated activity approved via viewer

Phase 6 — /execute-approved-activity:
  [PASS/FAIL] CP6a: Activities executed (mocked sends)
  [PASS/FAIL] CP6b: CRM follow-up dates updated

Phase 7 — /poll-new-activity:
  [PASS/FAIL] CP7a: Poll ran without error
  [PASS/FAIL] CP7b: POLL_CURSOR updated

Phase 8 — /learn:
  [PASS/FAIL] CP8a: Learnings extracted from edits/notes
  [PASS/FAIL] CP8b: Learning report created
  [PASS/FAIL] CP8c: LAST_LEARNING_DATE updated

Phase 9 — /re-index:
  [PASS/FAIL] CP9a: Re-index completed
  [PASS/FAIL] CP9b: CLAUDE.md + AGENTS.md updated
  [PASS/FAIL] CP9c: LAST_REINDEX_CHECK updated

Phase 10 — /view-logs:
  [PASS/FAIL] CP10: All command logs present

Result: [N]/21 PASSED | [M] FAILED | [K] SKIPPED
```

If any checkpoints failed, list each failure with:
- The checkpoint ID
- What was expected
- What was actually found (DB query result, error message, etc.)

---

## Phase 12: Cleanup {#cleanup}

If running via `--cleanup` argument, or after the test report:

Ask the user: "Test complete. Would you like me to clean up test data?"

**If yes (or if invoked via `--cleanup`):**

1. **Remove test activities from DB:**
   ```sql
   DELETE FROM {{ACTIVITIES_TABLE}}
   WHERE created_at > '[test_start_timestamp]'
     AND (contacts::text LIKE '%[TEST]%' OR summary LIKE '%[TEST]%')
   ```

2. **Remove test log entries from DB:**
   ```sql
   DELETE FROM {{LOGS_TABLE}}
   WHERE created_at > '[test_start_timestamp]'
   ```

3. **Remove test leads from CRM:** Search for leads with `[VC-TEST-{ts}]` in notes, delete or archive them

4. **Remove Test Mode flag:** Edit `pipeline-config.md` to remove the `- **Test Mode**: true` line

5. **Optionally delete test workspace:** If the workspace was created under `.tests/`, ask the user if they want to delete the `.tests/pipeline-test-{ts}/` directory

**If no:**

1. Remove the Test Mode flag from `pipeline-config.md` (always — prevents accidental mock execution on next real run)
2. Warn the user: "Test data preserved. Run `/test --cleanup` to remove it later. Make sure to clean up before running real commands — test leads in CRM will appear in your next `/followup` run."

---

## Notes

- All test data uses the `[VC-TEST-{ts}]` marker in CRM notes for identification and cleanup
- The Test Mode flag is always removed at the end (even if cleanup is declined) to prevent accidental mock execution
- If the test crashes mid-run, run `/test --cleanup` to remove the flag and any partial test data
- Browser automation falls back to direct DB operations if tools are unavailable
- The test workspace under `.tests/` is gitignored to prevent leaking environment variables
