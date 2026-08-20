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

## AGENTS.md — Framework Version Pinning

AI agents have deep knowledge of popular frameworks — but that knowledge is often months behind the latest release. Prevent broken code by pinning exact framework versions at repo root.

- [ ] Create an `AGENTS.md` at the repo root for each major framework in use
- [ ] Format: one-line warning + link to exact versioned docs
- [ ] Examples from existing repos:
  - **Expo:** `# Expo HAS CHANGED\nRead the exact versioned docs at https://docs.expo.dev/versions/v56.0.0/ before writing any code.`
  - **Next.js:** `# This is NOT the Next.js you know\nThis version has breaking changes… Read node_modules/next/dist/docs/`
- [ ] Do this on day one — before any code is written

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
- [ ] Pin framework version warnings in repo-root `AGENTS.md` before writing any code (see AGENTS.md section above)
- [ ] Implement only the single core feature from Phase 1
- [ ] Add minimal auth only if user accounts are required
- [ ] Build bare minimum UI — function over form
- [ ] Use screenshot-based visual verification after every UI change (Xcode sidecar for mobile, browser screenshot tools for web) — terminal-only feedback is a known blind spot
- [ ] Remove or stub every non-essential feature request
- [ ] Document required Replit preview port (5000) and any other platform-specific config quirks before deploying
- [ ] Ship to a testable environment (TestFlight, Vercel preview, or similar)
- [ ] **Icon governance:** Define custom SVG icons for visible surfaces (nav, feature cards, headers); library icons (Phosphor/Lucide) are for utilities only. Document this in CLAUDE.md before the first UI commit — the user is sensitive to stock icons matching competitors
- [ ] **Env var hygiene:** Use separate dev/prod DB connection strings (never a single `DATABASE_URL`). Make every optional feature degrade gracefully when its env var is missing — no crashes for unset optional vars
- [ ] **Replit persistence:** If deploying on Replit, pin `CLAUDE_CONFIG_DIR` to `/home/runner/workspace/.local/state/claude` in `.replit` so Claude Code auth survives server resets

## Phase 3: Post-MVP Hardening
- [ ] Add proper error handling and logging across all core flows
- [ ] Pipe verbose/ambiguous console output to a log file the agent can read directly
- [ ] Run a security pass across all four layers: front end, back end, middleware, API
- [ ] Check app store / Play store compliance requirements for target platform
- [ ] Add crash reporting and basic analytics
- [ ] Add automated tests for the core feature path
- [ ] **Test defaults:** Vitest + Playwright for TypeScript/React projects; pytest + pytest-cov for Python. One integration test per core flow, unit tests for utility functions. Don't over-invest in test coverage at MVP stage
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
| 2026-08-19 | API | Expo SDK version drift — agents default to old Expo knowledge, write broken code | Pin exact SDK version in repo-root AGENTS.md (pattern from ECHO) |
| 2026-08-19 | API | Next.js breaking changes — agents write code against deprecated APIs | Same AGENTS.md pattern: version warning and link to exact docs at repo root (JOB-HUNTER, thrift-lens) |
| 2026-08-19 | infrastructure | Replit /home/runner is ephemeral — Claude Code OAuth tokens wiped on every reset | Set `CLAUDE_CONFIG_DIR` to `/home/runner/workspace/.local/state/claude` in `.replit` (MORAN-WEBSITE) |
| 2026-08-19 | deployment | pnpm db:push accidentally targets production DB — pushed schema changes to wrong database | Enforce `DB_TARGET=production DB_CONFIRM=production` to allow production pushes (MORAN-WEBSITE pattern) |
| 2026-08-19 | deployment | Agent builds new feature with a library icon when a custom SVG already exists — UI looks like a template | Define icon policy in CLAUDE.md: custom SVGs for visible surfaces, library icons only for utilities |
| 2026-08-19 | API | Printify webhook duplicates orders on retry — no idempotency key | Always use idempotency keys on webhook handlers; dedupe by Stripe event ID |
| 2026-08-19 | app store | App Store review rejects for missing privacy manifest or inaccurate permission strings | Add privacy manifest and permission string audit to Phase 3 mobile checklist before submission |
| 2026-08-19 | infrastructure | Agent's deep knowledge of a framework is months behind latest release | Pin exact framework version + docs URL in an AGENTS.md file at repo root on day one |

**Architecture Decision Records** (for structural/design issues that should change how future apps get built — not just what broke)
| Date | Decision | Reasoning | Applies To Future Projects |
|------|----------|-----------|----------------------------|
| 2026-08-19 | Default to Neon Postgres for all apps | Universal persistence layer — serverless, branching for dev, generous free tier, pgvector ready. No per-project DB evaluation needed. | Yes — skip DB evaluation in Phase 2; just scaffold with Neon |
| 2026-08-19 | Uniform SCRUM board per repo (Backlog/Working/Archive + CLAUDE.md) | Central SCRUM tracks sprints; per-repo boards let agents claim tasks independently without stepping on each other | Yes — every new repo gets the same SCRUM/ structure from the scaffold template |
| 2026-08-19 | Use spawn (not fork) for Python multiprocessing with PyMuPDF | fitz hangs under fork — child processes never execute. Spawn fixes it completely | Yes — use spawn start method for any multiprocessing that imports fitz or other C-extension libs |
| 2026-08-19 | pnpm workspaces for monorepos, npm for single-package | pnpm workspace resolution catches cross-package type errors at build time; npm workspaces lack strict isolation | Yes — monorepo = pnpm, single package = npm |
| 2026-08-19 | Always pin framework version warning in repo-root AGENTS.md | Expo, Next.js, and fast-moving frameworks change rapidly; agents trained on older data produce broken code. The AGENTS.md pattern catches this first thing | Yes — include AGENTS.md template in scaffold |
| 2026-08-19 | Separate dev/prod DB connection strings (never a single DATABASE_URL) | MORAN-WEBSITE uses APP_DATABASE_URL + APP_DATABASE_DEVELOPMENT — prevents accidental production schema pushes | Yes — use two-var pattern in .env.example template |
| 2026-08-19 | Env vars should be optional-degrade (no-op when unset), not crash | MORAN-WEBSITE pattern: every optional feature degrades gracefully when its env var is missing, making dev setup radically simpler | Yes — follow this pattern for all feature-gated code |
| 2026-08-19 | Visible UI uses custom SVG icons; library icons only for utilities | User is sensitive to stock icons matching competitors. MINDGAMES custom lift-icons set proved this matters for brand differentiation | Yes — add icon governance to Phase 2 build checklist |
| 2026-08-19 | Replit projects using Claude Code must pin CLAUDE_CONFIG_DIR to a persistent path | Ephemeral /home/runner wipes OAuth tokens on every reset. Pinning to workspace path makes login survive reboots | Yes — add .replit CLAUDE_CONFIG_DIR to Replit scaffold docs |

- [ ] Before starting a new app, read this log first and check for applicable fixes
- [ ] Update the log immediately when resolved, not after the sprint ends

---

## Templates

This repo ships with reusable file templates in `templates/` and a scaffolding script:

| File | Use |
|------|-----|
| `scaffold.sh` | **One-command repo scaffold** — stamps out the full structure with `--framework`, `--init`, and `--link` flags |
| `templates/task.md` | SCRUM backlog task file with YAML frontmatter |
| `templates/adr.md` | Architecture Decision Record template |
| `templates/claude.md` | Per-repo CLAUDE.md agent startup instructions |
| `templates/AGENTS.md` | Generic framework version pinning warning |
| `templates/agents_expo.md` | Expo-specific AGENTS.md (versioned doc link, breaking changes warning) |
| `templates/agents_nextjs.md` | Next.js-specific AGENTS.md (node_modules docs link, breaking changes warning) |
| `templates/.env.example` | Standard env vars template (two-var DB pattern, optional-degrade convention) |
| `templates/.gitignore` | Standard BUTTERGANG ignore list |
| `templates/pull_request.md` | PR description template |
| `templates/scrum_reference.md` | SCRUM board protocol reference |

To scaffold a new repo:

```bash
./scaffold.sh my-new-app                                    # Web app (default)
./scaffold.sh my-expo-app --framework expo --init            # Expo + git init
./scaffold.sh my-next-app --framework nextjs --init --link https://github.com/BUTTERGANG/my-next-app  # Next.js + git + push
./scaffold.sh my-tool --framework none                       # No framework files
```

Copy these into a new repo, fill in the variables, and commit.

---

## Auth Pattern
- [ ] Use Agent Mail for 2FA and inbox provisioning
- [ ] Structure multiple app inboxes under one root account from the start

---

## Parallel Work / Subagent Pattern

For non-trivial builds, parallelize independent workstreams by spawning subagents. This cuts build time significantly.

### When to parallelize

- **Frontend + backend** — build API routes and UI screens simultaneously
- **Scraper + database** — write scraper and schema/migrations in parallel
- **Multiple independent features** — e.g., auth + payment + notifications if they don't share logic

### How it works

1. Break the build into independent workstreams (each has its own goal, context, and output)
2. Spawn one subagent per workstream using `delegate_task` (or equivalent multi-agent tool)
3. Each subagent gets: isolated goal, relevant context, output expectations
4. Parent collects results and reconciles — merges, resolves conflicts, runs integration tests

### Rules

- Each subagent must be **self-contained** — pass everything it needs (file paths, schemas, env vars). Subagents know nothing about the parent conversation
- Never parallelize tasks that share mutable state — you'll get merge conflicts
- Verify subagent output before telling the user it worked — child summaries are self-reports, not verified facts
- For UI work, spawn a dedicated subagent for screenshot-based visual verification after the main build subagent finishes

---

## SCRUM Board

This repo has its own SCRUM board at `SCRUM/` with backlog tasks for playbook improvements. See `templates/scrum_reference.md` for the protocol.