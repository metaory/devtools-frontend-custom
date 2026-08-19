#!/bin/bash
set -euo pipefail

readonly repo='metaory/devtools-frontend-custom'
readonly dest="$HOME/.local/share/chromium"
readonly artifact='devtools-frontend.tar.zst'

tar=${1-}

[[ $tar ]] || {
  work="$(mktemp -d)"
  trap 'rm -rf "$work"' EXIT
  tar="$work/$artifact"

  echo 'downloading latest action run artifact in 3s ...'
  sleep 3

  run="$(gh run list -R "$repo" \
    --workflow Build \
    --status success \
    --limit 1 \
    --json databaseId \
    --jq '.[0].databaseId // empty')"

  [[ $run ]]

  size="$(gh api "repos/$repo/actions/runs/$run/artifacts" \
    --jq ".artifacts[] | select(.name==\"$artifact\") | .size_in_bytes")"

  printf 'run %s\nwork %s\n' "$run" "$work"

  [[ $size ]]

  printf 'size %s\n' "$(numfmt --to=iec "$size")"

  GH_DEBUG=1 gh run download -R "$repo" -n "$artifact" -D "$work" "$run"

  ls -lh "$tar"
}

rm -rf "$dest/front_end"
mkdir -p "$dest"
tar -xaf "$tar" -C "$dest"

[[ ${1-} ]] && rm -- "$tar"

printf 'extract %s\n' "$dest"

chromium \
  --custom-devtools-frontend="$dest/front_end" \
  --user-data-dir=/tmp/chromium-custom \
  --auto-open-devtools-for-tabs \
  google.com
