# Add / Update / Remove Leads

## add-update-remove-leads

### Adding Leads

1. Ask user to share leads (or receive from `discover-leads` workflow)
2. For each lead:
   a. Check if contact already exists in `{{CRM_TRACKER}}` lead list
   b. If exists: inform user, ask if they want to update
   c. If new: add to `{{CRM_TRACKER}}` with:
      - Contact name and email
      - Company and domain
      - Initial pipeline stage
      - Follow-up date (default: today)
      - Source (how the lead was found)

### Updating Leads

1. Look up lead in `{{CRM_TRACKER}}`
2. Update the specified fields
3. Add a note with the change reason

### Removing Leads

1. Confirm with user before removing
2. Archive (don't delete) the lead in `{{CRM_TRACKER}}`
3. Add a note with the removal reason

## discover-new-leads

Check `lead_preferences/lead-discovery.md` for discovery instructions:
1. Fetch leads/conversations from `{{NOTETAKER}}` and `{{EMAIL_INBOX}}` for the last 2 weeks
2. Filter for conversations relevant to the current pipeline
3. Cross-check against `{{CRM_TRACKER}}` to avoid duplicates
4. Present new leads to user for approval before adding
