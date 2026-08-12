#!/usr/bin/env bash
# Shared configuration for the VHS demo setup/teardown scripts.
# Sourced by setup.sh, teardown.sh and render.sh — not meant to be run directly.

# Repo root (…/demos/vhs/scripts → repo root)
DEMO_REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# Directory the tapes `cd` into. The tapes default to ~/patterson-design-marketplace;
# setup.sh links that path to this checkout so a fresh machine records the real repo.
DEMO_WORKSPACE="${PATTERSON_DEMO_DIR:-$HOME/patterson-design-marketplace}"

# Isolated Claude Code config so demos never touch (or leak) a developer's real
# credentials, installed plugins or history.
DEMO_CLAUDE_CONFIG_DIR="${PATTERSON_DEMO_CLAUDE_CONFIG_DIR:-$HOME/.cache/patterson-vhs/claude}"

# Marker file recording what setup.sh created, so teardown.sh only removes its own work.
DEMO_STATE_FILE="${DEMO_CLAUDE_CONFIG_DIR%/*}/state.env"

export DEMO_REPO_ROOT DEMO_WORKSPACE DEMO_CLAUDE_CONFIG_DIR DEMO_STATE_FILE
