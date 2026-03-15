# Add Note & Regenerate

Add user feedback to a pending activity and flag it for regeneration.

## Steps

1. Present a small textbox: "What feedback do you have for this activity?"
2. Accept the user's note text
3. Update the activity in `{{ACTIONS_DB}}`:
   - Append the note to the `notes` array: `SET notes = array_append(notes, '[note text]'), needs_regeneration = true, updated_at = now() WHERE id = [activity_id]`
   - This preserves all previous notes — they accumulate over time
4. Confirm to user: "Note added. This activity will be regenerated on next follow-up run."
