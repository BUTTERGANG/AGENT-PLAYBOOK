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

**Quick Fix Log** (one line problem / one line resolution, tagged by category: infrastructure, app store, API, auth, deployment, testing, security, scraping)
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
| 2026-08-20 | deployment | Live Stripe/Printify webhooks were mounted outside `/api` but missing from the artifact route manifest — the static SPA answered them HTTP 200, so Stripe logged success and paid orders stuck at `pending` forever | Add every outside-`/api` webhook path to the route manifest, alias raw-body routers under `/api` as a no-redeploy fallback, and register new routers in the manifest at mount time (MORAN-WEBSITE S-25) |
| 2026-08-20 | API | A week-long Printify 401 was 26 whitespace chars baked into the token value (wrapped paste), byte-identical to a revoked token — written off as dead | Normalize/whitespace-strip secrets at load and warn at boot if malformed; treat a 401 as a fact about the request, not the token — strip-and-retry is a seconds check (MORAN-WEBSITE S-2) |
| 2026-08-20 | deployment | Checkout's SITE_URL was unset in the artifact production process (`.replit` `[deployment].env` never reaches it), so live Stripe sessions redirected buyers to a dev URL — silent: card charged, order processed | Set `SITE_URL`+`PORT` under `[services.production.run.env]`/`artifact.toml`; warn at boot when `NODE_ENV=production` and `SITE_URL` unset (MORAN-WEBSITE S-26) |
| 2026-08-20 | auth | Stripe boot guard validated the key's *mode* but not its *kind* — a publishable `pk_` key passed as test mode, then 401'd every call | Reject keys not starting `sk_`/`rk_` and webhooks not `whsec_` *before* the mode branch, with unit tests covering the guards (MORAN-WEBSITE S-20) |
| 2026-08-20 | deployment | The SMTP-only `send()` returns silently when `SMTP_HOST` is unset, so order confirmation/refund emails were never delivered — no error anywhere | Route every customer-facing sender through the AgentMail-first `sendTransactional` that throws on failure; assert the transport choice in tests (MORAN-WEBSITE S-24) |
| 2026-08-20 | testing | Two of thirteen backend test files were silently not running — their module import throws when no DB connection string is set | Add a vitest `setupFile` that stubs a dead placeholder `APP_DATABASE_URL` (and pins `DB_TARGET`) so the import trap is closed for every future test file (MORAN-WEBSITE FEATURES) |
| 2026-08-20 | database | Legacy `_key`/`_fkey` constraint names keep being reintroduced by tables created outside drizzle-kit push, even after a sweep "closed" the class | Treat as a recurring check — re-run the `pg_constraint` zero-row query after any out-of-band table; hand-write drizzle-named DDL for phantom-constraint push blocks (MORAN-WEBSITE) |
| 2026-08-20 | infrastructure | `pg_dump` against Neon's PgBouncer pooler is not a valid target (fails silently) and the default client is older than the server — no backups for weeks | Dump the direct Neon endpoint with a client matching the server version; add a restore rehearsal (MORAN-WEBSITE) |
| 2026-08-20 | database | A stale `DATABASE_URL` fallback (Replit's managed PG, an older 32-table schema) could silently serve wrong data when a prod secret was missing | Remove the fallback so boot fails on a missing required DB env var; add a blank/empty-DSN guard (MORAN-WEBSITE) |
| 2026-08-20 | deployment | A timer-based "uptime" metric was wrong on autoscale — the process only exists while serving, so a healthy quiet deployment read as total outage | Sample request-driven traffic (≤1 row/5-min bucket); treat external availability as a separate probe decision, not process liveness (MORAN-WEBSITE) |
| 2026-08-20 | scraping | 429/503 mean rate-limited (hammering makes the ban worse), and a bot CAPTCHA returns HTTP 200 with zero rows — silently poisoning the run | Stop immediately on 429/503 and circuit-break after N consecutive failures; treat 3+ consecutive empty results as a bot-detected/broken-parser signal and inspect raw output — never count an empty page as success (price-scrapers, k9-overwatch) |
| 2026-08-20 | scraping | Headless real-browser scraping scores 10–30% success vs 90–95% visible+residential; "it's blocked" is often a selectors/page-type mismatch, not an access problem | Run non-headless with human pacing + residential proxy, retry-with-backoff, cookie/session persistence; rule out page-type/selector mismatch before blaming the WAF (theknot-scraper, k9-overwatch) |
| 2026-08-20 | scraping | Some sources only serve data behind an authenticated portal (SAML + cookie-consent + paginated tables), not a public API | Automate the real login + consent + pagination flow end-to-end with Playwright to collect gated datasets at scale (mind-games: ~7,000 USAW files) |
| 2026-08-20 | database | Neon's transaction-mode pooler reuses server sessions — a lingering `search_path` from one test's per-test schema leaked into other clients | Give each test its own disposable `test_{uuid}` schema and explicitly `SET search_path TO public` on teardown, so real-DB serial isolation works without colliding (price-scrapers conftest) |
| 2026-08-20 | database | Alembic revision numbers must be globally unique — a duplicate `0009` silently created ambiguous migration ordering (bsa-ci) | Enforce a unique-revision guard; know that data-migrations (FTS-trigger generation, FK-CASCADE DDL rebuilds) are part of schema migration, not a separate concern |
| 2026-08-20 | auth | Server-rendered Express apps defaulted to JWT when session cookies were the simpler, safer fit | For same-origin server-rendered apps, reach for `express-session` + server-side session store (httpOnly, sameSite=strict, secure) before JWT; reserve JWT for token/bearer clients (WEDDINGTIMELINE) |
| 2026-08-20 | testing | Integration tests were coupled to a real DB because app assembly and bootstrap were one file | Split `createApp()` (app factory, injectable storage) from a thin bootstrap `index.ts` that only validates env + listens — tests hit the real HTTP stack with `STORAGE_MODE=memory`, no DB (WEDDINGTIMELINE) |
| 2026-08-20 | scraping/perf | Long-running monitors exhaust external API quotas via per-item retail/geo lookups | Cache external results and cap per-cycle (`MAX_RETAIL_SEARCHES_PER_CYCLE`=15, `RETAIL_SEARCH_INTERVAL_SECONDS`=3, SKIP_KEYWORDS for lots not worth a comp; earls daemon) |
| 2026-08-20 | AI | iPhone/Android photos arrive as HEIC and get rejected by Claude Vision — a real-world field detail most demos skip | Convert HEIC→JPEG (heic-convert) before the Vision call (complete-paperwork) |
| 2026-08-20 | AI/perf | Naive LLM/vision calls blow up the cost and latency of a real-time product | Pay for vision once then go text-only downstream (~10x cheaper); cache external comps by SHA-256 of the query for 24h; tier models (Haiku batch-screen → Sonnet confirm) with a daily cost cap (thrift-lens, POLYBOT) |
| 2026-08-20 | scraping | Re-running a scraper re-flags and re-alerts the same recurring items each cycle | Make cross-run dedupe a first-class requirement — hash/URL dedupe + an import guard so nothing is analyzed or alerted twice (job-hunter) |
| 2026-08-20 | infra/CI | CI on a different runtime than the deploy target burns false-green (dev container vs Replit) | Pin the same runtime/OS in CI as the target — GitHub Actions pins Node 22 + Nix `stable-25_05` for Replit parity, plus a container parity test (vbt-tracker) |

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
| 2026-08-20 | No universal scraping technique — model one adapter per source behind a common BaseScraper interface; scrapers only yield normalized records, a runner owns persistence/geocode/match | Each site guards data differently (open REST, WAF GraphQL, SSR JSON, TLS impersonation, real browser); a tutorial scraper reads zero real targets. k9 (5 sources) + price-scrapers (12 retailers) cracked it per-target with honest blocked marks | Yes — adapter-per-source + producer/consumer spine in every aggregator; test each adapter in isolation |
| 2026-08-20 | Run each scraper as an independent scheduler job (staggered offsets, max_instances=1, coalesce), never one monolithic loop | A slow/Cloudflare source must not stall REST sources; derived work (match, expiry, digest, alerts) has its own cadence; missed ticks coalesce and a singleton lock prevents double-scrape | Yes — per-source jobs + a high-water-mark incremental cursor in any poller |
| 2026-08-20 | Enrichment that is a rate-limited network call (geocoding, comps) becomes a cascading provider chain with a bundled no-network fallback | Geocoding is unreliable; cascade providers → address cache → bundled ZIP-centroid fallback (no download), skip records with native coords, cache negatives (k9-overwatch geocoder) | Yes — respect provider rate limits; never let enrichment block an aggregate run |
| 2026-08-20 | Money/capital automation runs paper-trade / read-only by default with hard risk caps | POLYBOT dry-runs and gates on Kelly/risk until data justifies capital; the finance dashboard uses read-only Plaid. Discipline over conviction is the operator differentiator | Yes — any future real-capital or payment automation gets a paper gate + exposure caps first |
| 2026-08-20 | Keep AI API keys server-side behind a proxy; never ship them in a client bundle | A shipped key is a leak on install; a build-time guard blocks EXPO_PUBLIC_* from client builds (echo, polybot, thrift-lens proxy their calls) | Yes — every paid-AI-key feature gets a server-side proxy |
| 2026-08-20 | Sensitive data gets privacy-by-construction and case-study-only treatment — never a live public demo of real accounts | Finance stays read-only + never-public; echo's bytes live on-device (WASM SQLite + IndexedDB). The guarantee is enforced by where data lives, not a policy promise | Yes — decide per-project visibility/demo-type by data sensitivity up front |
| 2026-08-20 | Validate every integration secret at load — strip whitespace, check shape/kind (not just mode), and hard-fail open on the real cause | A whitespace-corrupted token 401'd identically to a revoked one for a week; publishable-key and blank-env mappings booted healthy and silently killed the shop. The healthy-looking-workspace failure shape recurs | Yes — apply to Stripe, Printify, SMTP, push and any pasted third-party secret |
| 2026-08-20 | Instrument a running process's actual target (DB, port, route manifest) and probe the live public surface — never trust config reading | Wrong-env failures are silent and look like other bugs; two parallel Replit stacks served different ports than the public URL presumed, and a webhook missing from the route manifest answered 200 from a static SPA | Yes — verify against the live URL; the layer your assumption points at is often the wrong endpoint |
| 2026-08-20 | Prefer lightweight polling (45s, paused on hidden tab) over a WebSocket unless true sub-second sync is required | moran-website chose 45s polling for program/alerts; la-media reaches for WebSocket only where live co-edits matter. Simpler and cheaper by default | Yes — default to polling; reach for WebSocket only on a real need |
| 2026-08-20 | Build a "two-path ingestion" sync engine when no one data provider covers the domain | The finance dashboard ingests Plaid for its institutions AND Fidelity OFX Direct Connect as a separate protocol, normalized into one schema — no single aggregator covers every institution | Yes — budget for 2+ ingestion protocols behind one sync adapter |
| 2026-08-20 | Don't reimplement a well-tested library in your edge language — bridge to it as a subprocess/microservice | job-hunter drives `python-jobspy` from Next.js as a subprocess; vbt isolates autoregulation in a FastAPI service; bible-study isolates RAG. A clean polyglot bridge beats a rewrite | Yes — when the proven ecosystem lives in another language |
| 2026-08-20 | Own your production data — migrate off platform-managed storage (Supabase, Replit-PG) onto a DB you control | LA-MEDIA migrated a live business off managed hosting (Supabase→Neon+Better Auth+Dropbox; Replit-PG→NeonDB), fixing SQL injection via parameterized `unnest()` arrays, with a documented end-to-end checklist | Yes — for real-user/client data, don't leave it dependent on a platform's DB |

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