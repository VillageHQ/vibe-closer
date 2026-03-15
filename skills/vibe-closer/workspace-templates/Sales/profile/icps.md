# Ideal Customer Profiles

## ICP 1: VP/Head of Engineering at Series B-D SaaS Companies

### Description
- **Roles**: VP Engineering, Head of Engineering, Director of Engineering, CTO (at smaller orgs)
- **Company size**: 200-1000 employees, Series B through Series D
- **Industry**: B2B SaaS, developer tools, cloud infrastructure
- **Tech stack signals**: Running Datadog + Grafana + custom dashboards, or migrating off legacy monitoring. Using dbt, Snowflake, or BigQuery for analytics.
- **Budget authority**: Owns or influences infrastructure tooling budget ($50K-$250K ACV range)

### Pain Points
- **Observability sprawl**: Paying for 3-5 overlapping tools (Datadog for APM, Grafana for dashboards, Amplitude for product analytics, custom SQL for business metrics). No single source of truth.
- **Metric inconsistency**: Engineering and product teams define "active users" or "latency p99" differently across tools. Debugging cross-team discrepancies wastes hours weekly.
- **Scaling pain**: Monitoring costs balloon as they scale. Datadog bills are growing 40%+ QoQ and the CFO is asking questions.
- **Developer productivity**: Engineers spend 15-20% of time building and maintaining internal dashboards and metric pipelines instead of shipping product.
- **Incident response**: When something breaks, teams scramble across 4 different tools to correlate metrics, adding 20+ minutes to MTTR.

### Pitch
"Metricflow gives your engineering team a single metrics layer that sits on top of your existing data stack. Instead of maintaining definitions in Datadog, Grafana, and Amplitude separately, you define metrics once and query them everywhere. Teams we work with — like [reference similar-stage SaaS company] — typically cut their observability tooling costs by 30% and reduce cross-team metric discrepancies to zero within 90 days."

### Objections & Responses
| Objection | Response |
|-----------|----------|
| "We already have Datadog" | "Metricflow isn't a replacement — it's the layer that makes Datadog (and everything else) actually consistent. Most of our customers keep Datadog for APM and use Metricflow as the canonical metric definitions that feed into all their tools." |
| "We're building this internally" | "We hear that a lot. The teams that come to us usually started that project 6-12 months ago and found it's a full-time job to maintain. How many engineers are working on your internal metrics layer today?" |
| "Not a priority right now" | "Totally fair. Out of curiosity, how are you handling the metric consistency problem today when engineering and product disagree on a number?" |
| "Need to involve the data team" | "Absolutely — the data team is usually our biggest champion. Happy to loop them in or send over a technical brief they can review async." |

### Buying Signals
- Job postings mentioning "observability," "metrics platform," or "data infrastructure"
- Recently raised Series B/C (flush with cash, scaling engineering team)
- Blog posts or conference talks about monitoring challenges
- Hiring a Head of Data or Analytics Engineering role
- Complaints about Datadog pricing on Twitter/LinkedIn

---

## ICP 2: Data/Analytics Lead at Fintech Companies

### Description
- **Roles**: Head of Data, Director of Analytics, Analytics Engineering Manager, VP Data
- **Company size**: 100-500 employees
- **Industry**: Fintech, payments, banking-as-a-service, insurance tech
- **Tech stack signals**: dbt + Snowflake/BigQuery, Looker or Tableau for BI, likely dealing with SOC 2 and regulatory reporting requirements
- **Budget authority**: Owns data tooling budget or reports directly to CTO/CFO who does

### Pain Points
- **Regulatory metric accuracy**: Financial regulators require exact, auditable metric definitions. When "transaction volume" means something different in the BI dashboard vs. the compliance report, it creates audit risk.
- **Metric governance**: No single owner of metric definitions. Product, finance, and compliance each maintain their own calculations in different tools. Reconciliation is a monthly fire drill.
- **Audit trail requirements**: SOC 2 and financial audits require proving that reported metrics are computed consistently. Today this is manual documentation that's always out of date.
- **Analyst bottleneck**: Business stakeholders constantly request "one more cut" of data. The analytics team is buried in ad-hoc requests because there's no self-serve metric catalog.
- **dbt model sprawl**: Hundreds of dbt models with duplicated logic. Different analysts created different versions of the same metric, and nobody knows which is canonical.

### Pitch
"Metricflow gives your data team a governed metrics layer with full audit trails — which, in fintech, isn't optional. You define each metric once with version-controlled logic, and every downstream consumer (Looker, compliance reports, internal dashboards) pulls from the same source. Your team at [company] is probably spending significant cycles reconciling numbers across tools before each reporting period — we eliminate that entirely."

### Objections & Responses
| Objection | Response |
|-----------|----------|
| "We use dbt for our metrics layer" | "dbt is great for transformations, and Metricflow actually integrates natively with dbt. The gap is that dbt defines how data is transformed, but doesn't enforce how metrics are consumed downstream. Metricflow closes that loop." |
| "Security and compliance concerns" | "We're SOC 2 Type II certified, and we can deploy in your VPC. Several fintech companies including [reference] run their compliance metrics through Metricflow specifically because of the audit trail." |
| "Our analysts already have their workflows" | "We're not replacing their tools — we're giving them a catalog so they stop rebuilding the same metrics. Most analysts tell us they get 10+ hours/week back." |
| "We need to evaluate this against competitors" | "Happy to support that. We typically suggest a 2-week proof of concept on a single metric domain — that gives your team real data to compare against." |

### Buying Signals
- Job postings for "Analytics Engineer" or "Data Governance" roles
- Recent SOC 2 certification or compliance audit mentions
- Rapid growth (funding round, headcount expansion)
- Public data team blog posts about "single source of truth" or metric standardization
- Using dbt with growing model counts (200+ models)

---

## ICP 3: Platform Engineering Lead at Growth-Stage Tech Companies

### Description
- **Roles**: Head of Platform, Staff/Principal Engineer (platform focus), Director of Developer Experience
- **Company size**: 300-1500 employees
- **Industry**: Marketplace, e-commerce, logistics tech
- **Tech stack signals**: Kubernetes, microservices architecture, internal developer platform, likely evaluating or using Backstage

### Pain Points
- **Internal tooling tax**: Platform team maintains custom metric aggregation pipelines that break every time a new service is deployed
- **Cross-service observability**: With 50+ microservices, no unified view of business metrics that span multiple services
- **Developer self-serve**: Engineers can't answer basic metric questions without filing a ticket to the data or platform team

### Pitch
"Metricflow plugs into your existing platform and gives every engineering team self-serve access to consistent metrics across all your services. No more custom aggregation pipelines to maintain, no more tickets to the data team for basic questions."

### Objections & Responses
| Objection | Response |
|-----------|----------|
| "We're building an internal developer portal" | "Great — Metricflow has a Backstage plugin and APIs that integrate directly into your portal. We become the metrics layer inside your existing platform, not another tool to manage." |
| "Our platform team is stretched thin" | "That's exactly why — Metricflow eliminates the metric pipeline maintenance your platform team is doing today. Typical integration takes 2-3 days, not months." |
