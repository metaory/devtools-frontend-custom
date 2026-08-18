#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
work="$(mktemp -d "${RUNNER_TEMP:-/tmp}/devtools-custom.XXXXXX")"
revision="$(< "$root/upstream")"
readonly root work revision
readonly artifact="${ARTIFACT:-${RUNNER_TEMP:-$PWD}/devtools-frontend.tar.zst}"
readonly upstream_url='https://github.com/ChromeDevTools/devtools-frontend'
readonly depot_url='https://chromium.googlesource.com/chromium/tools/depot_tools.git'
readonly source_dir="$work/devtools/devtools-frontend"
readonly tokens="$source_dir/front_end/design_system_tokens.css"

mkdir -p "$work/devtools" "$(dirname -- "$artifact")"

git clone --depth=1 "$depot_url" "$work/depot_tools"
export PATH="$work/depot_tools:$PATH"
export DEPOT_TOOLS_UPDATE=0
gclient help >/dev/null
cipd version

git clone --filter=blob:none "$upstream_url" "$source_dir"
git -C "$source_dir" checkout --detach "$revision"

(
  cd "$work/devtools"
  gclient config "$upstream_url" --unmanaged
)

(
  cd "$source_dir"
  gclient sync -v

  test -x buildtools/linux64/gn/gn
  test -x third_party/ninja/ninja
  test -x third_party/node/linux/node-linux-x64/bin/node
  python3 --version
  buildtools/linux64/gn/gn --version
  third_party/ninja/ninja --version
  third_party/node/linux/node-linux-x64/bin/node --version

  printf '\n/* xcrx proof theme */\n' >> "$tokens"
  cat "$root/theme.css" >> "$tokens"

  gn gen out/Default
  autoninja -C out/Default

  test -s out/Default/gen/front_end/inspector.html
  du -sh out/Default/gen/front_end
  tar -C out/Default/gen -caf "$artifact" front_end -C "$source_dir" LICENSE
)

tar -taf "$artifact" >/dev/null
printf 'Artifact: %s\nWorkspace: %s\n' "$artifact" "$work"
