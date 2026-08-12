#!/usr/bin/env bash
# demos/vhs/scripts/teardown.sh — undo demos/vhs/scripts/setup.sh.
#
# Removes only what setup.sh created: the workspace symlink (never a real directory)
# and the isolated Claude config dir. Safe to run twice.
#
#   bash demos/vhs/scripts/teardown.sh
set -euo pipefail

# shellcheck source=demos/vhs/scripts/env.sh
source "$(dirname "${BASH_SOURCE[0]}")/env.sh"

log() { printf '==> %s\n' "$*"; }

created_workspace_link=0
if [ -f "$DEMO_STATE_FILE" ]; then
  # shellcheck disable=SC1090
  source "$DEMO_STATE_FILE"
  created_workspace_link="${CREATED_WORKSPACE_LINK:-0}"
fi

if [ "$created_workspace_link" = "1" ] && [ -L "$DEMO_WORKSPACE" ]; then
  rm -f "$DEMO_WORKSPACE"
  log "Removed demo workspace link $DEMO_WORKSPACE"
fi

if [ -d "$DEMO_CLAUDE_CONFIG_DIR" ]; then
  rm -rf "$DEMO_CLAUDE_CONFIG_DIR"
  log "Removed demo Claude config $DEMO_CLAUDE_CONFIG_DIR"
fi

rm -f "$DEMO_STATE_FILE"

log "Teardown complete."
