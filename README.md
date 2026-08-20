# Agent Playbook

Reusable development template for AI agents building applications. Concise, imperative, checkbox-style. Read Reference Docs before starting any new build.

---

## Reference Docs
Check before scaffolding — don't guess from training data.

- [ ] Replit — https://docs.replit.com — **Preview requires port 5000**
- [ ] Neon Postgres — https://neon.tech/docs/introduction — default DB for all projects
- [ ] OpenRouter — https://openrouter.ai/docs
- [ ] Agent Mail — https://docs.agentmail.to — 2FA + inbox provisioning
- [ ] Playwright — https://playwright.dev/docs/intro — default scraping tool
- [ ] Xcode — https://developer.apple.com/documentation/xcode — mobile screenshot iteration / sidecar simulator workflow
- [ ] Apple Developer Program — https://developer.apple.com/programs/

---

## Phase 1: Idea Validation & Scoping
- [ ] State the problem in one sentence
- [ ] Identify the primary user
- [ ] Define the single core feature that justifies the app's existence
- [ ] List two competitors and their gaps
- [ ] Lock the platform target — mobile, web, or both
- [ ] State the monetization or purpose type

## Phase 2: MVP Build
- [ ] Scaffold the project with the chosen stack
- [ ] Stack default: Python and TypeScript first; React Native or native Swift + Xcode sidecar for mobile; OpenRouter or Replit AI integration for in-app AI features
- [ ] Default to Neon Postgres for persistence unless the app specifically requires otherwise — skip DB evaluation
- [ ] Implement only the single core feature from Phase 1
- [ ] Add minimal auth only if user accounts are required
- [ ] Build bare minimum UI — function over form
- [ ] Use screenshot-based visual verification after every UI change (Xcode sidecar for mobile, browser screenshot tools for web) — terminal-only feedback is a known blind spot
- [ ] Remove or stub every non-essential feature request
- [ ] Document required Replit preview port (5000) and any other platform-specific config quirks before deploying
- [ ] Ship to a testable environment (TestFlight, Vercel preview, or similar)

## Phase 3: Post-MVP Hardening
- [ ] Add proper error handling and logging across all core flows
- [ ] Pipe verbose/ambiguous console output to a log file the agent can read directly
- [ ] Run a security pass across all four layers: front end, back end, middleware, API
- [ ] Check app store / Play store compliance requirements for target platform
- [ ] Add crash reporting and basic analytics
- [ ] Add automated tests for the core feature path
- [ ] Test on at least one physical device per platform before submission — simulators miss camera, GPS, push notifications, biometrics, and real network conditions
- [ ] Validate against current App Store / Play Store review guidelines (privacy manifest, permission strings, screenshot/metadata accuracy) — not just functional testing
- [ ] Review and tighten data privacy, especially user information
- [ ] Document all secrets in a portable format outside Replit (one .env template per repo) so testing works on any machine

## Phase 4: Growth & Iteration
- [ ] Collect real user feedback through the shipped MVP
- [ ] Identify top three requested features or pain points
- [ ] Expand features only from that prioritized list — nothing speculative
- [ ] Run a performance pass — load times, queries, bundle size
- [ ] Revisit monetization based on real usage data
- [ ] Set a cadence for the next release cycle

## Phase 5: Lessons Learned Log
Two tiers — quick fixes vs. structural issues.

**Quick Fix Log** (one line problem / one line resolution, tagged by category: infrastructure, app store, API, auth, deployment)
| Date | Category | Problem | Resolution |
|------|----------|---------|------------|
| 2026-08-19 | infrastructure | Replit preview port not specified — agents guessed wrong port | Document port 5000 in README before deploying; make it a Phase 2 checkbox |
| 2026-08-19 | infrastructure | os.sched_getaffinity(0) returns host core count on vast.ai (256), not allocated slice | Clamp worker count to allocated vCPUs, never trust sched_getaffinity on rented instances |
| 2026-08-19 | deployment | Replit-origin lockfiles embed package-firewall.replit.local URLs — npm install fails EAI_AGAIN | Rewrite lockfile registry prefix to registry.npmjs.org before running npm ci |
| 2026-08-19 | auth | Multiple app inboxes under root account not structured from the start — painful migration | Structure multi-app inbox provisioning under one root Agent Mail account from day one |
| 2026-08-19 | API | Neon connection pool exhaustion under concurrent scrapers | Set connection pool limits per service; use PgBouncer for high-concurrency workloads |
| 2026-08-19 | infrastructure | CUDA/NVIDIA vast.ai templates waste ~29GB of root disk on drivers — "No space left" | Use plain Ubuntu 22.04 template for CPU-only workloads (bulk OCR, scraping) |

**Architecture Decision Records** (for structural/design issues that should change how future apps get built — not just what broke)
| Date | Decision | Reasoning | Applies To Future Projects |
|------|----------|-----------|----------------------------|
| 2026-08-19 | Default to Neon Postgres for all apps | Universal persistence layer — serverless, branching for dev, generous free tier, pgvector ready. No per-project DB evaluation needed. | Yes — skip DB evaluation in Phase 2; just scaffold with Neon |
| 2026-08-19 | Uniform SCRUM board per repo (Backlog/Working/Archive + CLAUDE.md) | Central SCRUM tracks sprints; per-repo boards let agents claim tasks independently without stepping on each other | Yes — every new repo gets the same SCRUM/ structure from the scaffold template |
| 2026-08-19 | Use spawn (not fork) for Python multiprocessing with PyMuPDF | fitz hangs under fork — child processes never execute. Spawn fixes it completely | Yes — use spawn start method for any multiprocessing that imports fitz or other C-extension libs |
| 2026-08-19 | pnpm workspaces for monorepos, npm for single-package | pnpm workspace resolution catches cross-package type errors at build time; npm workspaces lack strict isolation | Yes — monorepo = pnpm, single package = npm |

- [ ] Before starting a new app, read this log first and check for applicable fixes
- [ ] Update the log immediately when resolved, not after the sprint ends

---

## Templates

This repo ships with reusable file templates in `templates/`:

| File | Use |
|------|-----|
| `templates/task.md` | SCRUM backlog task file with YAML frontmatter |
| `templates/adr.md` | Architecture Decision Record template |
| `templates/claude.md` | Per-repo CLAUDE.md agent startup instructions |
| `templates/.env.example` | Standard env vars template for new projects |
| `templates/pull_request.md` | PR description template |
| `templates/scrum_reference.md` | SCRUM board protocol reference |

Copy these into a new repo, fill in the variables, and commit.

---

## Auth Pattern
- [ ] Use Agent Mail for 2FA and inbox provisioning
- [ ] Structure multiple app inboxes under one root account from the start

---

## SCRUM Board

This repo has its own SCRUM board at `SCRUM/` with backlog tasks for playbook improvements. See `templates/scrum_reference.md` for the protocol.