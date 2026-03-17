# Gather Lead Context

## fetch-basic-lead-context

Quick context for table views. Pull from `{{CRM_TRACKER}}` only:
- Contact name
- Contact email
- Company name and domain
- Pipeline status
- Follow-up date

## fetch-full-lead-context

Deep context for activity generation. Aggregate from all sources:

1. **CRM history** via `{{CRM_TRACKER}}`:
   - All notes and activity log
   - Pipeline stage history
   - Custom fields

2. **Email history** via `{{EMAIL_INBOX}}`:
   - Last 10 email threads with this contact
   - Summary of each thread (dates, topics, action items, next steps)
   - **Thread ID** (Gmail thread ID) for each thread — needed for in-thread replies
   - **Participants with roles** (from, to, cc) for each thread — needed for smart recipient population

3. **Profile enrichment** via `{{PROFILE_ENRICHMENT}}`:
   - LinkedIn profile summary
   - Role, seniority, responsibilities
   - Recent posts or activity

4. **Company info** via `{{WEBSITE_CRAWLING}}`:
   - What the company does
   - Recent news or funding
   - Relevance to our offering

5. **Meeting history** via `{{NOTETAKER}}`:
   - Recent meeting transcripts involving this contact
   - Action items and commitments from meetings

6. **Relationships** via `{{FETCH_RELATIONSHIPS}}`:
   - Mutual connections
   - Warm introduction paths

## research-lead

When a lead is new and not yet connected, follow the research strategy defined in `lead_preferences/research-lead.md` (or `partner_preferences/research-lead.md` for BD pipelines).

This file contains the ordered research steps and any custom research preferences the user configured during onboarding. Execute each step using the specified MCPs, then cross-reference findings with `profile/icps.md` to identify relevant pain points and personalization hooks.

## Output Format

Each section must include enough detail that someone reading ONLY this context could draft a personalized follow-up without accessing any other source. If a source is unavailable or returns no data, include the section header with "Source not configured" or "No data found."

```markdown
## Lead Context: [Name] at [Company]

### Summary
[2-3 sentence overview of relationship status and next steps]

### ICP Match Analysis
- **Matched ICP**: [ICP name from profile/icps.md, or "No match"]
- **Match signals**: [Bullet list of matching criteria — industry, company size, role, pain points]
- **Relevance to our offering**: [1-2 sentences on why this lead matters]

### People
- [Contact 1]: [role] — [seniority, responsibilities, LinkedIn summary, notable background]
- [Contact 2]: [role] — [key info]

### Email History
For each of the last 10 threads (most recent first):
- **[Date] — [Subject line]** ([direction: inbound/outbound])
  - Thread ID: [Gmail thread ID — required for in-thread replies]
  - From: [sender name <email>]
  - To: [recipient names and emails, comma-separated]
  - CC: [cc'd names and emails, comma-separated, or "none"]
  - Key content: [2-4 sentence summary of substance — what was discussed, proposed, or asked]
  - Action items / next steps: [verbatim if present]
  - Status: [awaiting reply / closed / ongoing]

### Meeting History
For each meeting involving this contact:
- **[Date] — [Meeting title]** (Attendees: [list])
  - Discussion points: [bullet list of topics covered]
  - Key quotes / commitments: [verbatim excerpts that reveal intent, interest level, or objections]
  - Action items: [verbatim, with owners and deadlines if stated]

### CRM Notes & Activity Log
- [Date]: [Full note text — do not summarize]
- Pipeline stage history: [Stage] → [Stage] (date of each transition)

### Key Selling Points
- [Point 1 based on ICP match and pain points identified above]
- [Point 2 based on company context or meeting insights]

### Warm Paths
- [Connection 1]: [relationship context, how they know the lead, strength of connection]
```
