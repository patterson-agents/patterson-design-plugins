# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A **Claude Code plugin marketplace** for the Patterson Companies design system — not an application. There is no bundler, no test suite, no server to run. The repo is a catalog (`.claude-plugin/marketplace.json`) plus **9 self-contained plugins** under `plugins/`. Each plugin packages the same four parts:

- `skills/<name>/SKILL.md` — auto-invoked knowledge Claude loads on relevant work
- `commands/*.md` — explicit slash-command scaffold workflows
- `agents/*.md` — a subagent specialist Claude can delegate to
- `ds/` — a self-contained snapshot of every design-system file that plugin needs (tokens, fonts, logos, the compiled `_ds_bundle.js`, and the plugin's own HTML/JSX artifact)

The plugins: `patterson-brand` (core — install first), `patterson-deck`, `patterson-executive-deck`, `patterson-corporate-page`, `patterson-file-manager`, `patterson-docs`, `patterson-tutorialkit` (templates), `patterson-corporate-website`, `patterson-storefront` (UI kits).

The HTML/JSX inside each `ds/` tree are **design references and runnable starters** — they render on-brand with no build step (plain `<script>` + `_ds_bundle.js`), and open directly in a browser. They are the *output* the plugins produce, not production app code. When a plugin is used, Claude copies the relevant `ds/` files into the target project and adapts them to that project's stack.

## Commands

```bash
claude plugin validate .          # the canonical check — run after ANY change to a
                                  # plugin.json, marketplace.json, skill, command, or agent.
                                  # Also the default VS Code test task.
claude plugin list                # list installed plugins

# Local smoke test of the end-to-end path
claude
/plugin marketplace add .
/plugin install patterson-brand@patterson-design   # foundation first
/plugin install patterson-deck@patterson-design
/patterson-deck:new-deck Q3 dental equipment business review

# Docs / demo preview (static — no build)
npx --yes serve -l 3000 .         # then open /docs/ or /demos/

# Render terminal demo GIFs (optional; requires charmbracelet/vhs + Claude credentials)
# render.sh installs/verifies deps first and tears them down after — never call vhs
# directly on a machine without the claude CLI, or the GIF records the error.
bash demos/vhs/render.sh patterson-deck    # → demos/vhs/gif/patterson-deck.gif
bash demos/vhs/render.sh                   # render all tapes
```

The marketplace suffix is `@patterson-design` (from `marketplace.json` `name`), independent of the repo folder name.

## Invariants (easy to break, nothing auto-enforces them)

- **`ds/` is a mirror of the source tree.** Files reference each other with relative paths (`../../styles.css`, `../../_ds_bundle.js`) that must resolve identically in this repo, in the plugin cache, and after being copied into a consuming project. **Never flatten, rename, or move files inside any `ds/`.**
- **`ds/` snapshots are intentionally duplicated** across plugins so each plugin is self-contained. A change to a shared brand-core file (a token, font, or logo) must be **re-copied into every plugin's `ds/`** that references it — there is no shared/symlinked source.
- **Ship only the assets a plugin actually references.** Because every `ds/` is duplicated, an unused file costs its size once per plugin. The SVG logo lockups and Proxima Nova woff2 subsets are small and live in every `ds/assets/`; the raster brand imagery (`wave-bg-navy.png`, `photo-markets.png`, `value-prop.png`, `color-palette.png`) is heavy and is snapshotted **only** into the plugins whose files reference it — currently `patterson-brand` (all four) and `patterson-deck` (wave background + photo band). Do not copy raster art into a plugin "just in case"; add it when a template starts using it.
- **Keep raster art web-sized.** Brand PNGs are stored downscaled to their largest on-screen use (≤ 1920 px wide) and run through `pngquant` + `optipng`. Re-optimize any raster asset re-copied from upstream instead of committing the full-resolution original.
- **Never hand-edit `ds/_ds_bundle.js`** — it is compiled upstream.
- **`.claude-plugin/` holds only manifests** — `marketplace.json` at the repo-root `.claude-plugin/`, `plugin.json` at each plugin's `.claude-plugin/`. Skills, commands, and agents live *outside* `.claude-plugin/`, at the plugin root.
- **Dual version source of truth:** for any content change, bump `version` in **both** `plugins/<name>/.claude-plugin/plugin.json` **and** the matching entry in `.claude-plugin/marketplace.json`, and keep them equal.
- **One-to-one:** every folder under `plugins/` has exactly one entry in `marketplace.json`, and vice versa (currently 9 each).
- **Frontmatter (YAML) per component type:** commands need `description` (+ optional `argument-hint`); agents need `name` and `description`; skills need `name`, `description`, `user-invocable`.
- Agent/command files reference plugin files via `${CLAUDE_PLUGIN_ROOT}/ds/…` so they resolve wherever the plugin is installed.

## Brand rules (any HTML/CSS you touch)

- Style with CSS custom properties from `ds/tokens/*.css` (`--pat-navy`, `--pat-sky`, `--space-*`, `--fs-*`, `--shadow-*`) — **never raw hex**. Primary navy `#003767`, accent sky `#00A8E1` live only inside the token files.
- Pill buttons, 10px card radius, navy-tinted shadows, sky focus ring. Proxima Nova with Figtree fallback.
- Use the bundled logo SVGs in `ds/assets/brand/` — never redraw the wave mark. White lockup on navy, navy lockup on white.
- Voice: confident, plain-spoken, "we/you", short declarative sentences. **Never use emoji** in any brand-facing surface — this is a B2B healthcare distribution brand.
- Assets are **proprietary** (Patterson logos, Proxima Nova woff2 subsets, brand imagery). This repo is private-distribution only.

## Maintenance loop (source → snapshots)

This marketplace is *generated from* the upstream design-system project. When the source changes: (1) re-copy the changed files into every affected plugin `ds/` (plain copies, identical paths), (2) bump the paired versions, (3) `claude plugin validate .`, then commit.

Raster assets get one extra step before (2): downscale to the largest size they are actually displayed at (≤ 1920 px wide), then `pngquant --quality=65-92 --strip` and `optipng -o2 -strip all`, and copy the optimized file only into the plugins that reference it. Install size is the metric that matters — every megabyte in a `ds/` is paid again by each plugin that carries it.

## Reference docs

- `CLAUDE_CODE_HANDOFF.md` — paste-ready prompt covering publish, validate, dev-container setup, and the maintenance loop.
- `.github/copilot-instructions.md` — the same layout/brand rules for Copilot.
- Each `plugins/<name>/README.md` — that plugin's file tree, usage, and primary command.
