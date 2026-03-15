# Poll New Activity

Scheduled action that checks for new incoming email replies and triggers follow-up cycles.

**Invocation:** This action runs on a schedule (e.g., every 15-60 minutes via cron/Paperclip). It does NOT need to be invoked manually.

## How It Works

1. **Read cursor** — Get `{{POLL_CURSOR}}` from `pipeline-config.md`. This is the datetime of the last poll.
2. **Fetch new messages from pollable channels** — Read all channels from `pipeline-config.md` → `## Channels` that have a **Polling** section defined. For each pollable channel, execute the channel's polling instructions to fetch new messages received after the cursor datetime. (Currently, email is the primary pollable channel — use its **Inbox Provider** to search for emails.)
3. **Build matching sets** — Query `{{ACTIONS_DB}}` once to get all executed outbound activities:
   ```
   SELECT DISTINCT contacts, body->>'fingerprint' as fingerprint
   FROM {{ACTIVITIES_TABLE}}
   WHERE activity_type LIKE 'send_%'
   AND execution_status = 'finished'
   AND created_at > now() - interval '90 days'
   ```
   From results, derive:
   - `known_emails` — all email addresses from `contacts` JSONB
   - `known_domains` — domains extracted from those emails (e.g., `jane@acme.com` → `acme.com`)
   - `known_fingerprints` — all fingerprint values from `body`
4. **Filter emails** — For each new email, apply in order:
   a. **Hygiene filter** — Skip automated/no-reply emails, marketing newsletters, calendar invites, internal team emails, and already-processed emails (sender + thread ID + timestamp match existing activity)
   b. **Local matching** (no MCP calls needed):
      - Sender email is in `known_emails` → RELEVANT
      - Email body contains a value from `known_fingerprints` → RELEVANT
      - Sender domain is in `known_domains` → LIKELY RELEVANT (colleague at a tracked company)
   c. **CRM fallback** — Only for emails that passed hygiene but matched nothing above: check if sender matches a lead in `{{CRM_TRACKER}}`. This should be rare (0-3 emails per cycle).
   d. Skip all remaining emails.
5. **For each relevant reply:**
   a. Identify the lead in `{{CRM_TRACKER}}` (if not already known from step 4b)
   b. Update the lead's follow-up date in `{{CRM_TRACKER}}` to today (moves them back into the due queue)
   c. Add a note in CRM: "Received reply on [date] — follow-up cycle triggered"
6. **Update cursor** — Set `{{POLL_CURSOR}}` in `pipeline-config.md` to the current datetime
7. **Trigger follow-up** — If any new replies were found, trigger the `/followup` command. Followup will fetch these leads (now due), gather context (including the new reply), and draft response activities for approval.

## Cursor Management

- The cursor is stored as `{{POLL_CURSOR}}` in the pipeline's `pipeline-config.md`
- Format: ISO 8601 datetime (e.g., `2026-03-14T10:30:00Z`)
- Initial value after onboarding: `Never` (first poll fetches last 24h of emails)
- After each successful poll: updated to current datetime

## Why This Approach

The Activities DB already stores every outbound email — including recipient addresses, company domains, and fingerprints. One SQL query builds a complete set of "known contacts" that catches ~95% of relevant replies locally, without hitting the CRM. This reduces per-poll MCP calls from ~N (one CRM call per email) to ~3 (1 Gmail + 1 Supabase + 0-3 CRM fallbacks).

Edge cases:
- **New pipeline with zero activities:** matching sets are empty, all emails fall through to CRM fallback — same behavior as before, no regression
- **Reply from a different email at the same company:** caught by domain matching
- **Forwarded intro:** fingerprint in quoted reply body catches it
- **Very old leads (>90 days):** fall through to CRM fallback, which is fine since these are rare

## Output

After each poll, log:
```
Poll completed at [datetime]
Emails scanned: [N]
Filtered by hygiene rules: [N]
Matched locally (email/fingerprint/domain): [N]
Checked via CRM fallback: [N]
Relevant replies found: [N]
Follow-up cycles triggered: [N]
Next poll cursor: [datetime]
```
