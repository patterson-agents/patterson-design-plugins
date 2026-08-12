<picture>
  <source media="(prefers-color-scheme: dark)" srcset="ds/assets/brand/patterson-logo-white.svg">
  <img src="ds/assets/brand/patterson-logo-navy.svg" alt="Patterson" width="150">
</picture>

# Patterson Brand Core — `patterson-brand`

> Tokens · fonts · logos · React components · framework adapters · guidelines

![category](https://img.shields.io/badge/category-core-147EC2?labelColor=003767)
![version](https://img.shields.io/badge/version-1.0.0-00A8E1?labelColor=003767)

<img src="../../docs/screenshots/patterson-brand.png" width="820" alt="Patterson Brand Core preview">

## Contents

- [Install](#install)
- [What you get](#what-you-get)
- [Quick start](#quick-start)
- [File tree](#file-tree)
- [Working with it](#working-with-it)
- [Terminal demo](#terminal-demo)
- [Live demo](#live-demo)
- [Brand quick reference](#brand-quick-reference)

## Install

```bash
/plugin marketplace add patterson-agents/design-system   # once
/plugin install patterson-brand@patterson-design
```

## What you get

| Component | Name | Notes |
|---|---|---|
| Skill | `patterson-design` | auto-invoked; also runnable as `/patterson-brand:patterson-design` |
| Command | `/patterson-brand:design` | e.g. `/patterson-brand:design a landing hero for the equine supplies line` |
| Command | `/patterson-brand:wire-tokens` | e.g. `/patterson-brand:wire-tokens tailwind v4` |
| Agent | `patterson-designer` | builds any Patterson-branded interface or asset |
| Agent | `brand-reviewer` | audits UI/copy against the brand |

## Quick start

```text
/patterson-brand:design a landing hero for the equine supplies line
```

The command copies `${CLAUDE_PLUGIN_ROOT}/ds` into your project as `./patterson` (merging with snapshots from other Patterson plugins), starts from `patterson/readme.md`, and adapts the content to your brief — structure, class names, tokens and voice stay intact.

## File tree

```text
ds/
├── styles.css              # single entry point — link this
├── tokens/                 # fonts · colors · typography · spacing · effects · base
├── theme.json              # canonical machine-readable theme (Theme UI spec)
├── components/             # Button, Card, Stat, Badge, Input, Select, Tabs, Alert…
│   └── */*.prompt.md       # per-component usage guides — read before using
├── _ds_bundle.js           # compiled runtime → window.PattersonCompaniesDesignSystem_1f7cbe
├── integrations/           # tailwind.css (v4) · tailwind.config.js (v3) · uno.config.js
│                           # theme-ui.js · shadcn-theme.css · README.md
├── guidelines/             # browser-openable specimen cards (colors, type, spacing…)
├── assets/brand/           # logo lockups · wave bg · photo band · value-prop art · palette page
├── assets/fonts/           # Proxima Nova woff2 (400/700/italic)
└── readme.md               # the full design guide — the authoritative source
```

## Working with it

### Plain CSS / any stack

```html
<link rel="stylesheet" href="patterson/styles.css">
<style>
  .cta {
    background: var(--pat-navy);      /* #003767 — never hardcode the hex */
    color: #fff;
    border-radius: 999px;             /* buttons are pills */
    box-shadow: var(--shadow-sm);     /* navy-tinted, never neutral black */
  }
  .cta:hover { background: var(--pat-sky); }   /* the signature interaction */
</style>
```

### React (no build step)

```html
<script src="patterson/_ds_bundle.js"></script>
<script type="text/babel">
  const { Button, Card, Stat } = window.PattersonCompaniesDesignSystem_1f7cbe;
  <Stat value="98%" label="of customers reached in 1-to-2-day shipping" />
</script>
```

### Framework adapters

Pick the one matching the consuming stack — every adapter carries the exact brand hexes, generated from `theme.json`:

```bash
ds/integrations/tailwind.css        # Tailwind v4 CSS-first @theme
ds/integrations/tailwind.config.js  # Tailwind v3 / JS preset
ds/integrations/uno.config.js       # UnoCSS theme + shortcuts (btn-primary, pat-card…)
ds/integrations/theme-ui.js         # Theme UI theme with variants
ds/integrations/shadcn-theme.css    # shadcn/ui semantic variable contract
```

## Terminal demo

Scripted with [VHS](https://github.com/charmbracelet/vhs) — render it locally:

```bash
vhs ../../demos/vhs/patterson-brand.tape    # → demos/vhs/gif/patterson-brand.gif
```

<img src="../../demos/vhs/gif/patterson-brand.gif" width="820" alt="patterson-brand terminal demo">

## Live demo

Open [`ds/guidelines/brand-palette.card.html`](ds/guidelines/brand-palette.card.html) straight from this folder (all relative assets resolve), or browse every plugin in the [demo gallery](../../demos/index.html).

## Brand quick reference

Navy `#003767` · Sky `#00A8E1` · body gray `#58585B` — always via `var(--pat-*)` tokens, never raw hexes. Proxima Nova (Figtree fallback). Pill buttons (navy → sky on hover), 10px cards, navy-tinted shadows, sky focus ring. Voice: confident, plain-spoken, “we/you”, numbers as proof. **No emoji.** Full guide: [`patterson-brand`](../patterson-brand/) → `ds/readme.md`.
