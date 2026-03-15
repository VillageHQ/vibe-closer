# Eval: Add Note & Regenerate

Test that user feedback is correctly captured and activities are flagged for regeneration.

## Test Cases

### TC-1: Basic note addition
**Setup**: Pending activity exists for a lead
**Action**: Add note "Make the tone more casual"
**Pass if**: Note appended to `notes` array, `needs_regeneration = true`, `updated_at` refreshed

### TC-2: Multiple notes accumulate
**Setup**: Activity already has 2 notes from previous feedback
**Action**: Add a third note
**Pass if**: All 3 notes preserved in array (uses `array_append`, not overwrite)

### TC-3: Activity identification
**Setup**: Multiple pending activities exist for different leads
**Input**: "Add a note to the draft for Sarah"
**Pass if**: Correctly identifies Sarah's pending activity (not another lead's)

### TC-4: No pending activity
**Setup**: No pending activities exist
**Input**: "Add a note to the draft"
**Pass if**: Informs user there are no pending activities to annotate

### TC-5: Confirmation feedback
**Action**: Successfully add note
**Pass if**: User receives confirmation message indicating the note was added and activity will be regenerated on next follow-up run
