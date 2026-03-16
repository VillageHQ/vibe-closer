<!-- EXAMPLE CONTENT — This file contains example content from the template.
     ALL content below must be replaced with real content during onboarding.
     Remove this marker once real content has been written. -->

# Partner Discovery

## Sources to Check

### 1. Meeting Notes via `{{NOTETAKER}}`
- Fetch conversations from the last 2-4 weeks
- Look for mentions of:
  - Customers asking about third-party integrations ("Can DevStack show our Datadog metrics?")
  - Complementary tools customers are using alongside DevStack
  - Competitor partnerships that customers reference
  - Feature requests that imply an integration need ("We want to see build status in the portal")
  - Customers mentioning they're evaluating new CI/CD, observability, or cloud tools

### 2. Email Inbox via `{{EMAIL_INBOX}}`
- Scan inbound emails from the last 2-4 weeks
- Look for:
  - Inbound partnership inquiries from tool vendors
  - Customers asking about specific integrations or tool compatibility
  - Unsolicited partnership proposals (signals market interest)
  - Conference or event invitations where potential partners will be present
  - Newsletter mentions of companies raising funding or launching integrations

### 3. Ecosystem & Market Research
- **Integration directories**: Check who's listed on Backstage plugin marketplace, GitHub Marketplace, Atlassian Marketplace, and similar developer tool ecosystems
  - Which monitoring tools have the most integrations?
  - Which CI/CD platforms are investing in partnership programs?
- **Competitor partnerships**: Who do Backstage, Port, Cortex, and OpsLevel partner with?
  - Check their integrations pages, partner listings, and case studies
  - If a competitor has a partnership we don't, that's a signal
- **Cloud marketplace listings**: Review AWS, GCP, and Azure marketplace developer tools categories
  - Who's listed? Who's doing well? Who's missing?
- **Conference attendee/sponsor lists**: Check KubeCon, DevOpsDays, PlatformCon speaker and sponsor lists
  - Companies investing in conference presence are usually open to partnerships
- **Industry analyst reports**: Gartner, Forrester, and RedMonk coverage of developer experience, platform engineering, and internal developer platforms
- **Product Hunt and HackerNews**: New developer tools launching in adjacent categories

### 4. Relationships via `{{FETCH_RELATIONSHIPS}}`
- Check for existing connections at target partner companies (especially IPP matches)
- Look for people who recently moved into BD, partnerships, or integrations roles at relevant companies
- Identify warm intro paths to known partner targets
- Check second-degree connections through investors, advisors, or board members

### 5. Social/News Monitoring
- Company announcements: new features, platform launches, funding rounds
- Hiring announcements: companies hiring for partnerships, integrations, or ecosystem roles (signals BD investment)
- LinkedIn posts from potential partners discussing developer experience, platform engineering, or integration strategy
- Twitter/X threads about developer tool consolidation or "internal developer platform" trends
- Blog posts from potential partners about their integration strategy or ecosystem vision

### 6. Customer Usage Data
- Review which third-party tools are most commonly mentioned in DevStack service docs
- Check which external URLs are most linked from within DevStack portals
- Look at customer feature requests related to integrations -- these signal organic partner demand

## Qualification Criteria

A partner prospect qualifies if:
- Matches at least one IPP in `profile/ipp.md` (monitoring/observability, CI/CD, or cloud marketplace)
- Serves a complementary function for the same customer segment (platform engineering teams, mid-market+ engineering orgs)
- Has a clear partnerships or integrations contact (email or LinkedIn)
- Is not already tracked in `{{CRM_TRACKER}}`
- Has sufficient maturity to formalize a partnership (established product, real customer base)
- Shows signals of partnership readiness (existing integrations page, partner program, BD team hiring)

## Output

For each discovered partner prospect, provide:
- Company name and domain
- Contact name, title, and email/LinkedIn
- Product/service (1-2 sentences)
- Source (where discovered: meeting notes, inbound email, market research, etc.)
- IPP match (which profile and why)
- Complementary fit (how their product enhances DevStack and vice versa)
- Recommended partnership type(s) (integration, co-sell, distribution, co-marketing)
- Warm intro path (if any, via {{FETCH_RELATIONSHIPS}})
- Recommended initial action (warm intro request, cold email, LinkedIn outreach)
- Priority (High/Medium/Low based on customer demand signals and strategic fit)
