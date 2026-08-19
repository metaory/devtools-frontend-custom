# theme-usage

High-level map of every color token overridden in `theme.css`, and where CSS actually reads it.

Source: extracted frontend at `~/.local/share/chromium/front_end`.
Counted exact `var(--token)` in `*.css` and `*.css.js`. Definitions in `design_system_tokens.css` are excluded. Prefix matches are excluded (`--sys-color-base` does not count `--sys-color-base-container`).

`theme.css` is concatenated onto `design_system_tokens.css`. Later `:root` rules win. These overrides paint the live UI.

## Ranked by CSS blast radius

| Token | Files | Hits | Paints |
|---|---:|---:|---|
| `--sys-color-divider` | 142 | 280 | Borders, splitters, list rules |
| `--sys-color-cdt-base-container` | 115 | 228 | Default panel / page background |
| `--sys-color-on-surface` | 102 | 183 | Default text |
| `--sys-color-primary` | 98 | 173 | Links, filled buttons, selected chrome |
| `--sys-color-state-focus-ring` | 62 | 94 | Focus outlines |
| `--sys-color-on-surface-subtle` | 57 | 91 | Secondary text, default icons |
| `--sys-color-tonal-container` | 60 | 85 | Selected row / chip / tab fill |
| `--sys-color-on-tonal-container` | 27 | 38 | Text on tonal fill |
| `--sys-color-neutral-container` | 29 | 31 | Inactive chips, icon gaps |
| `--sys-color-primary-bright` | 14 | 30 | Icons, checkboxes, toggles |
| `--sys-color-on-primary` | 15 | 29 | Text on filled primary |
| `--sys-color-surface3` | 14 | 24 | Cards, insight panels, menus (dark) |
| `--sys-color-surface1` | 18 | 23 | Grid stripes, alt rows |
| `--sys-color-token-tag` | 14 | 18 | HTML tags, DOM tree |
| `--sys-color-surface2` | 15 | 17 | Cards, code blocks, drawers |
| `--sys-color-token-attribute` | 10 | 14 | HTML attribute names |
| `--sys-color-surface` | 8 | 11 | Menus, grids, dialogs |
| `--sys-color-surface5` | 7 | 10 | Overlays, teasers |
| `--sys-color-surface4` | 7 | 7 | Toolbar, dialogs, omnibox |
| `--sys-color-cdt-base` | 5 | 5 | Toolbar filter underlay |
| `--sys-color-state-focus-select` | 5 | 5 | Selected tree / grid cell |
| `--sys-color-base` | 4 | 4 | Timeline insights (and dark `cdt-base`) |
| `--sys-color-token-comment` | 4 | 4 | Comments in highlighter + Elements |
| `--sys-color-on-base` | 2 | 2 | Text on `base` |
| `--sys-color-state-text-highlight` | 2 | 2 | `::selection` |
| `--sys-color-header-container` | 1 | 1 | What's New header |
| `--sys-color-token-keyword` | 1 | 1 | Code highlighter |
| `--sys-color-token-number` | 1 | 1 | Code highlighter |
| `--sys-color-token-string` | 1 | 1 | Code highlighter |
| `--sys-color-divider-prominent` | 0 | 0 | Unused in CSS |

## What to tune first

Changing these five redraws almost the whole chrome:

1. **`--sys-color-cdt-base-container`** is `body` background in `inspectorCommon.css`. Every panel inherits it. Dark override in `theme.css` is currently a neon green (`hsl(156 100% 51%)`). That is the loudest token in the set.
2. **`--sys-color-on-surface`** is default text color on that background.
3. **`--sys-color-divider`** is almost every 1px border.
4. **`--sys-color-primary`** is links, primary buttons, selected labels. Aliased to `--text-link`.
5. **`--sys-color-tonal-container`** + **`--sys-color-on-tonal-container`** are selected rows, chips, and some tabs.

## Groups

### Chrome fill

| Token | Role |
|---|---|
| `cdt-base-container` | Page / panel / dialog fill. Also `--icon-gap-default`. |
| `cdt-base` | Dark-only in `theme.css`. Toolbar filter backdrop. Upstream dark aliases it to `base`. |
| `surface` | Menus, default grid cells. Also `--color-grid-default`, `--app-color-menu-background`. |
| `base` / `on-base` | Timeline insight cards. Dark: `cdt-base` follows `base`. |

### Accent

| Token | Role |
|---|---|
| `primary` | Links, filled buttons, selected nav text. `--text-link`. |
| `on-primary` | Glyph / label on a primary fill. |
| `primary-bright` | Icon accent. Feeds `--icon-action`, `--icon-primary`, `--icon-toggled`, `--icon-link`, checkbox `accent-color`, toolbar toggle dots. |

### Selection / focus

| Token | Role |
|---|---|
| `tonal-container` | Selected row / chip fill. `--icon-gap-focus-selected`, `--color-grid-focus-selected`. |
| `on-tonal-container` | Foreground on that fill. |
| `state-focus-ring` | Keyboard focus ring. `--legacy-focus-ring-active-shadow`. |
| `state-focus-select` | Selected tree / data-grid cell. |
| `state-text-highlight` | `::selection` background. |

### Elevation (`surface1` … `surface5`)

Stepped surfaces. Higher number is more lifted.

- `surface1`: striped grids, `--icon-gap-toolbar`, `--color-grid-stripe`
- `surface2`: cards, markdown code, `--app-color-card-background` (dark)
- `surface3`: insight cards, `--app-color-menu-background` (dark)
- `surface4`: toolbar (`--app-color-toolbar-background`), also upstream `--sys-color-base-container` and `--sys-color-omnibox-container`
- `surface5`: overlays, AI teasers, status dialogs

### Syntax

Used by `codeHighlighter` plus Elements / DOM chrome:

| Token | CSS home |
|---|---|
| `token-keyword` `token-number` `token-string` | highlighter only |
| `token-comment` | highlighter + Elements HTML comments |
| `token-tag` | highlighter + DOM tree, breadcrumbs, screencast |
| `token-attribute` | highlighter + HTML attribute names |

`token-variable` and `token-property` follow `--sys-color-on-surface` inside `design_system_tokens.css`. Changing `on-surface` recolors those too.

### Sparse / dead in CSS

- `header-container`: What's New only
- `divider-prominent`: no `var()` in CSS

## Alias leak

These `theme.css` tokens also drive app tokens in `application_tokens.css`. Editing the sys token recolors every alias.

| Sys token | App aliases |
|---|---|
| `primary-bright` | `--icon-action` `--icon-arrow-main-thread` `--icon-folder-deployed` `--icon-info` `--icon-link` `--icon-primary` `--icon-request-response` `--icon-toggled` |
| `on-surface-subtle` | `--icon-default` `--icon-file-default` `--icon-folder-primary` `--icon-request` `--ui-text` |
| `on-surface` | `--icon-default-hover` `--text-primary` `--app-color-navigation-drawer-label-selected` |
| `primary` | `--text-link` `--app-color-navigation-drawer-label-selected` (one theme) |
| `cdt-base-container` | `--icon-gap-default` |
| `tonal-container` | `--icon-gap-focus-selected` `--color-grid-focus-selected` |
| `surface4` | `--app-color-toolbar-background` plus upstream `--sys-color-base-container` `--sys-color-omnibox-container` |

See `theme-tokens.md` for per-token stylesheet lists.
