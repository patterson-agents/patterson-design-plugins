# demos/

## Contents

- [`index.html`](index.html) — browsable gallery of every plugin's live HTML artifact, with screenshots. Open directly or serve the repo root (`npx serve`) and visit `/demos/`.
- [`vhs/`](vhs/) — [VHS](https://github.com/charmbracelet/vhs) tapes scripting a real terminal session per plugin: start `claude`, add the marketplace, install the plugin, run its slash command. Render them with `vhs/render.sh`, which sets up and tears down the dependencies.

## Rendering the terminal GIFs

```bash
brew install vhs                            # or: sudo apt install vhs ttyd ffmpeg
bash demos/vhs/render.sh                    # all tapes → demos/vhs/gif/
bash demos/vhs/render.sh patterson-deck     # single plugin → demos/vhs/gif/patterson-deck.gif
```

`render.sh` runs `demos/vhs/scripts/setup.sh` first (installs/verifies the Claude Code CLI, prepares the demo workspace and an isolated Claude config) and `demos/vhs/scripts/teardown.sh` afterwards. Without it the recording captures whatever the shell prints — including `claude: command not found`. Claude credentials (`ANTHROPIC_API_KEY` or `CLAUDE_CODE_OAUTH_TOKEN`) are required; see [`vhs/README.md`](vhs/README.md).

GIFs land in `vhs/gif/` and are embedded across the repository README files.

## VHS terminal demo

<img src="vhs/gif/marketplace-tour.gif" width="820" alt="marketplace terminal demo">

The tapes use a Patterson-navy terminal theme and record from `$PATTERSON_DEMO_DIR` (default `~/patterson-design-marketplace`, which setup links to this checkout).
