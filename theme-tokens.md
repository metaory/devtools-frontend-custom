# theme-tokens

Per-token CSS consumers for the 30 color overrides in `theme.css`.

Method matches `theme-usage.md`: exact `var(--token)` in `*.css` / `*.css.js` under `~/.local/share/chromium/front_end`. `design_system_tokens.css` definitions excluded.

Upstream values are from `design_system_tokens.css` light `:root` and `.theme-with-dark-background`. `theme.css` HSL values are the live overrides.

Stylesheet paths drop the `.css.js` suffix.

---

## `--sys-color-cdt-base-container`

| | |
|---|---|
| Light | `hsl(286 100% 90%)` |
| Dark | `hsl(156 100% 51%)` |
| Upstream | light `neutral99`, dark `base-container` |
| CSS | 115 files, 228 hits |
| Aliases | `--icon-gap-default` |

Default chrome fill. `body { background }` in `ui/legacy/inspectorCommon`. Also dialogs, inputs, trees, flamecharts, tab strips.

**Shared:** `inspectorCommon` `toolbar` `tabbedPane` `dialog` `filter` `infobar` `listWidget` `rootView` `softDropDown` `suggestBox` `textPrompt` `reportView` plus buttons, menus, dataGrid, flameChart, overviewGrid.

**Panels:** AI assistance, animation, application, changes, console, coverage, CSS overview, developer resources, elements, emulation, issues, layers, lighthouse, linear memory, media, network, profiler, recorder, search, security, settings, sources, timeline, web audio, webauthn.

Dark value is the highest-contrast override in `theme.css`. It fills the whole DevTools surface.

---

## `--sys-color-cdt-base`

| | |
|---|---|
| Light | not set in `theme.css` |
| Dark | `hsl(258 100% 12%)` |
| Upstream | light `base-container`, dark `base` |
| CSS | 5 files, 5 hits |

Toolbar filter underlay (`inspectorCommon` `::before`). Also `searchView`, `watchExpressionsSidebarPane`, `searchableView`.

Dark upstream sets `cdt-base` from `base`, so the `base` override also feeds this unless `cdt-base` is set (it is).

---

## `--sys-color-base`

| | |
|---|---|
| Light | `hsl(275 100% 86%)` |
| Dark | `hsl(261 100% 15%)` |
| Upstream | light `neutral98`, dark `secondary25` |
| CSS | 4 files, 4 hits |
| Aliases | dark `--sys-color-cdt-base` (upstream), dark `--app-color-toolbar-background` |

Timeline insight cards: `baseInsightComponent`, `sidebarAnnotationsTab`, `timelineFlameChartView`.

---

## `--sys-color-on-base`

| | |
|---|---|
| Light | `hsl(259 73% 15%)` |
| Dark | `hsl(285 100% 96%)` |
| Upstream | light `neutral10`, dark `neutral90` |
| CSS | 2 files, 2 hits |

Text on `base`. Timeline `cwvMetrics`, `baseInsightComponent`.

---

## `--sys-color-surface`

| | |
|---|---|
| Light | `hsl(300 100% 95%)` |
| Dark | `hsl(251 100% 7%)` |
| Upstream | `neutral99` / `neutral10` |
| CSS | 8 files, 11 hits |
| Aliases | `--color-grid-default` `--app-color-menu-background` `--app-color-navigation-drawer-label-selected` (some themes) |

AI dialogs, ads view, What's New, switch, color picker, dataGrid.

Not the page background. That is `cdt-base-container`.

---

## `--sys-color-surface1`

| | |
|---|---|
| Light | `hsl(296 100% 92%)` |
| Dark | `hsl(260 100% 14%)` |
| CSS | 18 files, 23 hits |
| Aliases | `--icon-gap-toolbar` `--color-grid-stripe` |

Striped tables and alt-row fills. Network log / timing / headers, dataGrid, heap profiler, device mode, AI chat, bezier editor.

---

## `--sys-color-surface2`

| | |
|---|---|
| Light | `hsl(285 100% 87%)` |
| Dark | `hsl(266 100% 19%)` |
| CSS | 15 files, 17 hits |
| Aliases | dark `--app-color-card-background` |

Cards and nested panes: Elements styles / layout / fonts, issues tree, timeline sidebar, markdown code blocks, view containers, AI walkthrough.

---

## `--sys-color-surface3`

| | |
|---|---|
| Light | `hsl(276 100% 83%)` |
| Dark | `hsl(270 100% 24%)` |
| CSS | 14 files, 24 hits |
| Aliases | dark `--app-color-menu-background` |

AI chat chrome, combined diff, breakpoint dialog, timeline metrics / insight cards / history, What's New, listWidget.

---

## `--sys-color-surface4`

| | |
|---|---|
| Light | `hsl(272 100% 78%)` |
| Dark | `hsl(272 100% 27%)` |
| CSS | 7 files, 7 hits |
| Aliases | `--app-color-toolbar-background`; upstream `--sys-color-omnibox-container` `--sys-color-base-container` |

Dialogs and elevated chrome: AI opt-in, FRE, GDP signup, console insight, markdown. Indirectly tints `base-container` via upstream alias.

---

## `--sys-color-surface5`

| | |
|---|---|
| Light | `hsl(267 100% 75%)` |
| Dark | `hsl(275 100% 31%)` |
| CSS | 7 files, 10 hits |

Highest lift: AI export / walkthrough / chat, console insight teaser, timeline overlays and status dialog, diff view.

---

## `--sys-color-header-container`

| | |
|---|---|
| Light | `hsl(275 100% 84%)` |
| Dark | `hsl(262 100% 18%)` |
| Upstream | light `primary95`, dark `neutral25` |
| CSS | 1 file, 1 hit |

`panels/whats_new/releaseNoteView` only.

---

## `--sys-color-on-surface`

| | |
|---|---|
| Light | `hsl(259 73% 15%)` |
| Dark | `hsl(285 100% 96%)` |
| Upstream | `neutral10` / `neutral90` |
| CSS | 102 files, 183 hits |
| Aliases | `--text-primary` `--icon-default-hover` `--app-color-navigation-drawer-label-selected`; upstream `--sys-color-token-variable` `--sys-color-token-property` |

Default foreground. `body { color }` in `inspectorCommon`. Also inputs, reports, breadcrumbs, settings, recorder, AI chat.

Feeds syntax tokens for variables and properties.

**Shared:** `inspectorCommon` `filter` `infobar` `popover` `reportView` `searchableView` `tabbedPane` `textPrompt` plus menus, markdown, tooltips, cards.

**Panels:** accessibility, AI, animation, application, browser debugger, console, CSS overview, elements, emulation, explain, issues, linear memory, network, profiler, protocol monitor, recorder, search, sensors, settings, sources, timeline, web audio.

---

## `--sys-color-on-surface-subtle`

| | |
|---|---|
| Light | `hsl(268 60% 33%)` |
| Dark | `hsl(268 80% 80%)` |
| Upstream | `neutral30` / `neutral80` |
| CSS | 57 files, 91 hits |
| Aliases | `--icon-default` `--icon-file-default` `--icon-folder-primary` `--icon-request` `--ui-text` |

Secondary labels and default icon color. Filter chrome, trees, report keys, search, AI disclaimers, Elements styles, network headers.

---

## `--sys-color-primary`

| | |
|---|---|
| Light | `hsl(281 100% 45%)` |
| Dark | `hsl(290 100% 74%)` |
| Upstream | `primary40` / `primary80` |
| CSS | 98 files, 173 hits |
| Aliases | `--text-link`; one theme `--app-color-navigation-drawer-label-selected` |

Links (`devtools-link` via `--text-link`), filled primary buttons, selected labels, spinners, switches, infobar actions, flamechart accents.

**Shared:** `button` `textButton` `floatingButton` `adorner` `spinner` `switch` `linkifier` `inspectorCommon` `infobar` `tabbedPane` `filter` `chartViewport` `flameChart` `pieChart`.

**Panels:** AI, animation, application reports, autofill, changes, console, CSS overview, elements, event listeners, explain, issues, recorder, settings, sources headers, timeline insights.

---

## `--sys-color-on-primary`

| | |
|---|---|
| Light | `hsl(285 100% 98%)` |
| Dark | `hsl(258 78% 11%)` |
| Upstream | `primary100` / `primary20` |
| CSS | 15 files, 29 hits |

Foreground on a primary fill. Checkboxes, radios, filled buttons, adorners, tabbed pane, console insight teaser, CSS overview, timeline overlay, switch.

Must stay readable on `primary`.

---

## `--sys-color-primary-bright`

| | |
|---|---|
| Light | `hsl(282 100% 50%)` |
| Dark | `hsl(290 100% 67%)` |
| Upstream | `primary50` / `primary70` |
| CSS | 14 files, 30 hits |
| Aliases | `--icon-action` `--icon-arrow-main-thread` `--icon-folder-deployed` `--icon-info` `--icon-link` `--icon-primary` `--icon-request-response` `--icon-toggled` |

Icon accent, not body text. Checkbox / radio `accent-color`, toggled toolbar buttons, toolbar toggle-dot, primary-toggle icons.

Direct CSS: `inspectorCommon` `button` `checkbox` `checkboxTextLabel` `filteredListWidget` `resourcesPanel` `cssOverviewCompletedView` `computedStyleProperty` `computedStyleTrace` `mediaQueryInspector` `lighthouseDialog` `screencastView`.

Not referenced by other `--sys-*` tokens.

---

## `--sys-color-tonal-container`

| | |
|---|---|
| Light | `hsl(177 100% 45%)` |
| Dark | `hsl(178 100% 19%)` |
| Upstream | `primary90` / `secondary30` |
| CSS | 60 files, 85 hits |
| Aliases | `--icon-gap-focus-selected` `--color-grid-focus-selected` |

Selected / highlighted fill: tree rows, dataGrid, tabs, breadcrumbs, filter chips, Elements styles, network header editor, sources breakpoints / call stack / threads, timeline tree, buttons.

Light value is cyan. It reads as selection, not page chrome.

---

## `--sys-color-on-tonal-container`

| | |
|---|---|
| Light | `hsl(213 100% 11%)` |
| Dark | `hsl(176 82% 81%)` |
| Upstream | `primary10` / `secondary90` |
| CSS | 27 files, 38 hits |

Foreground on `tonal-container`. Same surfaces: trees, dataGrid, tabs, buttons, network headers, console, changes, CSS overview sidebar, linear memory.

Must stay readable on `tonal-container`.

---

## `--sys-color-neutral-container`

| | |
|---|---|
| Light | `hsl(242 100% 91%)` |
| Dark | `hsl(256 77% 19%)` |
| Upstream | `neutral95` / `neutral25` |
| CSS | 29 files, 31 hits |
| Aliases | `--icon-gap-inactive` |

Inactive / unselected chips and gaps. Tree outline, dataGrid, suggest box, animation timeline, network headers / timing, sensors, keybinds, watch expressions, color picker.

---

## `--sys-color-divider`

| | |
|---|---|
| Light | `hsl(307 100% 47%)` |
| Dark | `hsl(302 100% 50%)` |
| Upstream | light `primary90`, dark `secondary35` |
| CSS | 142 files, 280 hits |

Highest file count. 1px borders, splitters, section rules, toolbar separators, tree lines.

Saturated magenta/fuchsia in `theme.css`, so hairlines stay very visible.

Almost every panel. Shared: `inspectorCommon` `splitWidget` `tabbedPane` `toolbar` `filter` `listWidget` `viewContainers` `dataGrid` `softContextMenu` `searchableView`.

---

## `--sys-color-divider-prominent`

| | |
|---|---|
| Light | `hsl(307 100% 42%)` |
| Dark | `hsl(300 100% 61%)` |
| Upstream | light `primary70`, dark `neutral50` |
| CSS | 0 files, 0 hits |

Unused in CSS. Changing it does not restyle DevTools chrome.

---

## `--sys-color-state-focus-ring`

| | |
|---|---|
| Light | `hsl(178 100% 31%)` |
| Dark | `hsl(177 100% 44%)` |
| Upstream | `primary40` / `primary80` |
| CSS | 62 files, 94 hits |
| Aliases | `--legacy-focus-ring-active-shadow` |

Keyboard focus. Inputs, checkboxes, buttons, trees, dataGrid, flameChart, tabbed pane, AI chat, Elements tree, lighthouse, recorder, search, What's New.

Cyan in `theme.css`, distinct from `primary`.

---

## `--sys-color-state-focus-select`

| | |
|---|---|
| Light | `hsl(177 100% 40%)` |
| Dark | `hsl(178 100% 24%)` |
| Upstream | `primary80` / `secondary50` |
| CSS | 5 files, 5 hits |

Selected cell / node fill: `treeoutline` `treeOutline` `dataGrid` `linearMemoryViewer` `autofillView`.

---

## `--sys-color-state-text-highlight`

| | |
|---|---|
| Light | `hsl(177 100% 44%)` |
| Dark | `hsl(290 100% 74%)` |
| Upstream | `primary40` / `primary80` |
| CSS | 2 files, 2 hits |

`::selection` background in `inspectorCommon`. Companion `--sys-color-state-on-text-highlight` is not in `theme.css`.

Dark value matches dark `primary`.

---

## `--sys-color-token-keyword`

| | |
|---|---|
| Light | `hsl(301 100% 34%)` |
| Dark | `hsl(300 100% 67%)` |
| Upstream | `pink40` / `purple60` |
| CSS | 1 file, 1 hit |

`ui/components/code_highlighter/codeHighlighter` `.token-keyword`. Sources, Console, and other editors that use that highlighter.

---

## `--sys-color-token-string`

| | |
|---|---|
| Light | `hsl(0 100% 39%)` |
| Dark | `hsl(33 100% 50%)` |
| Upstream | `error40` / `orange70` |
| CSS | 1 file, 1 hit |

`codeHighlighter` `.token-string`.

---

## `--sys-color-token-number`

| | |
|---|---|
| Light | `hsl(124 100% 23%)` |
| Dark | `hsl(129 86% 60%)` |
| Upstream | `blue40` / `green90` |
| CSS | 1 file, 1 hit |

`codeHighlighter` `.token-number`.

---

## `--sys-color-token-comment`

| | |
|---|---|
| Light | `hsl(177 100% 22%)` |
| Dark | `hsl(178 100% 38%)` |
| Upstream | `green40` / `neutral70` |
| CSS | 4 files, 4 hits |

`codeHighlighter` `.token-comment`, `inspectorCommon` `.webkit-html-comment`, `objectValue`.

---

## `--sys-color-token-tag`

| | |
|---|---|
| Light | `hsl(263 100% 46%)` |
| Dark | `hsl(242 100% 81%)` |
| Upstream | `pink30` / `blue70` |
| CSS | 14 files, 18 hits |

HTML/XML tags: `codeHighlighter`, `inspectorCommon` `.webkit-html-tag`, Elements tree / breadcrumbs / layout pane, `nodeText`, `domLinkifier`, event listeners, linear memory chips, screencast, `smallBubble`, `objectValue`.

---

## `--sys-color-token-attribute`

| | |
|---|---|
| Light | `hsl(188 100% 28%)` |
| Dark | `hsl(184 100% 48%)` |
| Upstream | `orange40` / `blue80` |
| CSS | 10 files, 14 hits |

Attribute names: `codeHighlighter`, `inspectorCommon` `.webkit-html-attribute-name`, breadcrumbs, accessibility tree, `nodeText`, `domLinkifier`, screencast, `smallBubble`.

Attribute values use `--sys-color-token-attribute-value`, which is not in `theme.css`.
