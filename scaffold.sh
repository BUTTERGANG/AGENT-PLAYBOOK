#!/usr/bin/env bash
#
# scaffold.sh — AGENT-PLAYBOOK repo scaffolder
# Usage: ./scaffold.sh <repo-name> [--framework expo|nextjs|none] [--dir /path/to/parent] [--init] [--link <git-url>]
#
# Creates a new repo directory pre-loaded with AGENT-PLAYBOOK templates:
#   README.md, .env.example, .gitignore, SCRUM/ board structure,
#   and (if --framework is set) AGENTS.md + .replit with CLAUDE_CONFIG_DIR.

set -euo pipefail

# ---------- defaults ----------
FRAMEWORK="none"
PARENT_DIR="$(pwd)"
DO_INIT=false
LINK_URL=""
PLAYBOOK_VERSION="v1.0.0"

# ---------- resolve script location so templates/ is found regardless of cwd ----------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"

# ---------- arg parsing ----------
if [[ $# -lt 1 ]]; then
  echo "Usage: ./scaffold.sh <repo-name> [--framework expo|nextjs|none] [--dir /path/to/parent] [--init] [--link <git-url>]"
  exit 1
fi

REPO_NAME="$1"
shift

while [[ $# -gt 0 ]]; do
  case "$1" in
    --framework)
      FRAMEWORK="${2:-none}"
      shift 2
      ;;
    --dir)
      PARENT_DIR="${2:-$(pwd)}"
      shift 2
      ;;
    --init)
      DO_INIT=true
      shift
      ;;
    --link)
      LINK_URL="${2:-}"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ "$FRAMEWORK" != "none" && "$FRAMEWORK" != "expo" && "$FRAMEWORK" != "nextjs" ]]; then
  echo "Error: --framework must be one of: expo, nextjs, none"
  exit 1
fi

if [[ ! -d "$TEMPLATES_DIR" ]]; then
  echo "Error: templates/ directory not found at $TEMPLATES_DIR"
  echo "Run this script from inside a checkout of AGENT-PLAYBOOK, or place it alongside templates/."
  exit 1
fi

REPO_PATH="$PARENT_DIR/$REPO_NAME"
TODAY="$(date +%Y-%m-%d)"

if [[ -d "$REPO_PATH" ]]; then
  echo "Error: $REPO_PATH already exists. Aborting to avoid overwriting."
  exit 1
fi

echo "Scaffolding '$REPO_NAME' (framework: $FRAMEWORK) at $REPO_PATH ..."

# ---------- directory structure ----------
mkdir -p "$REPO_PATH/SCRUM/Backlog"
mkdir -p "$REPO_PATH/SCRUM/Working"
mkdir -p "$REPO_PATH/SCRUM/Archive"

# ---------- helper: copy + substitute a template ----------
stamp_file() {
  local src="$1"
  local dest="$2"
  if [[ ! -f "$src" ]]; then
    echo "  Warning: template $src not found, skipping."
    return
  fi
  sed -e "s/{{REPO_NAME}}/$REPO_NAME/g" \
      -e "s/{{DATE}}/$TODAY/g" \
      "$src" > "$dest"
  echo "  Created $dest"
}

# ---------- README.md ----------
cat > "$REPO_PATH/README.md" <<EOF
# $REPO_NAME

Scaffolded from [AGENT-PLAYBOOK]($PLAYBOOK_VERSION) on $TODAY.

Before building, read the AGENT-PLAYBOOK repo (github.com/BUTTERGANG/AGENT-PLAYBOOK)
for the full 5-phase development checklist, reference docs, and lessons-learned log.
EOF
echo "  Created $REPO_PATH/README.md"

# ---------- .env.example ----------
stamp_file "$TEMPLATES_DIR/.env.example" "$REPO_PATH/.env.example"

# ---------- .gitignore ----------
stamp_file "$TEMPLATES_DIR/.gitignore" "$REPO_PATH/.gitignore"
# fall back to a standard BUTTERGANG ignore list if no template .gitignore exists
if [[ ! -f "$REPO_PATH/.gitignore" ]]; then
  cat > "$REPO_PATH/.gitignore" <<EOF
node_modules/
.env
.env.local
dist/
build/
.DS_Store
*.log
.expo/
.next/
EOF
  echo "  Created $REPO_PATH/.gitignore (fallback, no template found)"
fi

# ---------- SCRUM board ----------
# prefer the dedicated claude.md template for SCRUM startup instructions
if [[ -f "$TEMPLATES_DIR/claude.md" ]]; then
  stamp_file "$TEMPLATES_DIR/claude.md" "$REPO_PATH/SCRUM/CLAUDE.md"
else
  stamp_file "$TEMPLATES_DIR/scrum_reference.md" "$REPO_PATH/SCRUM/CLAUDE.md"
fi

cat > "$REPO_PATH/SCRUM/Sprint_View.md" <<EOF
# $REPO_NAME — Sprint View

**Sprint:** _(unstarted)_
**Date:** $TODAY

## In Progress


## Blocked


## Done This Sprint

EOF
echo "  Created $REPO_PATH/SCRUM/Sprint_View.md"

touch "$REPO_PATH/SCRUM/Backlog/.gitkeep"
touch "$REPO_PATH/SCRUM/Working/.gitkeep"
touch "$REPO_PATH/SCRUM/Archive/.gitkeep"

# ---------- framework-specific files ----------
if [[ "$FRAMEWORK" != "none" ]]; then
  if [[ "$FRAMEWORK" == "expo" ]]; then
    AGENTS_TEMPLATE="$TEMPLATES_DIR/agents_expo.md"
  else
    AGENTS_TEMPLATE="$TEMPLATES_DIR/agents_nextjs.md"
  fi

  if [[ -f "$AGENTS_TEMPLATE" ]]; then
    stamp_file "$AGENTS_TEMPLATE" "$REPO_PATH/AGENTS.md"
  elif [[ -f "$TEMPLATES_DIR/AGENTS.md" ]]; then
    stamp_file "$TEMPLATES_DIR/AGENTS.md" "$REPO_PATH/AGENTS.md"
    echo "  Note: no $FRAMEWORK-specific AGENTS.md template found, used generic AGENTS.md instead."
  else
    echo "  Warning: no AGENTS.md template found for framework '$FRAMEWORK'."
  fi

  cat > "$REPO_PATH/.replit" <<EOF
run = "npm run dev"
entrypoint = "index.js"

[env]
CLAUDE_CONFIG_DIR = "/home/runner/\${REPL_SLUG}/.claude"
EOF
  echo "  Created $REPO_PATH/.replit (framework: $FRAMEWORK, CLAUDE_CONFIG_DIR set)"
fi

# ---------- git init / commit ----------
if [[ "$DO_INIT" == true ]]; then
  (
    cd "$REPO_PATH"
    git init -q
    git add -A
    git commit -q -m "Initial scaffold from AGENT-PLAYBOOK $PLAYBOOK_VERSION"
  )
  echo "  git initialized and committed."
fi

# ---------- git remote + push ----------
if [[ -n "$LINK_URL" ]]; then
  if [[ "$DO_INIT" != true ]]; then
    echo "  Warning: --link given without --init. Initializing git first."
    (
      cd "$REPO_PATH"
      git init -q
      git add -A
      git commit -q -m "Initial scaffold from AGENT-PLAYBOOK $PLAYBOOK_VERSION"
    )
  fi
  (
    cd "$REPO_PATH"
    git remote add origin "$LINK_URL"
    git branch -M main
    git push -u origin main
  )
  echo "  Linked to $LINK_URL and pushed to main."
fi

echo ""
echo "Done. $REPO_NAME scaffolded at $REPO_PATH"