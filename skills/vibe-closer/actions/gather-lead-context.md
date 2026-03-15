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

```markdown
## Lead Context: [Name] at [Company]

### Summary
[2-3 sentence overview of relationship status and next steps]

### People
- [Contact 1]: [role] — [key info]
- [Contact 2]: [role] — [key info]

### Recent Interactions
- [Date]: [Channel] — [Summary, action items, next steps]

### Key Selling Points
- [Point 1 based on ICP match]
- [Point 2 based on pain points]

### Warm Paths
- [Connection 1]: [relationship context]
```
