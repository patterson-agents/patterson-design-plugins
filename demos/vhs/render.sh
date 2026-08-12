#!/usr/bin/env bash
# demos/vhs/render.sh — render VHS tapes with dependency setup and teardown.
#
#   bash demos/vhs/render.sh                    # every tape in demos/vhs/
#   bash demos/vhs/render.sh patterson-deck     # one tape (name or path)
#
# Teardown always runs, including on failure or Ctrl-C.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=demos/vhs/scripts/env.sh
source "$SCRIPT_DIR/scripts/env.sh"

tapes=()
if [ "$#" -gt 0 ]; then
  for arg in "$@"; do
    if [ -f "$arg" ]; then
      tapes+=("$arg")
    elif [ -f "$SCRIPT_DIR/${arg%.tape}.tape" ]; then
      tapes+=("$SCRIPT_DIR/${arg%.tape}.tape")
    else
      printf 'error: no such tape: %s\n' "$arg" >&2
      exit 1
    fi
  done
else
  for tape in "$SCRIPT_DIR"/*.tape; do
    tapes+=("$tape")
  done
fi

bash "$SCRIPT_DIR/scripts/setup.sh"
trap 'bash "$SCRIPT_DIR/scripts/teardown.sh"' EXIT

# Tapes read these: the workspace they cd into, and an isolated Claude config so the
# recording never shows a developer's real plugins or history.
export PATTERSON_DEMO_DIR="$DEMO_WORKSPACE"
export CLAUDE_CONFIG_DIR="$DEMO_CLAUDE_CONFIG_DIR"

mkdir -p "$SCRIPT_DIR/gif"
cd "$DEMO_REPO_ROOT"

for tape in "${tapes[@]}"; do
  printf '==> Rendering %s\n' "$(basename "$tape")"
  vhs "$tape"
done

printf '==> GIFs written to %s\n' "$SCRIPT_DIR/gif"
