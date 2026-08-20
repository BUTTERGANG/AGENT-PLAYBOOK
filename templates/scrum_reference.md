# SCRUM Board Reference — BUTTERGANG Repo Pattern

Every project repo in BUTTERGANG follows this uniform SCRUM board structure. Agents read this before claiming their first task.

---

## Directory Layout

```
SCRUM/
├── Backlog/       — Tasks not yet started (status: backlog or sprint)
├── Working/       — Tasks being worked on (status: in-progress)
├── Archive/       — Completed tasks (status: done)
├── CLAUDE.md      — Agent startup instructions, vault lock, protocol
└── Sprint_View.md — Current sprint overview table
```

---

## Task File YAML Frontmatter

Every task in Backlog/ or Working/ has this header:

```yaml
---
status: backlog          # backlog | sprint | in-progress | review | blocked | done
priority: P1             # P1 = must-have | P2 = should-have | P3 = nice-to-have
agent_claimed: null      # agent-id or null
claimed_at: null         # ISO-8601 datetime or null
updated: 2026-08-19      # ISO-8601 date
---
```

---

## Vault Lock Mechanism

The `vault_lock` field in SCRUM/CLAUDE.md frontmatter controls whether agents can claim tasks:

- `vault_lock: false` — normal operations, agents can claim
- `vault_lock: true` — STOP. Do not claim anything. Board is locked (e.g., during sprint planning or maintenance)

```yaml
---
vault_lock: false
locked_by: null
lock_reason: null
---
```

---

## Task Lifecycle

| Status | Location | Meaning |
|--------|----------|---------|
| backlog | Backlog/ | Identified but not committed to a sprint |
| sprint | Backlog/ | Committed to current sprint |
| in-progress | Working/ | Agent has claimed it and is working |
| review | Working/ | Work complete, awaiting review |
| blocked | Working/ | Stuck on external dependency |
| done | Archive/ | Completed and verified |

---

## Agent Claiming Protocol

1. Read SCRUM/CLAUDE.md — check vault lock
2. Read SCRUM/Sprint_View.md — see what's committed this sprint
3. Run `grep -r "agent_claimed:" SCRUM/Working/ SCRUM/Backlog/` — check who's working on what
4. Pick an unclaimed task (agent_claimed: null)
5. Update frontmatter with your agent-id and timestamp
6. Move file from Backlog/ to Working/

---

## Shutdown Protocol

Before ending any session:

1. Add a Work Log entry to your task file
2. Update frontmatter status to reflect true state
3. `git add -A && git commit -m "chore: <agent-id> shutdown — <task-name> <status>" && git push`

---

## Sprint Planning Flow

1. Central sprint view maintained at [BUTTERGANG/SCRUM/05_Dashboards/Sprint_View.md](https://github.com/BUTTERGANG/SCRUM/blob/main/05_Dashboards/Sprint_View.md)
2. Sprint backlog agent updates each repo's SCRUM/Sprint_View.md with allocated tasks
3. Per-repo agents pick from that sprint view
4. Completed work is reported back to central sprint view