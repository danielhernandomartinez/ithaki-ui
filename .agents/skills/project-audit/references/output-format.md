# Output Format Reference

## Chat Response (Quick Audit)

When the user wants a quick overview or asks casually ("what do you think of my project?"), respond directly in chat with this structure:

### Structure:
1. **One-paragraph project summary** — Show you understand what the project is
2. **DAFO/SWOT Matrix** — Use a visual table format
3. **Top Findings** — 5-10 most important observations, mixing positives and negatives
4. **Top 5 Recommendations** — Ordered by impact/effort ratio
5. **TL;DR** — 3-5 lines, the absolute essentials

Keep it under 1500 words for chat responses.

---

## Full Report (Markdown File)

When the user requests a comprehensive audit or the project is complex enough to warrant one, create a `.md` file.

### File naming:
`audit-[project-name]-[YYYY-MM-DD].md`

### Structure:

```markdown
# Project Audit: [Project Name]
**Date:** [Date]  
**Auditor:** Claude (AI-assisted analysis)  
**Scope:** [What was analyzed — codebase, business plan, full project, etc.]

---

## Executive Summary
[2-3 paragraphs: What the project is, its current state, and the 3 most critical findings]

## 1. DAFO/SWOT Analysis

### Strategic Matrix

| | Positive | Negative |
|---|---|---|
| **Internal** | **Strengths** | **Weaknesses** |
| | [items] | [items] |
| **External** | **Opportunities** | **Threats** |
| | [items] | [items] |

### Strategic Cross-Analysis
[How strengths can counter threats, how weaknesses amplify threats, etc.]

## 2. Technical Architecture
[Findings organized by: Stack, Design Patterns, Dependencies]

## 3. Scalability Assessment
[Current capacity, bottlenecks, scaling score with justification]

## 4. Code Quality & Technical Debt
[Debt map, quality metrics, specific examples]

## 5. Security & Compliance
[Findings by category, severity ratings]

## 6. Team & Process
[Workflow analysis, bus factor, recommendations]

## 7. Business & Market
[PMF evidence, competitive position, growth analysis]

## 8. Innovation & Future-Proofing
[Technology trends, modularity assessment, technical vision]

## 9. Improvement Roadmap

### Quick Wins (1-2 weeks)
| # | Action | Impact | Effort |
|---|--------|--------|--------|
| 1 | [action] | High | Low |

### Medium-Term (1-3 months)
| # | Action | Impact | Effort | Dependencies |
|---|--------|--------|--------|-------------|
| 1 | [action] | High | Medium | [deps] |

### Long-Term (3-12 months)
| # | Action | Impact | Effort | Dependencies |
|---|--------|--------|--------|-------------|
| 1 | [action] | High | High | [deps] |

## 10. TL;DR
- [Critical finding 1]
- [Critical finding 2]
- [Critical finding 3]
- **Next step:** [The single most important action to take right now]
```

---

## Word Document (DOCX)

If the user explicitly asks for a Word document or needs a formal deliverable (for stakeholders, investors, board), produce a DOCX using the docx skill. Use the same structure as the Markdown report but with proper Word formatting: cover page, table of contents, headers, page numbers, and professional styling.

---

## Focused Report

When the user asks for a specific section only (e.g., "just analyze scalability"), go deep on that section. Include 2-3x the detail you would in the full report for that section. Still include a brief DAFO relevant to that dimension and a focused set of recommendations.

---

## Severity & Priority Indicators

Use consistent indicators throughout:

**Severity:**
- 🔴 Critical — Immediate action needed, blocks progress or poses active risk
- 🟡 Moderate — Should be addressed soon, causes friction
- 🟢 Low — Nice to have, minor improvement

**Confidence:**
- **High confidence** — Based on direct evidence in the project files
- **Medium confidence** — Based on patterns and common issues for this project type
- **Low confidence** — Inference based on limited information, flagged as assumption

Always label your confidence level when making claims that go beyond what's directly observable in the project materials. This builds trust and helps the user calibrate how seriously to take each finding.
