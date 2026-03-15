---
description: "Check for new email replies and trigger follow-up cycles"
---

# Poll New Activity

Invoke the `vibe-closer` skill using the Skill tool, then execute this workflow:

## Phase 1: Load Polling Process
Read `actions/poll-new-activity.md` for the full polling process.


## Phase 2: Check for Replies
Fetch new emails since the last poll cursor and match against known outbound activity.

## Phase 3: Update Leads
For each relevant reply, update the lead's follow-up date and add a CRM note.

## Phase 4: Update Cursor
Set `{{POLL_CURSOR}}` in `pipeline-config.md` to the current datetime.

## Phase 5: Trigger Follow-up
If any new replies were found, trigger the `/followup` command to process the updated leads.

## Final: Log

Log a summary of this entire execution using `actions/add-log.md`.
