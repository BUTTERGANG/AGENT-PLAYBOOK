---
status: backlog
priority: P1
agent_claimed: null
claimed_at: null
updated: 2026-08-19
---

# Phase 5 Lessons Log — Seed with Real Project Learnings

> **Repo:** AGENT-PLAYBOOK
> **Description:** Seed the Lessons Learned Log with actual quick fixes and ADRs from BUTTERGANG project history

---

## Context

Phase 5 of the playbook has empty tables. Without real entries, the lessons-learned mechanism is dead on arrival. Seed it with actual issues and decisions captured across existing repos (k9-overwatch, CIVIC-DUTY, MINDGAMES, VBT-PROTOTYPE, MORAN-WEBSITE, etc.) so new agents see the pattern and continue it.

---

## Acceptance Criteria

- [ ] Add 5+ Quick Fix entries from real project issues (auth, deployment, API, infrastructure categories)
- [ ] Add 3+ ADR entries for structural decisions that affect future builds
- [ ] Format matches the phase 5 table schema exactly
- [ ] Each entry is honest and specific enough to actually prevent a repeat mistake

---

## Technical Notes

- Common themes: Neon connection pooling, Replit preview port config, Playwright timeout tuning, env var management across profiles
- ADR examples: 'Default to Neon for all persistence', 'Use pnpm workspaces for monorepos', 'Always use spawn for multiprocessing with PyMuPDF'