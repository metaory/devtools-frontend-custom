#!/usr/bin/env bash
set -euo pipefail
trap 'printf "failed: %s (line %s)\n" "$BASH_COMMAND" "$LINENO" >&2' ERR

need() {
  ls -l "$1"
  test -x "$1"
  "$1" --version
}

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

  python3 --version
  need buildtools/linux64/gn
  need third_party/ninja/ninja
  need third_party/node/linux/node-linux-x64/bin/node

  test -f "$tokens"
  printf '\n/* xcrx proof theme */\n' >> "$tokens"
  cat "$root/theme.css" >> "$tokens"
  grep -F -- '--xcrx-theme: proof' "$tokens"

  buildtools/linux64/gn gen out/Default
  third_party/ninja/ninja -C out/Default

  test -s out/Default/gen/front_end/inspector.html
  du -sh out/Default/gen/front_end
  tar -C out/Default/gen -caf "$artifact" front_end -C "$source_dir" LICENSE
)

tar -taf "$artifact" >/dev/null
printf 'Artifact: %s\nWorkspace: %s\n' "$artifact" "$work"
