# Lead Discovery

## Sources to Check

1. **Meeting notes** via `{{NOTETAKER}}`:
   - Fetch conversations from the last 2 weeks
   - Look for: mentions of engineering leaders struggling with observability, data team leads discussing metric consistency, anyone asking about analytics infrastructure
   - Key phrases to scan for: "metrics," "dashboards," "Datadog," "monitoring costs," "data governance," "single source of truth," "dbt models"

2. **Email inbox** via `{{EMAIL_INBOX}}`:
   - Scan inbound emails from the last 2 weeks
   - Look for: demo requests, product questions, intro emails from mutual connections, replies to content or social posts
   - Prioritize: anyone who mentions a specific pain point (observability sprawl, metric inconsistency, compliance reporting)

3. **Relationships** via `{{FETCH_RELATIONSHIPS}}`:
   - Check for new connections relevant to ICPs
   - Prioritize connections who are VP/Director+ at Series B-D companies with 200-1000 employees
   - Flag mutual connections that could provide warm intro social proof

4. **LinkedIn activity** (manual or via notifications):
   - Prospects who engaged with Metricflow content (likes, comments, shares)
   - ICP-matching contacts who posted about observability, metrics, or data infrastructure challenges
   - New role announcements (someone just became VP Eng or Head of Data = fresh mandate, open to new tools)

5. **Job postings** (periodic scan):
   - Companies hiring for: "Analytics Engineer," "Data Infrastructure," "Observability Engineer," "Head of Data"
   - These roles signal investment in the metrics/data layer — strong buying signal

## Qualification Criteria

A lead qualifies for outreach if they meet ALL of the following:

### Must-Have
- Matches at least one ICP in `profile/icps.md` (role, company size, industry)
- Has a valid contact method (work email or LinkedIn profile)
- Is not already tracked in `{{CRM_TRACKER}}`
- Company has 100+ employees (below this, deal size is typically too small)

### Scoring (prioritize leads with higher scores)

| Signal | Points |
|--------|--------|
| Matches ICP 1 (VP Eng at SaaS) | +3 |
| Matches ICP 2 (Data Lead at Fintech) | +3 |
| Matches ICP 3 (Platform Lead) | +2 |
| Raised funding in last 6 months | +2 |
| Hiring data/infra roles | +2 |
| Mutual connection exists | +2 |
| Engaged with Metricflow content | +3 |
| Posted about relevant pain points | +1 |
| Company uses dbt, Snowflake, or Datadog (tech stack fit) | +1 |
| Recently promoted into current role (<6 months) | +1 |

**Priority tiers:**
- **High (8+ points)**: Reach out within 24 hours
- **Medium (5-7 points)**: Reach out within 3 business days
- **Low (3-4 points)**: Add to queue, reach out within 1 week

### Disqualifiers
- Company has fewer than 50 employees (too early stage)
- Prospect is an individual contributor without budget influence
- Company is a direct competitor or in a non-target industry (e.g., government, education)
- Already in active outreach sequence (check `{{CRM_TRACKER}}`)
- Previously marked as "Closed Lost" less than 90 days ago

## Output

For each discovered lead, provide:
- **Contact**: name, title, email, LinkedIn URL
- **Company**: name, size (employees), funding stage, industry
- **Source**: where discovered (meeting notes, email, relationship network, LinkedIn)
- **ICP match**: which profile (1, 2, or 3) and why
- **Qualification score**: points breakdown from scoring table above
- **Personalization hooks**: 2-3 specific details to reference in outreach (e.g., "just raised Series C," "hiring 3 analytics engineers," "posted about Datadog costs last week")
- **Mutual connections**: list any shared connections from `{{FETCH_RELATIONSHIPS}}`
- **Recommended action**: which email template to use, whether to include warm intro social proof, suggested timing
