# Lead Discovery — Hiring

## Sources to Check

### 1. **Team Referrals** — Start Here
- Ask each team member: "Who from your previous company would you want to work with again?"
- Use {{FETCH_RELATIONSHIPS}} to map second-degree connections from current team to target candidates
- Referral candidates convert 2-3x better than cold outreach
- Run a monthly referral prompt: share the ICP and ask team to surface names

### 2. **LinkedIn Search**
- Search by title + current company from ICP target employers list
- Filter: location, years of experience, skills
- Look for "Open to Work" signals (green banner, career interests set)
- Check who's recently updated their profile (often signals they're looking)
- Monitor job changes at competitor companies (people who just joined might know others who didn't get an offer)

### 3. **GitHub / Open Source**
- Search for contributors to relevant open-source projects
- Look at commit frequency, code quality, and technical depth
- Check profile for location, current employer, contact info
- Contributors to tools you use are especially good fits (they know the domain)

### 4. **Meeting Notes** via {{NOTETAKER}}
- Scan for: "you should talk to...", "I know someone who...", recommendations
- Conference meetings often surface candidate leads
- Advisor meetings frequently include referral opportunities

### 5. **Email Inbox** via {{EMAIL_INBOX}}
- Inbound applications and interest expressions
- Referrals forwarded by team members or advisors
- Replies to content or job postings

### 6. **Community Sourcing**
- CNCF Slack, relevant Discord servers, subreddits (r/devops, r/golang, r/typescript)
- Conference attendee lists (KubeCon, React Conf, NeurIPS)
- Meetup groups in relevant technical areas
- Hacker News "Who wants to be hired?" monthly threads

### 7. **Competitor Monitoring**
- Track layoffs at companies in your space — those engineers understand the domain
- Monitor LinkedIn for departures from target companies
- Set alerts for relevant company news (reorgs, pivots, acquisitions)

## Qualification Criteria

A candidate qualifies if:
- Matches an ICP profile (role, seniority, technical background)
- Has relevant domain experience or transferable skills
- Has a reachable contact method (email or LinkedIn)
- Not currently at a company we have a no-poach agreement with
- Not already in pipeline

## Disqualification Criteria
- Requires visa sponsorship (if not offered)
- Seniority mismatch (junior applying for staff role or vice versa)
- Already declined within the last 6 months
- Currently at a direct competitor with non-compete concerns

## Prioritization
1. **Tier 1**: Referral + ICP match → reach out immediately
2. **Tier 2**: Strong ICP match + "Open to Work" signals → reach out this week
3. **Tier 3**: ICP match + cold → batch and reach out weekly
4. **Tier 4**: Adjacent match → add to nurture list

## Discovery Enrichment
For each candidate:
1. Match to ICP → determines pitch angle and role
2. Check for warm paths via {{FETCH_RELATIONSHIPS}}
3. Find email via {{EMAIL_ENRICHMENT}} or LinkedIn
4. Research: recent projects, posts, talks, open-source contributions
5. Score: Referral + ICP Match + Activity Signals = priority
