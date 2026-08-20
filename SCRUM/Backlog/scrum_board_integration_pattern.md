---
status: backlog
priority: P2
agent_claimed: null
claimed_at: null
updated: 2026-08-19
---

# SCRUM Board Integration Pattern

> **Repo:** AGENT-PLAYBOOK
> **Description:** Document how SCRUM boards work across BUTTERGANG repos — reference guide for agents starting on any project

---

## Context

Every BUTTERGANG repo now has a uniform SCRUM board (Backlog/Working/Archive + CLAUDE.md + Sprint_View.md). New agents need to know the protocol: how to claim tasks, what the YAML frontmatter means, the vault lock mechanism, shutdown protocol, and how sprint planning flows from BUTTERGANG/SCRUM central.

---

## Acceptance Criteria

- [ ] Write a SCRUM.md reference doc explaining the per-repo board pattern
- [ ] Include vault lock semantics, task lifecycle table, and agent claiming rules
- [ ] Document the central-to-per-repo sprint planning flow
- [ ] Link to a concrete example (e.g., CIVIC-DUTY/SCRUM/CLAUDE.md) for reference
- [ ] Save as `templates/SCRUM_REFERENCE.md` so it ships with the playbook

---

## Technical Notes

- The pattern is consistent across all 37+ repos — extract the canonical version
- Vault lock: if vault_lock: true in CLAUDE.md frontmatter, no agent should claim tasks
- Central sprint view lives at BUTTERGANG/SCRUM/05_Dashboards/Sprint_View.md