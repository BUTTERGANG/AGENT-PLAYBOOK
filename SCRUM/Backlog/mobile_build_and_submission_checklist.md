---
status: backlog
priority: P2
agent_claimed: null
claimed_at: null
updated: 2026-08-19
---

# Mobile Build and Submission Checklist

> **Repo:** AGENT-PLAYBOOK
> **Description:** Phase 3 needs a dedicated mobile release checklist covering TestFlight, App Store review prep, and sidecar simulator workflow

---

## Context

Several BUTTERGANG apps target mobile (WEDDINGTIMELINE, ECHO, thrift-lens). The current Phase 3 hardening section covers mobile broadly but misses specific steps: TestFlight build config, review guideline prep, permission string accuracy, privacy manifest, and the Xcode sidecar screenshot workflow for agents.

---

## Acceptance Criteria

- [ ] Add a Mobile Release subsection to Phase 3 with its own checkbox list
- [ ] Cover: TestFlight internal test setup, review guidelines checklist, privacy manifest requirements, permission usage descriptions
- [ ] Document the Xcode sidecar simulator workflow for screenshot-based visual verification
- [ ] Include physical device testing requirements (camera, GPS, push, biometrics)
- [ ] Reference Expo build/review tooling if the app uses Expo

---

## Technical Notes

- Xcode sidecar: developer.apple.com/documentation/xcode for simulator + screenshot capture
- Expo apps use EAS Submit for App Store submission
- Physical device testing is non-negotiable before submission