# Email Templates

## Cold Email — ICP 1: VP/Head of Engineering at SaaS

**Subject**: your observability stack

**Body**:
```
Hi {{first_name}},

[Personalization hook: mention specific observability pain from their job posting, eng blog, or tech stack — e.g., "Noticed your team posted about migrating off a custom monitoring pipeline" or "Saw you're hiring for a Senior Data Infra role — sounds like the metrics layer is getting attention."]

We built Metricflow to solve exactly that — a single metrics layer that sits on top of your existing stack (Datadog, Grafana, dbt, whatever you're running) so your teams stop maintaining duplicate metric definitions across tools.

[Reference a mutual connection if one exists: "I think you're connected with [name] — their team's been using it for about 6 months."]

Worth a 15-min look?

{{sender_name}}
```

---

## Cold Email — ICP 2: Data/Analytics Lead at Fintech

**Subject**: metric definitions for compliance

**Body**:
```
Hi {{first_name}},

[Personalization hook: reference their recent funding round, SOC 2 certification, or a data team blog post — e.g., "Congrats on the Series C — guessing the compliance reporting requirements are scaling with you."]

One thing we keep hearing from fintech data teams: metric reconciliation before audits is a nightmare when definitions live in dbt, Looker, and spreadsheets simultaneously.

Metricflow gives you a governed metrics layer with version-controlled definitions and full audit trails. You define "transaction volume" once, and every downstream consumer — compliance reports, dashboards, exec reviews — pulls from the same logic.

Would it be useful to see how [reference similar-stage fintech] set this up? Takes about 15 minutes.

{{sender_name}}
```

---

## Cold Email — ICP 3: Platform Engineering Lead

**Subject**: metrics across your services

**Body**:
```
Hi {{first_name}},

[Personalization hook: reference their microservices architecture, Backstage adoption, or internal platform blog post — e.g., "Read your post about building an internal developer portal — curious how you're handling cross-service metrics."]

Most platform teams we talk to are maintaining custom metric aggregation pipelines that break every time a new service ships. Metricflow replaces that with a self-serve metrics layer that integrates into your existing platform (we have a Backstage plugin and standard APIs).

Typical integration is 2-3 days, not a quarter-long project.

Quick call to see if it fits your stack?

{{sender_name}}
```

---

## Follow-Up — No Reply (send 3 business days after initial email)

**Subject**: Re: [original subject]

**Body**:
```
Hi {{first_name}},

Not trying to clog your inbox — just wanted to share one thing that might be relevant.

[New value angle — choose one based on ICP:]
- ICP 1: "We just published benchmarks showing teams with a unified metrics layer reduce MTTR by 25% because they're not correlating data across 4 tools during incidents."
- ICP 2: "A fintech data team told us they went from 3 days of metric reconciliation before each audit to about 20 minutes after standardizing on Metricflow."
- ICP 3: "One platform team eliminated 6 custom metric pipelines in their first month — their on-call engineers were thrilled."

If timing's off, no worries at all. Happy to reconnect whenever this becomes relevant.

{{sender_name}}
```

---

## LinkedIn Connection Request Note

```
Hi {{first_name}} — I work on analytics infrastructure at Metricflow. [Reference their recent post, talk, or company news — e.g., "Liked your post about observability costs"]. Would love to connect.
```

---

## LinkedIn DM (after connection accepted, or as InMail)

```
Hey {{first_name}} — thanks for connecting.

[Reference something specific about them: a post, a talk, their company's growth, a job posting on their team.]

We're working with a few [industry] engineering teams on unifying metric definitions across their stack — curious if that's a problem you're seeing too, or if you've already solved it internally?

Either way, happy to share what we're learning.
```

---

## Warm Intro — Forwardable Email

**To send to your mutual connection:**

**Subject**: intro to {{prospect_first_name}}?

**Body**:
```
Hey {{connection_name}},

Hope you're doing well. Quick ask — would you be open to introducing me to {{prospect_first_name}} at {{prospect_company}}?

Here's context you can forward:

---

Hi {{prospect_first_name}},

{{connection_name}} suggested we connect. I lead outreach at Metricflow — we build a metrics layer that helps engineering and data teams standardize metric definitions across their stack.

I noticed {{prospect_company}} is [reference specific detail: scaling the data team, dealing with multiple monitoring tools, etc.], and thought there might be a fit.

Would you be open to a quick 15-minute call to see if it's relevant?

{{sender_name}}

---

Totally fine if the timing isn't right — appreciate you either way.

{{sender_name}}
```

---

## Post-Meeting Follow-Up

**Subject**: Metricflow follow-up — [key topic discussed]

**Body**:
```
Hi {{first_name}},

Thanks for the time today. Good conversation — here's what I took away:

- [Key pain point they described, in their words]
- [Specific use case or metric domain they want to start with]
- [Any concerns or requirements they raised]

Next steps we discussed:
- [ ] [Action item 1 — e.g., "I'll send over the technical architecture doc"]
- [ ] [Action item 2 — e.g., "You'll loop in your analytics lead for a deeper dive"]
- [ ] [Action item 3 — e.g., "We'll set up a POC environment by Friday"]

I'll follow up [specific day] to get the next call on the calendar. In the meantime, here's [relevant resource: case study, docs link, or architecture diagram].

{{sender_name}}
```

---

## Hyperpersonalization Hooks Reference

Use these as starting points for the personalization line in each template:

| Signal Source | Hook Example |
|--------------|--------------|
| Job posting for data/infra role | "Noticed you're hiring a [role] — sounds like the metrics infrastructure is getting investment." |
| Recent funding round | "Congrats on the [Series X] — scaling the data stack is usually right behind scaling the team." |
| Eng blog / tech blog post | "Read your team's post on [topic] — [specific observation or question about it]." |
| Conference talk | "Caught your talk at [event] about [topic] — [reference a specific point they made]." |
| Datadog/observability job posting | "Saw your team's looking for someone with Datadog experience — curious how you're handling metric consistency across tools." |
| LinkedIn post about data challenges | "Your post about [topic] resonated — we hear the same thing from [similar companies]." |
| Mutual connection | "I think you're connected with [name] — their team at [company] has been using Metricflow for [use case]." |
| Company growth (headcount) | "Looks like [company] has grown a lot this year — metric sprawl usually scales with team size." |
