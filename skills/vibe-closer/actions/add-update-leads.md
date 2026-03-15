# Add / Update / Remove Leads

## add-update-remove-leads

### Adding Leads

1. Ask user to share leads (or receive from `discover-leads` workflow)
2. For each lead, add to `{{CRM_TRACKER}}` with the fields below. The CRM handles deduplication natively — if the CRM returns a duplicate error, inform the user and ask if they want to update the existing record instead.
   Fields:
      - Contact name and email
      - Company and domain
      - Initial pipeline stage
      - Follow-up date (default: today)
      - Source (how the lead was found)

### Updating Leads

1. Look up lead in `{{CRM_TRACKER}}`
2. Update the specified fields (values may come from either a generated activity's workflow determination or a skip result's `recommended_followup_date` / `recommended_stage`)
3. Add a note with the change reason (e.g., "Follow-up date set to [date]: manual outreach detected on [date]" or "Prospect requested delay — revisit in [timeframe]")

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
