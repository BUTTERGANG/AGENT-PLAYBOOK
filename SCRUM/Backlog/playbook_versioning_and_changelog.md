---
status: backlog
priority: P2
agent_claimed: null
claimed_at: null
updated: 2026-08-19
---

# Playbook Versioning and Changelog

> **Repo:** AGENT-PLAYBOOK
> **Description:** Add a CHANGELOG.md and version number so teams can track which playbook version a project was scaffolded from

---

## Context

As the playbook evolves (new reference docs, refined phases, additional templates), knowing which version was current when a project started helps with consistency auditing. A versioned changelog also makes it easy to see what's changed between projects.

---

## Acceptance Criteria

- [ ] Add CHANGELOG.md with semantic versioning (v1.0.0 as initial)
- [ ] Each update gets an entry: date, version, what changed, why
- [ ] Include playbook version in scaffold script output if/when built
- [ ] Document versioning convention in CONTRIBUTING.md (or add CONTRIBUTING.md)

---

## Technical Notes

- Start at v1.0.0 for this initial commit
- Semver: major for structural phase changes, minor for new checks, patch for fixes