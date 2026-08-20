---
status: backlog
priority: P1
agent_claimed: null
claimed_at: null
updated: 2026-08-19
---

# Template Files and Scaffolding Scripts

> **Repo:** AGENT-PLAYBOOK
> **Description:** Build a `templates/` directory with reusable file templates and a scaffold script that stamps out new repos

---

## Context

Currently the playbook is just a README checklist. To make it actionable, it should ship with template files that agents can copy into new repos: a SCRUM task file template, ADR template, CLAUDE.md template, .env.example template, PR template, and ideally a `scaffold.sh` script that creates the standard directory layout.

---

## Acceptance Criteria

- [ ] Task file template with YAML frontmatter matching the SCRUM pattern
- [ ] ADR template with Date/Decision/Reasoning/Applies To fields
- [ ] .env.example template with common vars (DATABASE_URL, SESSION_SECRET, OPENROUTER_KEY, etc.)
- [ ] CLAUDE.md template matching the AGENT-PLAYBOOK startup instructions
- [ ] PR template with description, checklist, and testing notes
- [ ] `scaffold.sh` script that creates SCRUM/* directories and populates template files

---

## Technical Notes

- Look at CLAUDE.md files across existing repos for the canonical pattern
- The scaffold script should be idempotent — running it twice shouldn't clobber existing content
- Use sed for variable substitution in templates