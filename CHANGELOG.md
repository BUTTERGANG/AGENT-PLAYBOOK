# Changelog — AGENT-PLAYBOOK

## v1.1.0 — 2026-08-20

### Added

- Phase 5 Lessons Log expanded with 13 new Quick Fixes and 8 new ADRs mined from changelogs, launch docs, and case studies across BUTTERGANG repos (MORAN-WEBSITE, k9-overwatch, price-scrapers, mind-games, theknot-scraper, echo, POLYBOT, and the PROJECT-PORTFOLIO case-study index).
- New lessons-log categories: testing, security, scraping (extended from infrastructure/app store/API/auth/deployment).
- **Silent-failure theme (MORAN-WEBSITE):** webhooks mounted outside `/api` missing from the route manifest answer HTTP 200 (S-25); SITE_URL not reaching the artifact production process (S-26); secrets validated for mode but not kind (S-20); SMTP-only `send()` returning silently (S-24); whitespace-corrupted tokens 401'ing like revoked ones (S-2); a stale DATABASE_URL fallback silently serving wrong data.
- **Scraping theme (k9-overwatch, price-scrapers, mind-games, theknot-scraper):** adapter-per-source over a common interface, per-aggregator independent scheduler jobs, cascading geocoding with a bundled ZIP fallback, 429/503 stop-and-circuit-break discipline, CAPTCHA-returns-HTTP-200 silent failures, gated-portal automation.
- **Architecture decisions:** adapter-per-source scraping spine; independent poller jobs; paper-trade/read-only default for money automation; AI API keys proxied server-side only; privacy-by-construction / case-study-only for sensitive data; validate integration secrets at load; instrument the running process's real target.

## v1.0.0 — 2026-08-19

Initial release. Reusable development template for AI agents building BUTTERGANG applications.

### Added

- Phase 1–5 development framework with checkbox-style checklists
- Reference Docs section with links to core tooling
- AGENTS.md section — framework version pinning pattern to prevent broken code from outdated agent knowledge
- Auth Pattern documentation (Agent Mail for 2FA)
- Phase 2 additions: icon governance rule, env var hygiene (two-var DB, optional-degrade), Replit persistence fix
- Phase 3 additions: testing defaults (Vitest/Playwright/pytest)
- New section: Parallel Work / Subagent Pattern for multi-agent builds
- Phase 5 Lessons Log seeded with 14 real quick fixes and 9 ADRs from BUTTERGANG project history
- SCRUM board with 4 backlog tasks (2 completed, moved to Archive)
- templates/ directory with 7 reusable file templates
- scaffold.sh — one-command repo scaffold with --framework and --init flags