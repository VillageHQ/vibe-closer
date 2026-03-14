# Poll New Activity

Scheduled action that checks for new incoming email replies and triggers follow-up cycles.

**Invocation:** This action runs on a schedule (e.g., every 15-60 minutes via cron/Paperclip). It does NOT need to be invoked manually.

## How It Works

1. **Read cursor** — Get `{{POLL_CURSOR}}` from `config.md`. This is the datetime of the last poll.
2. **Fetch new emails** — Use `{{EMAIL_INBOX}}` to search for emails received after the cursor datetime.
3. **Filter relevant replies** — For each new email:
   a. Check if the sender or thread matches a lead tracked in `{{CRM_TRACKER}}`
   b. Skip emails that are not replies to pipeline-related threads (use fingerprint matching if available)
   c. Skip internal emails, newsletters, and automated messages
4. **For each relevant reply:**
   a. Identify the lead in `{{CRM_TRACKER}}`
   b. Create an activity in `{{ACTIONS_DB}}` with:
      - `activity_type`: depends on context (likely `send_email` for a follow-up reply)
      - `approval_status`: `pending`
      - `execution_status`: `pending`
      - `summary`: "New reply from [name] — needs follow-up"
      - `full_lead_context`: include the reply content and thread summary
      - `scheduled_date`: now (immediate follow-up cycle)
   c. Update the lead's follow-up date in `{{CRM_TRACKER}}` to today
   d. Add a note in CRM: "Received reply on [date] — follow-up cycle triggered"
5. **Update cursor** — Set `{{POLL_CURSOR}}` in `config.md` to the current datetime
6. **Trigger follow-up** — If any new replies were found, trigger the `/followup` command for those specific leads

## Cursor Management

- The cursor is stored as `{{POLL_CURSOR}}` in the pipeline's `config.md`
- Format: ISO 8601 datetime (e.g., `2026-03-14T10:30:00Z`)
- Initial value after setup: `Never` (first poll fetches last 24h of emails)
- After each successful poll: updated to current datetime

## Email Filtering Rules

Include:
- Direct replies to threads where we sent outreach
- New emails from contacts in `{{CRM_TRACKER}}`
- Forwarded intros mentioning tracked leads

Exclude:
- Automated/no-reply emails
- Marketing newsletters
- Calendar invites
- Internal team emails
- Emails already processed (sender + thread ID + timestamp match existing activity)

## Output

After each poll, log:
```
Poll completed at [datetime]
Emails scanned: [N]
Relevant replies found: [N]
Follow-up cycles triggered: [N]
Next poll cursor: [datetime]
```
