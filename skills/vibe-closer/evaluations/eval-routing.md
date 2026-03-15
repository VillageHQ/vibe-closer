# Eval: Workflow Routing

Test that user intents are correctly routed to action files.

## Test Cases

### TC-1: Get due leads
**Input**: "Who needs follow-up today?"
**Expected**: Routes to `actions/get-leads.md` → `fetch-due-leads`
**Pass if**: CRM queried with follow-up date <= today filter

### TC-2: Get all leads
**Input**: "Show me all my leads"
**Expected**: Routes to `actions/get-leads.md` → `fetch-all-leads`
**Pass if**: CRM queried without date filter

### TC-3: Add leads
**Input**: "Add John Smith from Acme Corp to my pipeline"
**Expected**: Routes to `actions/add-leads.md`
**Pass if**: Checks CRM for existing, then adds if new

### TC-4: Draft outreach
**Input**: "What should I send to Sarah at TechCo?"
**Expected**: Routes to `actions/generate-lead-activity.md`
**Pass if**: Gathers context first, then generates activity

### TC-5: View pending
**Input**: "Show me drafts waiting for approval"
**Expected**: Routes to `actions/view-pending-activity.md`
**Pass if**: Queries DB with approval_status = pending

### TC-6: Approve activity
**Input**: "LGTM on all drafts"
**Expected**: Routes to `actions/approve-activity.md` → bulk approval
**Pass if**: Lists activities, asks confirmation, updates all

### TC-7: Execute
**Input**: "Send the approved emails"
**Expected**: Routes to `actions/execute-activity.md`
**Pass if**: Only executes approved+pending activities

### TC-8: Performance
**Input**: "How's my pipeline doing?"
**Expected**: Routes to `actions/evaluate-performance.md`
**Pass if**: Generates metrics report

### TC-9: Learn
**Input**: "What can we improve?"
**Expected**: Routes to `actions/learn.md`
**Pass if**: Analyzes activity history, proposes updates

### TC-10: Ambiguous intent
**Input**: "Help me with this lead"
**Expected**: Asks clarifying question
**Pass if**: Does NOT assume an action, asks what the user wants to do

### TC-11: Add note to pending activity
**Input**: "I want to add a note to the draft for Sarah"
**Expected**: Routes to `actions/add-note.md`
**Pass if**: Identifies the pending activity for Sarah, accepts note text, flags activity with `needs_regeneration = true`

### TC-12: Update workspace content
**Input**: "Help me update my messaging guidelines"
**Expected**: Routes to `actions/update-content.md`
**Pass if**: Enters content builder mode, reads existing workspace files, asks targeted questions about what to change

### TC-13: Poll for new replies
**Input**: "Check if I got any new replies"
**Expected**: Routes to `actions/poll-new-activity.md`
**Pass if**: Reads poll cursor, fetches emails since cursor, filters and matches against known contacts
