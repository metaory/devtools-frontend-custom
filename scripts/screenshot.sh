#!/bin/bash
set -euo pipefail

c0=$'\e[0m'
c1=$'\e[31m'
c2=$'\e[32m'
c3=$'\e[33m'
c4=$'\e[34m'
c5=$'\e[35m'
c6=$'\e[36m'

if [[ ! ${1-} ]]; then
  cat <<EOF
 ${c3}${c1}usage${c0} ${c4}screenshot.sh${c3} front_end
   ${c5}writes${c2} .github/assets/screenshot-{1..n}.png ${c0}
   ${c6}HUES${c0}    ${c2}270 180 90 0${c0}
   ${c6}SPREAD${c0}  ${c2}20${c0}
   ${c6}SAT${c0}     ${c2}50${c0}
   ${c6}RADIUS${c0}  ${c2}32${c0}

 ${c3}${c4}screenshot.sh${c0} ${c3}front_end${c0}
 ${c6}HUES${c0}=${c2}'270 0'${c0} ${c4}screenshot.sh${c0} ${c3}front_end${c0}
 ${c6}SPREAD${c0}=${c2}40${c0} ${c6}SAT${c0}=${c2}20${c0} ${c4}screenshot.sh${c0} ${c3}front_end${c0}
 ${c6}HUES${c0}=${c2}180${c0} ${c6}SPREAD${c0}=${c2}30${c0} ${c6}SAT${c0}=${c2}35${c0} ${c4}screenshot.sh${c0} ${c3}front_end${c0}
 ${c6}RADIUS${c0}=${c2}48${c0} ${c4}screenshot.sh${c0} ${c3}front_end${c0}
EOF
  exit 1
fi

die() { printf '%s\n' "$*" >&2 && exit 1; }
need() { command -v "$1" >/dev/null || die "missing command: $1"; }
stop() {
  kill "$1" 2>/dev/null || true
  wait "$1" 2>/dev/null || true
}

browser=${BROWSER:-chromium}
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
front=$(realpath "$1")
out="$root/.github/assets"
tmp=$(mktemp -d)
pid=
shm=()
[[ ${GITHUB_ACTIONS-} ]] && shm=(--disable-dev-shm-usage)

mkdir -p "$out"

for c in "$browser" convert identify curl jq node; do need "$c"; done

test -f "$front/devtools_app.html" || die "missing $front/devtools_app.html"

function cleanup {
  status=$?
  ((status)) && {
    port=$(head -n1 "$tmp/profile/DevToolsActivePort" 2>/dev/null || true)
    [[ $port ]] && curl -fsS "http://127.0.0.1:$port/json/list" >&2 || true
    cat "$tmp"/chrome.log "$tmp"/capture.log >&2 2>/dev/null || true
  }
  [[ ${pid-} ]] && stop "$pid"
  rm -rf "$tmp" || true
}
trap cleanup EXIT

cp "$root/scripts/screenshot.html" "$tmp/index.html"

flags=(
  --allow-file-access-from-files
  --disable-background-networking
  --disable-extensions
  --disable-gpu
  --headless=new
  --hide-scrollbars
  --no-first-run
  --no-sandbox
  --remote-allow-origins=*
  --remote-debugging-port=0
  "${shm[@]}"
)

function page_ws {
  curl -fsS "http://127.0.0.1:$1/json/list" |
    jq -r --arg p "$2" \
      '.[] | select(.type=="page" and (.url | contains($p))) | .webSocketDebuggerUrl' ||
    true
}

function chrome_ws {
  local dir=$1 pat=$2 tries=$3 check=${4-} i port ws
  for ((i = 0; i < tries; i++)); do
    [[ $check ]] && ! kill -0 "$check" 2>/dev/null && return 1
    [[ -s $dir/DevToolsActivePort ]] || {
      sleep 0.25
      continue
    }
    port=$(head -n1 "$dir/DevToolsActivePort")
    ws=$(page_ws "$port" "$pat")
    [[ $ws == ws://* ]] && {
      printf '%s\n' "$ws"
      return
    }
    sleep 0.25
  done
  return 1
}

"$browser" "${flags[@]}" \
  --user-data-dir="$tmp/profile" \
  "file://$tmp/index.html" >"$tmp/chrome.log" 2>&1 &
pid=$!

ws=$(chrome_ws "$tmp/profile" index.html 240 "$pid") ||
  die "no page websocket"

function write_app {
  cat >"$tmp/devtools.html" <<EOF
<!doctype html>
<html lang=en>
<meta charset=utf-8>
<title>DevTools</title>
<base href="file://$front/">
<script type=module src="entrypoints/devtools_app/devtools_app.js"></script>
<link href="application_tokens.css" rel=stylesheet>
<link href="design_system_tokens.css" rel=stylesheet>
<style>:root{--hue:$1;--spread:${SPREAD:-20};--sat-in:${SAT:-50}}</style>
<body class=undocked id=-blink-dev-tools style="--user-color-source:baseline-default">
EOF
}

app="file://$tmp/devtools.html?ws=${ws#ws://}"
printf 'port %s\nfrontend %s\n%s\n' "$(head -n1 "$tmp/profile/DevToolsActivePort")" "$front" "$app"

function capture {
  local name=$1 cap browser_pid cap_ws bytes t
  shift
  for t in 1 2 3; do
    cap="$tmp/cap-$name"
    rm -rf "$cap"
    mkdir -p "$cap"
    "$browser" "${flags[@]}" \
      --force-device-scale-factor=1 \
      --run-all-compositor-stages-before-draw \
      --user-data-dir="$cap" \
      --window-size=1200,800 \
      "$@" "$app" >"$cap.log" 2>&1 &
    browser_pid=$!
    cap_ws=$(chrome_ws "$cap" devtools.html 100 "$browser_pid") || cap_ws=
    rm -f "$out/screenshot-$name.png"
    [[ $cap_ws == ws://* ]] &&
      node "$root/scripts/screenshot.mjs" "$cap_ws" "$out/screenshot-$name.png" \
        >"$tmp/capture.log" 2>&1 &&
      bytes=$(stat -c%s "$out/screenshot-$name.png" 2>/dev/null || echo 0) &&
      ((bytes > 10000)) && {
      echo "$bytes bytes $name"
      stop "$browser_pid"
      return
    }
    echo "retry $name ($t)" >&2
    cat "$tmp/capture.log" "$cap.log" >&2 || true
    stop "$browser_pid"
  done
  die "failed screenshot: $name"
}

function round {
  local img=$1 r=${RADIUS:-32}
  local w h
  read -r w h < <(identify -format '%w %h\n' "$img")
  convert "$img" \
    \( -size "${w}x${h}" xc:none \
       -draw "roundrectangle 0,0 $((w-1)),$((h-1)) $r,$r" \) \
    -alpha set -compose DstIn -composite "$img"
}

function pair {
  local n=$1 light=$out/screenshot-$n-light.png dark=$out/screenshot-$n-dark.png
  local w h dx dy
  round "$light"
  round "$dark"
  read -r w h < <(identify -format '%w %h\n' "$light")
  dx=$((w * 10 / 100))
  dy=$((h * 10 / 100))
  convert -size "$((w + dx))x$((h + dy))" xc:none \
    "$light" -geometry "+0+${dy}" -composite \
    "$dark" -geometry "+${dx}+0" -composite \
    "$out/screenshot-$n.png"
  rm -f "$light" "$dark"
}

read -ra hues <<<"${HUES:-270 180 90 0}"

for i in "${!hues[@]}"; do
  write_app "${hues[i]}"
  n=$((i + 1))
  capture "$n-light" --blink-settings=preferredColorScheme=1
  capture "$n-dark" --blink-settings=preferredColorScheme=0
  pair "$n"
done

ls -lh "$out"/screenshot-*.png
