# demos/vhs/

One [VHS](https://github.com/charmbracelet/vhs) tape per plugin plus `marketplace-tour.tape`. Each scripts a real session: start `claude` → `/plugin marketplace add .` → `/plugin install <name>@patterson-design` → run the plugin's slash command.

Because the tapes record a real terminal, anything missing from `PATH` is baked into the GIF as an error. Use `render.sh`, which installs and verifies the dependencies first and cleans up afterwards.

```bash
bash render.sh                 # all tapes → gif/
bash render.sh patterson-deck  # one tape  → gif/patterson-deck.gif
```

## Dependencies

| Dependency | Provided by |
| --- | --- |
| `vhs`, `ttyd`, `ffmpeg` | `brew install vhs` (macOS) or `sudo apt install vhs ttyd ffmpeg` via <https://repo.charm.sh/apt/> |
| `claude` | installed by `scripts/setup.sh` (`npm install -g @anthropic-ai/claude-code`) |
| Claude credentials | `ANTHROPIC_API_KEY` or `CLAUDE_CODE_OAUTH_TOKEN` in the environment |

`render.sh` runs `scripts/setup.sh` before rendering and `scripts/teardown.sh` on exit (including on failure or Ctrl-C):

- **setup** verifies the VHS toolchain, installs the Claude Code CLI if missing, links the demo workspace the tapes `cd` into, creates an isolated `CLAUDE_CONFIG_DIR` (so recordings never show your real plugins, history, or credentials), and refuses to render unauthenticated.
- **teardown** removes the workspace link and the isolated config dir — never a pre-existing directory.

Each tape starts with `Require claude`, so a missing CLI aborts the render instead of recording a `command not found`.

## Environment

| Variable | Default | Purpose |
| --- | --- | --- |
| `PATTERSON_DEMO_DIR` | `~/patterson-design-marketplace` | Workspace the tapes `cd` into; setup links it to this checkout |
| `PATTERSON_DEMO_CLAUDE_CONFIG_DIR` | `~/.cache/patterson-vhs/claude` | Isolated Claude config used while recording |
| `PATTERSON_DEMO_SKIP_INSTALL` | `0` | Verify dependencies only; never `npm install` |
| `PATTERSON_DEMO_ALLOW_UNAUTHENTICATED` | `0` | Render even without Claude credentials |

Running a tape directly (`vhs patterson-deck.tape`) still works once setup has run.

Tapes use a Patterson-navy terminal theme, 1180×640 @ 15pt. GIFs land in `gif/` and are embedded across repository README files. CI regenerates them via `.github/workflows/generate-vhs-gifs.yml`, which skips rendering when `ANTHROPIC_API_KEY` is not configured.

## VHS terminal demo

<img src="gif/marketplace-tour.gif" width="820" alt="marketplace terminal demo">
