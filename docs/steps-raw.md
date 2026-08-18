# Build steps

The authoritative entry point is `scripts/build.sh`. It builds an immutable
upstream revision without storing the DevTools source in this repository.

## Environment

GitHub Actions uses:

- Ubuntu 22.04 on x86-64
- Python 3.11 selected by `actions/setup-python`
- system Git
- current `depot_tools`
- Node, GN, Ninja, and build tools provisioned by `gclient sync`

See [libs.md](libs.md) for ownership and verification details.

Local proxy variables may be inherited when needed. The GitHub workflow does
not configure a proxy.

## Upstream revision

`upstream` contains the full commit SHA from the
`ChromeDevTools/devtools-frontend` GitHub mirror:

```sh
revision=$(< upstream)
```

The workflow never builds a moving branch.

## Build pipeline

The script performs these steps in a new temporary workspace:

```sh
git clone --depth=1 \
  https://chromium.googlesource.com/chromium/tools/depot_tools.git \
  depot_tools

export PATH="$PWD/depot_tools:$PATH"
export DEPOT_TOOLS_UPDATE=0

mkdir -p devtools
git clone --filter=blob:none \
  https://github.com/ChromeDevTools/devtools-frontend \
  devtools/devtools-frontend

git -C devtools/devtools-frontend checkout --detach "$revision"

(
  cd devtools
  gclient config \
    https://github.com/ChromeDevTools/devtools-frontend \
    --unmanaged
)

cd devtools/devtools-frontend
gclient sync -v
cat /path/to/custom/theme.css >> front_end/design_system_tokens.css
gn gen out/Default
autoninja -C out/Default
```

Current upstream `npm run build` wraps the same GN initialization and
autoninja build. They are explicit here so each failure retains its native log.

The generated frontend is:

```text
out/Default/gen/front_end
```

`docs/steps-origin.md` is historical upstream reference material. Its
`out/Default/resources/inspector` path is obsolete.

## Theme

`theme.css` is appended after upstream token declarations, so the cascade
overrides them without copying the complete upstream stylesheet. The proof
theme covers default and `.theme-with-dark-background` states.

Primary tokens:

```css
--sys-color-cdt-base-container
--sys-color-cdt-base
--sys-color-surface
--sys-color-surface1
--sys-color-surface2
--sys-color-surface3
--sys-color-on-surface
--sys-color-on-surface-subtle
--sys-color-divider
--sys-color-tonal-container
--sys-color-on-tonal-container
```

## Run

`.github/workflows/build.yml` runs on push and on manual dispatch. It uploads
`devtools-frontend.tar.zst` directly as the workflow artifact.

For a local build:

```sh
ARTIFACT="$PWD/devtools-frontend.tar.zst" scripts/build.sh
```

The archive contains `front_end/` and the upstream BSD license. Extract and
load it with Chromium:

```sh
tar -xaf devtools-frontend.tar.zst

chromium \
  --user-data-dir="$(mktemp -d)" \
  --custom-devtools-frontend="file://$(realpath front_end)"
```
