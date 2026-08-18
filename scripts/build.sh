#!/usr/bin/env bash
set -euo pipefail

trap 'printf "failed: %s (line %s)\n" "$BASH_COMMAND" "$LINENO" >&2' ERR

function need {
  ls -l "$1"
  test -x "$1"
  "$1" --version
}

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
work="${WORK:-$(mktemp -d "${RUNNER_TEMP:-/tmp}/devtools-custom.XXXXXX")}"
revision="$(<"$root/upstream")"

export PATH="$work/depot_tools:$PATH"
export DEPOT_TOOLS_UPDATE=0

readonly root work revision
readonly artifact="${ARTIFACT:-${RUNNER_TEMP:-$PWD}/devtools-frontend.tar.zst}"
readonly upstream_url='https://github.com/ChromeDevTools/devtools-frontend'
readonly depot_url='https://chromium.googlesource.com/chromium/tools/depot_tools.git'
readonly source_dir="$work/devtools/devtools-frontend"
readonly tokens="$source_dir/front_end/design_system_tokens.css"

mkdir -p "$work/devtools" "$(dirname -- "$artifact")"

[[ ! -x $work/depot_tools/gclient ]] && git clone --depth=1 "$depot_url" "$work/depot_tools"

gclient help >/dev/null
cipd version

[[ ! -d $source_dir/.git ]] && {
  git init --quiet "$source_dir"
  git -C "$source_dir" remote add origin "$upstream_url"
}

! git -C "$source_dir" cat-file -e "$revision^{commit}" && git -C "$source_dir" fetch --depth=1 origin "$revision"

head="$(git -C "$source_dir" rev-parse HEAD 2>/dev/null || true)"
[[ $head == "$revision" ]] && git -C "$source_dir" checkout -- front_end/design_system_tokens.css
[[ $head == "$revision" ]] || git -C "$source_dir" checkout --detach --force "$revision"

chrome="$(sed -n "s/^ *'chrome': '\([^']*\)'.*/\1/p" "$source_dir/DEPS")"

printf 'chromium %s\n' "$chrome"

[[ -n ${GITHUB_OUTPUT-} ]] && printf 'chrome=%s\n' "$chrome" >>"$GITHUB_OUTPUT"

[[ ! -f $work/devtools/.gclient ]] && (
  cd "$work/devtools"
  gclient config "$upstream_url" --unmanaged
)

(
  cd "$source_dir"

  [[ -x buildtools/linux64/gn ]] && echo 'skip gclient sync'
  [[ -x buildtools/linux64/gn ]] || gclient sync -v

  python3 --version

  need buildtools/linux64/gn
  need third_party/ninja/ninja
  need third_party/node/linux/node-linux-x64/bin/node

  test -f "$tokens"
  cat "$root/theme.css" >>"$tokens"

  buildtools/linux64/gn gen out/Default
  third_party/ninja/ninja -C out/Default

  test -s out/Default/gen/front_end/inspector.html

  du -sh out/Default/gen/front_end

  tar -C out/Default/gen -caf "$artifact" front_end -C "$source_dir" LICENSE
)

tar -taf "$artifact" >/dev/null

printf 'Artifact: %s\nWorkspace: %s\n' "$artifact" "$work"
