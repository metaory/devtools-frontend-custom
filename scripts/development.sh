#!/bin/bash
set -euo pipefail

c0=$'\e[0m'
c1=$'\e[31m'
c2=$'\e[32m'
c3=$'\e[33m'
c4=$'\e[34m'
c5=$'\e[35m'
c6=$'\e[36m'

cat <<EOF
 ${c3}${c1}usage${c0} ${c4}development.sh${c3} [-f|--fetch] [tar]
   ${c5}default tar:${c2} /tmp/devtools-frontend.tar.zst
   ${c3}-f${c6}  download even if tar exists ${c0}
EOF

readonly repo='metaory/devtools-frontend-custom'
readonly dest="$HOME/.local/share/chromium"
readonly artifact='devtools-frontend.tar.zst'
readonly frontend="file://$dest/front_end"
readonly tokens="$dest/front_end/design_system_tokens.css"
readonly base="$dest/design_system_tokens.base.css"
readonly mark='/* === theme.css === */'
declare p fetch path

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

for a; do
  case $a in
  -f | --fetch) fetch=1 ;;
  *) path=$a ;;
  esac
done

tar=${path:-/tmp/$artifact}

[[ ${fetch-} || -s $tar || ! ${path-} ]] || exit 1
[[ ${fetch-} || ! -s $tar ]] && {
  echo -e "\n$c3 downloading latest action run artifact in 3s ... $c0\n"
  sleep 3

  run="$(gh run list -R "$repo" \
    --workflow Build \
    --status success \
    --limit 1 \
    --json databaseId \
    --jq '.[0].databaseId // empty')"

  [[ $run ]]

  read -r id size < <(gh api "repos/$repo/actions/runs/$run/artifacts" \
    --jq ".artifacts[] | select(.name==\"$artifact\") | \"\(.id) \(.size_in_bytes)\"")

  printf 'run %s\ntar %s\n' "$run" "$tar"

  [[ $id && $size ]]

  printf 'size %s\n' "$(numfmt --to=iec "$size")"

  url="$(curl -fsS -o /dev/null -w '%{redirect_url}' \
    -H "Authorization: Bearer $(gh auth token)" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/$repo/actions/artifacts/$id/zip")"

  [[ $url ]]

  host=$(ip -color=never -4 route get 1 | awk 'NR==1 {print $3}')

  [[ $host ]] && timeout 0.5 bash -c "echo >/dev/tcp/$host/10808" 2>/dev/null &&
    p="socks5h://$host:10808" || true

  [[ $p ]] && printf 'proxy %s\n' "$p"

  avg=$(curl -fL ${p:+--proxy} ${p:+"$p"} \
    -o "$tar" "$url" \
    -w '%{speed_download}')
  printf 'avg %s\n' "$(numfmt --to=iec --suffix=B/s "$avg")"

  ls -lh "$tar"
}

[[ -f $tokens && -f $base && ! $tar -nt $base ]] || {
  rm -rf "$dest/front_end"
  mkdir -p "$dest"
  tar -xaf "$tar" -C "$dest"
  printf 'extract %s\n' "$dest"
}

awk -v m="$mark" '
  $0 == m { exit }
  /^:root \{/ { if (++n == 2) exit }
  { print }
' "$tokens" >"$base"
{ printf '\n%s\n' "$mark"
  [[ ${HUE-} =~ ^[0-9]+$ ]] || HUE=270
  sed "s/\"\$HUE\"/$HUE/" "$root/theme.css"
} | cat "$base" - >"$tokens"
printf 'theme %s\nfrontend %s\n' "$tokens" "$frontend"

pgrep -f 'user-data-dir=/tmp/chromium-custom' >/dev/null && {
  printf 'reload DevTools\n'
  exit
}

chromium \
  --custom-devtools-frontend="$frontend" \
  --user-data-dir=/tmp/chromium-custom \
  --auto-open-devtools-for-tabs \
  google.com
