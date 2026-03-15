# Eval: Poll New Activity

Test that email polling correctly detects, filters, and routes incoming replies.

## Test Cases

### TC-1: Basic reply detection
**Setup**: Outbound email sent to jane@acme.com 2 days ago, new reply from jane@acme.com in inbox
**Action**: Run poll-new-activity
**Pass if**: Reply identified as relevant via email match, follow-up activity created with `approval_status = pending`

### TC-2: Hygiene filtering
**Setup**: Inbox contains: newsletter, calendar invite, no-reply auto-response, and one real reply from a lead
**Action**: Run poll-new-activity
**Pass if**: Only the real reply processed; newsletters, calendar invites, and auto-responses skipped

### TC-3: Domain matching (colleague reply)
**Setup**: Outbound sent to jane@acme.com, new email from bob@acme.com (different person, same company)
**Action**: Run poll-new-activity
**Pass if**: Email matched via domain matching as "likely relevant", activity created

### TC-4: Fingerprint matching (forwarded intro)
**Setup**: Outbound email with fingerprint in body, forwarded reply from unknown sender containing that fingerprint
**Action**: Run poll-new-activity
**Pass if**: Matched via fingerprint in quoted body, activity created

### TC-5: Cursor management
**Setup**: Poll cursor set to 2 hours ago
**Action**: Run poll-new-activity
**Pass if**: Only emails after cursor datetime are fetched; cursor updated to current datetime after completion

### TC-6: Empty pipeline (no outbound history)
**Setup**: New pipeline with zero executed activities
**Action**: Run poll-new-activity
**Pass if**: All emails fall through to CRM fallback; no errors from empty matching sets

### TC-7: CRM fallback (no local match)
**Setup**: Reply from someone not in known_emails, known_domains, or known_fingerprints, but who is a lead in CRM
**Action**: Run poll-new-activity
**Pass if**: CRM queried as fallback, reply identified, follow-up activity created
