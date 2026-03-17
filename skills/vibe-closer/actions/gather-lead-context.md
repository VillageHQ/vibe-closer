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
   - **Full message content** for each thread (do not summarize — preserve the complete body text of each message)
   - **Thread ID** (Gmail thread ID) for each thread — needed for in-thread replies
   - **Participants with roles** (from, to, cc) for each thread — needed for smart recipient population
   - Action items and next steps extracted verbatim from thread content

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
   - Comprehensive summaries with all substantive detail (topics, decisions, specific numbers/dates mentioned)
   - Action items, commitments, and follow-up owners from meetings
   - Sentiment signals: buying indicators, objections, competitive mentions, timeline/budget references

6. **Relationships** via `{{FETCH_RELATIONSHIPS}}`:
   - Mutual connections
   - Warm introduction paths

7. **Workspace messaging context** (from local workspace files):
   - **Matched ICP section** from `profile/icps.md` — include the full ICP block (description, pain points, pitch, objections & responses, buying signals) for the matched ICP. If multiple ICPs match, include all matched sections.
   - **Relevant email templates** from the channel's Templates file (as defined in `pipeline-config.md` → `## Channels` → `### {channel}` → `Templates`) — include templates that apply to the matched ICP and the lead's current pipeline stage
   - **Tone guidelines** from `messaging-guidelines/tone.md` — include the full file content (voice, do/don't, phrases, examples)
   - **Channel guidelines** from the channel's Guidelines file (as defined in `pipeline-config.md` → `## Channels` → `### {channel}` → `Guidelines`) — include the full file content for the channel(s) that will be used for outreach
   - **Sequence flow rules** from `sequence-flow.md` — include the execution sequence and frequency rules
   - **Case studies** from `profile/case-studies.md` (if it exists) — include relevant case studies that match the lead's ICP or industry

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
  - Status: [awaiting reply / closed / ongoing]
  - Full message content:
    > [Paste the FULL body of each message in the thread, most recent first. Preserve the original text — do NOT summarize. For multi-message threads, separate each message with a horizontal rule and include the sender and date for each. Strip only signatures and legal disclaimers.]
  - Action items / next steps: [Extract verbatim from the thread — include who owes what and any deadlines mentioned]

### Meeting History
For each meeting involving this contact:
- **[Date] — [Meeting title]** (Attendees: [list])
  - Comprehensive summary: [Detailed narrative covering ALL topics discussed, decisions made, concerns raised, and context shared. Include specific numbers, names, dates, and details mentioned — do not reduce to topic labels. Aim for a thorough account that captures the full substance of the conversation.]
  - Key quotes / commitments: [Verbatim excerpts that reveal intent, interest level, objections, or enthusiasm. Include the speaker for each quote.]
  - Action items: [Verbatim, with owners and deadlines if stated]
  - Signals & sentiment: [Buying signals, hesitations, objections, competitive mentions, internal stakeholders referenced, budget discussions, or timeline indicators]

### CRM Notes & Activity Log
- [Date]: [Full note text — do not summarize]
- Pipeline stage history: [Stage] → [Stage] (date of each transition)

### Key Selling Points
- [Point 1 based on ICP match and pain points identified above]
- [Point 2 based on company context or meeting insights]

### Warm Paths
- [Connection 1]: [relationship context, how they know the lead, strength of connection]

### Workspace Messaging Context

#### Matched ICP
[Paste the FULL ICP block from profile/icps.md for each matched ICP — description, pain points, pitch, objections & responses, buying signals. Do NOT summarize.]

#### Relevant Templates
[Paste the relevant email/LinkedIn templates from the channel's Templates file for the matched ICP and current stage. Include the full template text.]

#### Tone Guidelines
[Paste the full content of messaging-guidelines/tone.md — voice, do/don't rules, phrases, examples.]

#### Channel Guidelines
[Paste the full content of the relevant channel's Guidelines file — structure, timing, personalization requirements, threading rules.]

#### Sequence Flow
[Paste the execution sequence and frequency rules from sequence-flow.md.]

#### Case Studies
[Paste relevant case studies from profile/case-studies.md that match this lead's ICP or industry. "No case studies file found" if not available.]
```
