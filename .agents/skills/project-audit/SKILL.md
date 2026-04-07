---
name: project-audit
description: Perform a comprehensive strategic and technical audit of any project — software, business, product, or organizational. Use this skill whenever the user asks to analyze, audit, review, or evaluate a project. Triggers include mentions of SWOT/DAFO analysis, scalability review, technical debt assessment, architecture review, risk analysis, project health check, code quality audit, improvement suggestions, growth strategy, bottleneck identification, competitive analysis, or any request like 'analyze my project', 'review this codebase', 'what are the weaknesses of my project', 'how can I improve this', 'is this scalable', 'do a DAFO/SWOT', 'project diagnosis'. Also trigger when the user uploads project files, codebases, business plans, or documentation and asks for feedback, critique, or strategic advice. This skill should be used even for partial requests like 'find problems in my project' or 'what would you change'.
---

# Project Audit Skill

Perform a deep, structured audit of any project — delivering actionable insights across strategy, architecture, operations, and growth.

## Overview

This skill produces a comprehensive project audit report covering:

1. **DAFO/SWOT Analysis** — Strategic positioning
2. **Technical Architecture Review** — Design patterns, stack choices, dependencies
3. **Scalability Assessment** — Bottlenecks, growth limits, horizontal/vertical scaling
4. **Code Quality & Technical Debt** — Maintainability, testing, documentation
5. **Security & Compliance** — Vulnerabilities, data handling, regulatory gaps
6. **Team & Process** — Workflow efficiency, bus factor, knowledge silos
7. **Business & Market** — Competitive landscape, monetization, product-market fit
8. **Prioritized Improvement Roadmap** — Quick wins, medium-term, long-term

## Step 1: Gather Context

Before writing anything, understand what you're working with. The quality of the audit depends entirely on the depth of context gathered.

### If the user uploaded files (code, docs, plans):

1. Read the project structure first:
   ```
   view /mnt/user-data/uploads/
   ```
2. Identify the type of project: Is it a codebase? A business plan? A product spec? A mixed bag?
3. For codebases, examine in this order:
   - Root files: README, package.json / requirements.txt / Cargo.toml / go.mod (dependencies & project metadata)
   - Configuration: docker-compose, CI/CD configs, env files, infrastructure-as-code
   - Architecture: folder structure, entry points, routing, database schemas
   - Core business logic: the most important modules
   - Tests: coverage, testing strategy, test quality
4. For business/product projects, examine:
   - Executive summary or pitch deck
   - Market analysis documents
   - Financial projections
   - Team composition
   - Product roadmap

### If the user described the project verbally:

Ask focused questions to fill gaps. Don't overwhelm — pick the 3-4 most critical unknowns. Typical questions:

- What problem does this solve and for whom?
- What's the current tech stack / tools / infrastructure?
- How many users/customers do you have (or expect)?
- What's the team size and composition?
- What's your biggest concern or pain point right now?

### Context checklist (aim to know most of these before writing the audit):

- [ ] Project type (SaaS, API, mobile app, e-commerce, internal tool, non-profit initiative, etc.)
- [ ] Tech stack or tools used
- [ ] Current scale (users, data volume, transactions)
- [ ] Target scale (where they want to be in 1-2 years)
- [ ] Team size and roles
- [ ] Business model / funding situation
- [ ] Known pain points the user already suspects
- [ ] Competitive landscape (even a rough idea)

## Step 2: Perform the Analysis

Work through each section methodically. Be specific — generic advice is worthless. Every observation should reference something concrete from the project.

### 2.1 DAFO/SWOT Analysis

Present as a 2×2 matrix. Each quadrant should have 3-6 items, each with a one-line explanation of *why* it matters, not just what it is.

```
             | Positive              | Negative
─────────────┼───────────────────────┼──────────────────────
Internal     | FORTALEZAS            | DEBILIDADES
(controlable)| (Strengths)           | (Weaknesses)
─────────────┼───────────────────────┼──────────────────────
External     | OPORTUNIDADES         | AMENAZAS
(no control) | (Opportunities)       | (Threats)
```

Guidelines for high-quality DAFO:
- Strengths: What genuine competitive advantages exist? What's done well technically or strategically? What assets (team, tech, data, brand) are hard to replicate?
- Weaknesses: Be honest but constructive. What's fragile? What's missing? Where are the skill gaps?
- Opportunities: What market trends, technologies, or unmet needs could the project capitalize on? Think adjacent markets, partnerships, emerging tech.
- Threats: What external forces could hurt the project? Competitors, regulation, technology shifts, economic conditions, dependency risks (e.g., relying on a single platform's API).

Cross-reference the quadrants: A strength that addresses a threat is a strategic advantage. A weakness that intersects with a threat is a critical risk.

### 2.2 Technical Architecture Review

Evaluate the following dimensions (skip those that don't apply to non-software projects):

**Stack Assessment:**
- Are the technology choices appropriate for the problem domain and scale?
- Are there outdated or end-of-life dependencies?
- Is the stack too complex for the team size? Or too simple for the ambition?

**Design Patterns & Architecture:**
- Monolith vs microservices vs modular monolith — is the choice justified?
- How is state managed? Is there a clear data flow?
- Are there proper separation of concerns (API layer, business logic, data access)?
- How are cross-cutting concerns handled (logging, auth, error handling)?

**Dependency Health:**
- How many dependencies? Are they maintained?
- Are there known vulnerabilities (check if package-lock or similar exists)?
- Is there vendor lock-in risk?

### 2.3 Scalability Assessment

Evaluate both technical and organizational scalability:

**Technical Scalability:**
- Database: Can it handle 10x current load? 100x? What's the bottleneck (reads, writes, storage)?
- Compute: Is the application stateless? Can it scale horizontally?
- Caching strategy: Is there one? Is it appropriate?
- Network/API: Rate limiting, pagination, async processing for heavy operations?
- File storage / media: CDN? Object storage? Or everything on the same server?

**Organizational Scalability:**
- Can the codebase support multiple developers working simultaneously without constant conflicts?
- Is the deployment process automated? How long from commit to production?
- Is there documentation sufficient for onboarding a new team member in < 1 week?

**Scalability Score** — Assign a rough rating:
- 🟢 **Ready to scale** — Architecture supports 10x growth with minor changes
- 🟡 **Needs preparation** — Can handle 2-3x but will hit walls beyond that
- 🔴 **Scaling blockers** — Fundamental architectural changes needed before significant growth

### 2.4 Code Quality & Technical Debt

**Code Health Indicators:**
- Consistency: coding style, naming conventions, file organization
- Complexity: deeply nested logic, god classes/files, functions doing too many things
- Duplication: copy-paste patterns, lack of abstractions
- Error handling: are errors caught, logged, and handled gracefully?
- Testing: coverage level, test quality (do they test behavior or just implementation?), testing strategy (unit, integration, e2e)

**Technical Debt Map:**
Categorize debt by severity and effort:
- 🔴 **Critical debt** — Blocks feature development or causes incidents
- 🟡 **Moderate debt** — Slows the team but workable
- 🟢 **Low-priority debt** — Nice to fix but not urgent

### 2.5 Security & Compliance Review

- Authentication & authorization: How are users authenticated? Is there proper role-based access?
- Data handling: Is sensitive data encrypted at rest and in transit? PII handling?
- Input validation: SQL injection, XSS, CSRF protections?
- Secrets management: Are API keys, passwords etc. in environment variables or (worse) hardcoded?
- Regulatory: GDPR, SOC2, HIPAA — which apply and is the project compliant?
- Backup & disaster recovery: Is there a strategy?

### 2.6 Team & Process Analysis

- Development workflow: Git flow? Trunk-based? Code reviews? CI/CD?
- Bus factor: How many people understand each critical part? If key person leaves, what breaks?
- Communication: How does the team coordinate? Are there bottlenecks?
- Technical leadership: Is there someone making deliberate architectural decisions?

### 2.7 Business & Market Analysis

- **Product-Market Fit**: Is there evidence of real demand? Retention metrics? User feedback?
- **Competitive Landscape**: Who are the direct and indirect competitors? What's the differentiation?
- **Monetization**: Is the business model sustainable? What are the unit economics?
- **Growth Levers**: What are the most effective channels for growth? Is there a flywheel?
- **Risks**: Concentration risks (one big client, one distribution channel, one key partnership)?

### 2.8 Innovation & Future-Proofing

- Is the project positioned to adopt emerging technologies (AI, edge computing, etc.) where relevant?
- How modular is the system? Can components be replaced without rewriting everything?
- Is there a clear technical vision or is it driven purely by feature requests?

## Step 3: Build the Improvement Roadmap

Organize all recommendations into a prioritized roadmap. Group by time horizon and expected impact.

### Quick Wins (1-2 weeks, low effort, high impact)
Things that can be done immediately with minimal risk. Examples: adding environment variable management, setting up basic CI, fixing critical security issues, adding a README.

### Medium-Term (1-3 months)
Structural improvements that require planning. Examples: refactoring a monolith module, implementing caching, adding monitoring, improving test coverage to 60%+.

### Long-Term / Strategic (3-12 months)
Architectural changes, major tech migrations, organizational changes. Examples: migrating to microservices, building a data pipeline, hiring key roles, entering a new market.

For each recommendation, include:
- **What**: Clear description of the change
- **Why**: What problem it solves or what opportunity it enables
- **Impact**: High / Medium / Low
- **Effort**: High / Medium / Low
- **Dependencies**: What needs to happen first

## Step 4: Produce the Report

Read the reference file for output formatting guidance:
```
Read: references/output-format.md
```

The report should be produced as a well-structured document. The format depends on what the user asked for:

- If they want a quick overview: respond in chat with the DAFO matrix and top 5-10 recommendations
- If they want a full report: create a Markdown or DOCX file with all sections
- If they want to focus on a specific area (e.g., "just the scalability part"): go deep on that section only

Always end with a **TL;DR** section: 3-5 bullet points capturing the most critical findings and the single most important action to take next.

## Adaptation by Project Type

Not every section applies to every project. Adapt intelligently:

| Project Type | Focus Areas | Skip/Reduce |
|---|---|---|
| Early-stage startup | DAFO, PMF, MVP quality, scalability risks | Deep code review (it'll change) |
| Mature SaaS | Technical debt, scalability, security, team | Basic business model (already validated) |
| Open source library | API design, docs, community, compatibility | Business model, team process |
| Internal tool | UX, maintainability, bus factor | Market analysis, competition |
| Non-profit / NGO | Impact measurement, sustainability, partnerships | Monetization depth |
| Mobile app | UX, performance, platform-specific issues | Server scalability (unless backend-heavy) |

## Tone & Communication Style

- Be direct but respectful. The goal is to help, not to show how many problems you can find.
- Lead with strengths before weaknesses — people are more receptive to criticism after acknowledgment.
- Quantify where possible: "3 of 12 API endpoints lack input validation" is better than "some endpoints are insecure."
- Avoid jargon without explanation if the user seems non-technical.
- Frame weaknesses as opportunities: "The monolithic architecture currently works well for your team size, but investing in modular boundaries now will prevent painful refactoring when you scale past 5 developers."

## Language

Match the user's language. If they write in Spanish, produce the report in Spanish. If English, use English. The DAFO acronym is the Spanish equivalent of SWOT — use whichever matches the user's language.
