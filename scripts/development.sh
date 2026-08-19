#!/bin/bash

echo downloading latest action run artifact in 3s ...

sleep 3

readonly localpath="$HOME/.local/share/chromium"
readonly artifact='devtools-frontend.tar.zst'

GH_DEBUG=1 gh run download -R metaory/devtools-frontend-custom \
  -n $artifact \
  "$(gh run list -R metaory/devtools-frontend-custom \
    --workflow Build --status success --limit 1 \
    --json databaseId --jq '.[0].databaseId')"

mkdir -p "$localpath" 2>/dev/null

tar -xaf $artifact -C "$localpath"

rm -r $artifact

chromium --custom-devtools-frontend="$localpath/front_end" --user-data-dir=/tmp/chromium-custom google.com
