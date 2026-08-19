#!/bin/bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly dash='https://chromiumdash.appspot.com/fetch_releases'

spec="${REF:-${UPSTREAM:-$(<"$root/upstream")}}"
spec="${spec//$'\n'/}"
chrome=
milestone=
ref=$spec

[[ $spec == stable || $spec == beta || $spec == canary ]] && {
  read -r build chrome milestone <<<"$(
    curl -fsSL -A devtools-frontend-custom \
      "$dash?channel=$spec&platform=Linux&num=1" |
      jq -r '.[0] | "\(.version|split(".")|.[2]) \(.version) \(.milestone)"'
  )"
  test -n "$build"
  ref="chromium/$build"
}

printf 'ref=%s\nchrome=%s\nmilestone=%s\n' "$ref" "$chrome" "$milestone"

[[ -z ${GITHUB_OUTPUT-} ]] || printf 'ref=%s\nchrome=%s\nmilestone=%s\n' \
  "$ref" "$chrome" "$milestone" >>"$GITHUB_OUTPUT"
