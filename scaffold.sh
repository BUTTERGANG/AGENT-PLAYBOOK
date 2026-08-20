#!/usr/bin/env bash
#
# scaffold.sh — stamp out a new BUTTERGANG repo from the AGENT-PLAYBOOK templates.
#
# Usage:
#   ./scaffold.sh my-new-app                     # Web app (default)
#   ./scaffold.sh my-expo-app --framework expo   # Expo mobile app
#   ./scaffold.sh my-next-app --framework nextjs # Next.js app
#   ./scaffold.sh my-tool --framework none       # No AGENTS.md or .replit
#   ./scaffold.sh my-app --dir ~/other/parent    # Custom parent directory
#   ./scaffold.sh my-app --init                  # + git init + first commit
#
# The script lives in AGENT-PLAYBOOK/ and reads templates from its own templates/ dir.
# Run it from anywhere; it resolves its own location automatically.

set -euo pipefail

# ── Locate playbook root ──────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLAYBOOK_DIR="$SCRIPT_DIR"
TEMPLATES_DIR="$PLAYBOOK_DIR/templates"
DATE="$(date +%Y-%m-%d)"

# ── Defaults ────────────────────────────────────────────────────────────
REPO_NAME=""
PARENT_DIR="$(pwd)"
FRAMEWORK="web"    # web | expo | nextjs | none
DO_INIT=false

# ── Parse args ─────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --framework)
      FRAMEWORK="$2"
      shift 2
      ;;
    --dir)
      PARENT_DIR="$2"
      shift 2
      ;;
    --init)
      DO_INIT=true
      shift
      ;;
    --help|-h)
      echo "Usage: scaffold.sh <repo-name> [--framework web|expo|nextjs|none] [--dir <path>] [--init]"
      exit 0
      ;;
    *)
      if [[ -z "$REPO_NAME" ]]; then
        REPO_NAME="$1"
        shift
      else
        echo "ERROR: Unexpected argument: $1"
        exit 1
      fi
      ;;
  esac
done

if [[ -z "$REPO_NAME" ]]; then
  echo "ERROR: Missing repo name."
  echo "Usage: scaffold.sh <repo-name> [--framework web|expo|nextjs|none] [--dir <path>] [--init]"
  exit 1
fi

if [[ ! "$FRAMEWORK" =~ ^(web|expo|nextjs|none)$ ]]; then
  echo "ERROR: Invalid framework '$FRAMEWORK'. Use: web, expo, nextjs, or none."
  exit 1
fi

REPO_DIR="$PARENT_DIR/$REPO_NAME"

if [[ -d "$REPO_DIR" ]]; then
  echo "ERROR: Directory already exists: $REPO_DIR"
  exit 1
fi

# ── Create directory structure ─────────────────────────────────────────
mkdir -p "$REPO_DIR"
mkdir -p "$REPO_DIR/SCRUM/Backlog"
mkdir -p "$REPO_DIR/SCRUM/Working"
mkdir -p "$REPO_DIR/SCRUM/Archive"

echo "Created $REPO_DIR/"
echo "  SCRUM/Backlog/"
echo "  SCRUM/Working/"
echo "  SCRUM/Archive/"

# ── Helper: template → target with variable substitution ───────────────
render_template() {
  local src="$1"
  local dst="$2"
  sed \
    -e "s/{{REPO_NAME}}/$REPO_NAME/g" \
    -e "s/{{DATE}}/$DATE/g" \
    "$src" > "$dst"
}

# ── SCRUM/CLAUDE.md ────────────────────────────────────────────────────
render_template "$TEMPLATES_DIR/claude.md" "$REPO_DIR/SCRUM/CLAUDE.md"
echo "  SCRUM/CLAUDE.md"

# ── SCRUM/Sprint_View.md ──────────────────────────────────────────────
cat > "$REPO_DIR/SCRUM/Sprint_View.md" <<SPRINTEOF
# Sprint View — $REPO_NAME

> **Sprint:** TBD
> **Sprint Name:** TBD
> **Start:** TBD | **End:** TBD
> **Goal:** TBD

---

## In Progress

| Task | Agent | Priority | Est. |
|------|-------|----------|------|
| —    | —     | —        | —    |

---

## Sprint Backlog

| Task File | Priority | Estimate | Status |
|-----------|----------|----------|--------|
| —         | —        | —        | sprint |

---

## Done This Sprint

| Task | Completed |
|------|-----------|
| —    | —         |

---

## Blocked

| Task | Blocked Since | Reason |
|------|---------------|--------|
| —    | —             | —      |
SPRINTEOF
echo "  SCRUM/Sprint_View.md"

# ── .gitignore ─────────────────────────────────────────────────────────
cp "$TEMPLATES_DIR/../.gitignore" "$REPO_DIR/.gitignore"
echo "  .gitignore"

# ── .env.example ───────────────────────────────────────────────────────
render_template "$TEMPLATES_DIR/.env.example" "$REPO_DIR/.env.example"
echo "  .env.example"

# ── README.md ──────────────────────────────────────────────────────────
cat > "$REPO_DIR/README.md" <<READMEEOF
# $REPO_NAME

> Scaffolded from [BUTTERGANG/AGENT-PLAYBOOK](https://github.com/BUTTERGANG/AGENT-PLAYBOOK) v1.0.0
> Date: $DATE | Framework: $FRAMEWORK

---

## Quick Start

\`\`\`bash
# Copy and fill in environment variables
cp .env.example .env

# TODO: add install and run instructions
\`\`\`

## SCRUM Board

This project tracks feature work in \`SCRUM/\`. See \`templates/scrum_reference.md\` in AGENT-PLAYBOOK for the claiming protocol.

## Reference

Before starting any build, read the [AGENT-PLAYBOOK](https://github.com/BUTTERGANG/AGENT-PLAYBOOK) — it covers the full development lifecycle from idea validation through lessons learned.
READMEEOF
echo "  README.md"

# ── Framework-specific files ──────────────────────────────────────────
case "$FRAMEWORK" in
  expo)
    cat > "$REPO_DIR/AGENTS.md" <<AGENTSEOF
# Expo HAS CHANGED

Read the exact versioned docs at https://docs.expo.dev/versions/v56.0.0/ before writing any code.

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data.
AGENTSEOF
    echo "  AGENTS.md (Expo v56.0.0)"

    cat > "$REPO_DIR/.replit" <<REPLITEOF
[env]
CLAUDE_CONFIG_DIR = "/home/runner/workspace/.local/state/claude"
PORT = "5000"
REPLITEOF
    echo "  .replit (Expo + CLAUDE_CONFIG_DIR)"
    ;;

  nextjs)
    cat > "$REPO_DIR/AGENTS.md" <<AGENTSEOF
<!-- BEGIN:nextjs-agent-rules -->
# This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in \`node_modules/next/dist/docs/\` before writing any code. Heed deprecation notices.
<!-- END:nextjs-agent-rules -->
AGENTSEOF
    echo "  AGENTS.md (Next.js)"

    cat > "$REPO_DIR/.replit" <<REPLITEOF
[env]
CLAUDE_CONFIG_DIR = "/home/runner/workspace/.local/state/claude"
PORT = "5000"
REPLITEOF
    echo "  .replit (Next.js + CLAUDE_CONFIG_DIR)"
    ;;

  web)
    # No AGENTS.md or .replit — generic web project
    ;;

  none)
    # Explicitly no framework files
    ;;
esac

# ── git init (optional) ────────────────────────────────────────────────
if $DO_INIT; then
  cd "$REPO_DIR"
  git init -q
  git add -A
  git commit -q -m "Initial scaffold from AGENT-PLAYBOOK v1.0.0"
  echo "  git init + initial commit"
fi

# ── Done ───────────────────────────────────────────────────────────────
echo ""
echo "Done. Scaffolded $REPO_NAME in $REPO_DIR"
echo ""
echo "Next steps:"
echo "  1. cd $REPO_DIR"
echo "  2. Fill in .env with real values"
echo "  3. Add tasks to SCRUM/Backlog/"
echo "  4. See the playbook at $PLAYBOOK_DIR/README.md"
echo ""