---
status: backlog
priority: P1
agent_claimed: null
claimed_at: null
updated: 2026-08-19
---

# Reference Docs Refresh Cycle

> **Repo:** AGENT-PLAYBOOK
> **Description:** Keep Reference Docs section current — add new tools, remove deprecated ones, update URLs

---

## Context

The Reference Docs section is the first thing an agent reads when starting a new project. If a doc link is stale, the agent wastes time guessing. If a new core tool (Supabase, Clerk, Railway, etc.) emerges without being listed, the agent won't use it.

---

## Acceptance Criteria

- [ ] Audit all existing links — verify they still resolve and point to the right version
- [ ] Research tools added to the BUTTERGANG stack since last update (check API-REFERENCE repo)
- [ ] Add any new core tools with a brief why-this-matters note
- [ ] Remove or archive tools that are no longer in active use

---

## Technical Notes

- Check API-REFERENCE at /home/alex/API-REFERENCE for the full tools catalog
- Each tool should have: name, URL, one-liner about when to reach for it