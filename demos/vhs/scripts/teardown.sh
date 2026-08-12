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

decode_base64() {
  local decoded
  if decoded="$(printf '%s' "$1" | base64 --decode 2>/dev/null)"; then
    printf '%s' "$decoded"
    return 0
  fi
  if decoded="$(printf '%s' "$1" | base64 -D 2>/dev/null)"; then
    printf '%s' "$decoded"
    return 0
  fi
  return 1
}

created_workspace_link=0
created_claude_config_dir=0
demo_workspace="$DEMO_WORKSPACE"
demo_claude_config_dir="$DEMO_CLAUDE_CONFIG_DIR"
if [ -f "$DEMO_STATE_FILE" ]; then
  created_workspace_link="$(grep -E '^CREATED_WORKSPACE_LINK=(0|1)$' "$DEMO_STATE_FILE" | tail -n1 | cut -d= -f2 || true)"
  created_claude_config_dir="$(grep -E '^CREATED_CLAUDE_CONFIG_DIR=(0|1)$' "$DEMO_STATE_FILE" | tail -n1 | cut -d= -f2 || true)"
  demo_workspace_b64="$(grep -E '^DEMO_WORKSPACE_B64=' "$DEMO_STATE_FILE" | tail -n1 | cut -d= -f2- || true)"
  demo_claude_config_dir_b64="$(grep -E '^DEMO_CLAUDE_CONFIG_DIR_B64=' "$DEMO_STATE_FILE" | tail -n1 | cut -d= -f2- || true)"
  created_workspace_link="${created_workspace_link:-0}"
  created_claude_config_dir="${created_claude_config_dir:-0}"
  if [ -n "${demo_workspace_b64:-}" ]; then
    decoded_workspace="$(decode_base64 "$demo_workspace_b64" || true)"
    if [ -n "$decoded_workspace" ]; then
      demo_workspace="$decoded_workspace"
    fi
  fi
  if [ -n "${demo_claude_config_dir_b64:-}" ]; then
    decoded_config_dir="$(decode_base64 "$demo_claude_config_dir_b64" || true)"
    if [ -n "$decoded_config_dir" ]; then
      demo_claude_config_dir="$decoded_config_dir"
    fi
  fi
fi

if [ "$created_workspace_link" = "1" ] && [ -L "$demo_workspace" ]; then
  rm -f "$demo_workspace"
  log "Removed demo workspace link $demo_workspace"
fi

if [ "$created_claude_config_dir" = "1" ] && [ -d "$demo_claude_config_dir" ]; then
  rm -rf "$demo_claude_config_dir"
  log "Removed demo Claude config $demo_claude_config_dir"
fi

rm -f "$DEMO_STATE_FILE"

log "Teardown complete."
