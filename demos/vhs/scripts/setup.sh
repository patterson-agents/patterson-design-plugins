#!/usr/bin/env bash
# demos/vhs/scripts/setup.sh — install and verify everything the VHS tapes need.
#
# The tapes record a real terminal, so anything missing from PATH ends up baked into
# the GIF as an error (this is why the GIFs previously showed "claude: command not
# found"). Run this before rendering, and demos/vhs/scripts/teardown.sh afterwards.
#
#   bash demos/vhs/scripts/setup.sh
#
# Environment:
#   PATTERSON_DEMO_DIR                  workspace the tapes cd into (default ~/patterson-design-marketplace)
#   PATTERSON_DEMO_CLAUDE_CONFIG_DIR    isolated Claude config dir (default ~/.cache/patterson-vhs/claude)
#   PATTERSON_DEMO_SKIP_INSTALL=1       verify only, never npm install
#   PATTERSON_DEMO_ALLOW_UNAUTHENTICATED=1  continue even without Claude credentials
set -euo pipefail

# shellcheck source=demos/vhs/scripts/env.sh
source "$(dirname "${BASH_SOURCE[0]}")/env.sh"

log() { printf '==> %s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

record_state() {
  mkdir -p "$(dirname "$DEMO_STATE_FILE")"
  cat >"$DEMO_STATE_FILE" <<EOF
CREATED_WORKSPACE_LINK=$created_workspace_link
DEMO_WORKSPACE=$DEMO_WORKSPACE
DEMO_CLAUDE_CONFIG_DIR=$DEMO_CLAUDE_CONFIG_DIR
EOF
}

# --- 1. Rendering toolchain -------------------------------------------------
missing=()
for bin in vhs ttyd ffmpeg; do
  command -v "$bin" >/dev/null 2>&1 || missing+=("$bin")
done
if [ ${#missing[@]} -gt 0 ]; then
  die "missing VHS dependencies: ${missing[*]}
Install them with:
  brew install vhs                     # macOS (pulls ttyd + ffmpeg)
  sudo apt install vhs ttyd ffmpeg     # Debian/Ubuntu via https://repo.charm.sh/apt/"
fi
log "vhs $(vhs --version 2>/dev/null | head -n1)"

# --- 2. Claude Code CLI -----------------------------------------------------
if ! command -v claude >/dev/null 2>&1; then
  if [ "${PATTERSON_DEMO_SKIP_INSTALL:-0}" = "1" ]; then
    die "claude is not on PATH and PATTERSON_DEMO_SKIP_INSTALL=1"
  fi
  command -v npm >/dev/null 2>&1 || die "npm is required to install the Claude Code CLI"
  log "Installing @anthropic-ai/claude-code (global npm)"
  npm install -g @anthropic-ai/claude-code
fi
command -v claude >/dev/null 2>&1 || die "claude still not on PATH after install"
log "claude $(claude --version 2>/dev/null | head -n1)"

# --- 3. Demo workspace ------------------------------------------------------
created_workspace_link=0
if [ -e "$DEMO_WORKSPACE" ] || [ -L "$DEMO_WORKSPACE" ]; then
  log "Using existing demo workspace $DEMO_WORKSPACE"
else
  mkdir -p "$(dirname "$DEMO_WORKSPACE")"
  ln -s "$DEMO_REPO_ROOT" "$DEMO_WORKSPACE"
  created_workspace_link=1
  record_state
  log "Linked demo workspace $DEMO_WORKSPACE -> $DEMO_REPO_ROOT"
fi

# --- 4. Isolated Claude config ---------------------------------------------
# Keeps the recording free of a developer's real plugins/history, and pre-answers the
# first-run onboarding prompts so the tape's timings line up with the real session.
mkdir -p "$DEMO_CLAUDE_CONFIG_DIR"
cat >"$DEMO_CLAUDE_CONFIG_DIR/.claude.json" <<'JSON'
{
  "hasCompletedOnboarding": true,
  "hasTrustDialogAccepted": true,
  "theme": "dark"
}
JSON
log "Claude config dir $DEMO_CLAUDE_CONFIG_DIR"

# --- 5. Credentials ---------------------------------------------------------
if [ -z "${ANTHROPIC_API_KEY:-}" ] && [ -z "${CLAUDE_CODE_OAUTH_TOKEN:-}" ]; then
  msg="no ANTHROPIC_API_KEY or CLAUDE_CODE_OAUTH_TOKEN set — claude will record a login prompt instead of the demo"
  if [ "${PATTERSON_DEMO_ALLOW_UNAUTHENTICATED:-0}" = "1" ]; then
    warn "$msg"
  else
    die "$msg (set PATTERSON_DEMO_ALLOW_UNAUTHENTICATED=1 to render anyway)"
  fi
fi

# --- 6. Record state for teardown ------------------------------------------
record_state

log "Setup complete. Render with: bash demos/vhs/render.sh"
