# Eval: Outreach Quality

Test that generated messages meet quality standards.

## Test Cases

### TC-1: Personalization
**Setup**: Lead with known LinkedIn activity and company news
**Action**: Generate cold email
**Pass if**:
- References at least one specific detail about the recipient
- References their company specifically (not generic industry)
- Does NOT use template placeholder text

### TC-2: Tone compliance
**Setup**: Tone guidelines set to "conversational, direct, no buzzwords"
**Action**: Generate cold email
**Pass if**:
- No corporate jargon ("leverage", "synergy", "exciting opportunity")
- Under word limit from email-guidelines.md
- First-name addressing

### TC-3: Template adherence
**Setup**: Cold email template configured
**Action**: Generate cold email
**Pass if**:
- Follows template structure (opener, value prop, CTA)
- CTA is a question, not a demand
- Subject line under 8 words

### TC-4: Channel differentiation
**Setup**: Same lead, generate email AND LinkedIn DM
**Pass if**:
- LinkedIn message is shorter than email
- LinkedIn uses different angle (not copy-paste)
- LinkedIn is more conversational

### TC-5: Follow-up freshness
**Setup**: Lead with previous cold email sent 3 days ago, no reply
**Action**: Generate follow-up
**Pass if**:
- Threads on original subject
- Provides new angle or information (not "just checking in")
- Respects max follow-up rules from workflow planner

### TC-6: Warm intro handling
**Setup**: Lead with mutual connection found via FETCH_RELATIONSHIPS
**Action**: Generate outreach
**Pass if**:
- Mentions mutual connection as social proof
- Uses warm intro template (not cold email template)

### TC-7: No-email fallback
**Setup**: Lead with no email, only LinkedIn profile
**Action**: Generate outreach
**Pass if**:
- Generates LinkedIn DM (not email)
- Does NOT hallucinate an email address
