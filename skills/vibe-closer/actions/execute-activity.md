# Execute Activity

Run approved activities.

## Prerequisites

Only execute activities where:
- `approval_status = 'approved'`
- `execution_status = 'pending'`

## Execution by Type

### send_email
1. Update `execution_status` to `running`
2. Use `{{EMAIL_SENDING}}` to draft the email:
   - To: recipients from body
   - Subject: from body
   - Body: message from body
3. **P0**: Create as draft (user sends manually)
4. **P1**: Send directly via MCP
5. Update `execution_status` to `finished`

### send_linkedin
1. Update `execution_status` to `running`
2. Present the message and LinkedIn profile URL
3. Tell user: "Send this on LinkedIn" with a CTA to open the profile
4. If browser automation available: automate the send
5. Wait for user confirmation that it was sent
6. Update `execution_status` to `finished`

### update_followup_date
1. Update `execution_status` to `running`
2. Use `{{CRM_TRACKER}}` to update the follow-up date field
3. Add a note in CRM with the reason
4. Update `execution_status` to `finished`

### change_pipeline_stage
1. Update `execution_status` to `running`
2. Use `{{CRM_TRACKER}}` to update the status field
3. Add a note in CRM with the reason
4. Update `execution_status` to `finished`

### add_lead
1. Update `execution_status` to `running`
2. Use `{{CRM_TRACKER}}` to add the new lead
3. Set initial fields (stage, follow-up date, source)
4. Update `execution_status` to `finished`

## Error Handling

If execution fails:
- Log the error
- Keep `execution_status` as `running` (don't mark finished)
- Inform the user with the error details
- Suggest manual fallback
