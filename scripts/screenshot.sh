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
   ${c5}writes${c2} .github/assets/screenshot-{1..n}-{light,dark}.png ${c0}
   ${c6}HUES${c0}    ${c2}270 180 90 0${c0}
   ${c6}SPREAD${c0}  ${c2}20${c0}
   ${c6}SAT${c0}     ${c2}50${c0}

 ${c3}${c4}screenshot.sh${c0} ${c3}front_end${c0}
 ${c6}HUES${c0}=${c2}'270 0'${c0} ${c4}screenshot.sh${c0} ${c3}front_end${c0}
 ${c6}SPREAD${c0}=${c2}40${c0} ${c6}SAT${c0}=${c2}20${c0} ${c4}screenshot.sh${c0} ${c3}front_end${c0}
 ${c6}HUES${c0}=${c2}180${c0} ${c6}SPREAD${c0}=${c2}30${c0} ${c6}SAT${c0}=${c2}35${c0} ${c4}screenshot.sh${c0} ${c3}front_end${c0}
EOF
  exit 1
fi

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

browser=${BROWSER:-chromium}
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
front=$(realpath "$1")
out="$root/.github/assets"
tmp=$(mktemp -d)
pid=
ws=

mkdir -p "$out"

need() { command -v "$1"; }
need "$browser"
need curl
need jq

test -f "$front/devtools_app.html" || die "missing $front/devtools_app.html"

function cleanup {
  status=$?
  ((status)) && {
    echo "--- chrome.log ---" >&2
    cat "$tmp/chrome.log" >&2 || true
  }
  [[ ${pid-} ]] && {
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
  }
  rm -rf "$tmp" || true
}
trap cleanup EXIT

cat >"$tmp/index.html" <<'HTML'
<!doctype html>
<meta charset=utf-8>
<title>Custom DevTools</title>
<style>
:root { color-scheme: light dark }
body { font: 18px system-ui; margin: 2rem }
h1 { color: hsl(260 90% 40%) }
.card { padding: 1rem; border: 4px solid hsl(270 90% 40%); border-radius: 16px }
</style>
<main class=card>
  <h1>Custom DevTools</h1>
  <p id=out>ready</p>
  <button>inspect</button>
</main>
<script>
  const n = { theme: 'custom', tokens: ['keyword', 'string', 42] }
  console.log('hello', n)
  document.getElementById('out').textContent = JSON.stringify(n)
</script>
HTML

"$browser" \
  --disable-background-networking \
  --disable-extensions \
  --disable-gpu \
  --headless=new \
  --hide-scrollbars \
  --no-first-run \
  --no-sandbox --disable-dev-shm-usage \
  --remote-allow-origins=* \
  --remote-debugging-port=0 \
  --user-data-dir="$tmp/profile" \
  --custom-devtools-frontend="file://$front" \
  "file://$tmp/index.html" >"$tmp/chrome.log" 2>&1 &

pid=$!

sleep 2
for _ in {1..15}; do
  [[ -s $tmp/profile/DevToolsActivePort ]] && break
  kill -0 "$pid" 2>/dev/null || die "chrome exited before debug port"
  sleep 1
done

[[ -s $tmp/profile/DevToolsActivePort ]] || die "timeout waiting for DevToolsActivePort"
port=$(head -n1 "$tmp/profile/DevToolsActivePort")
[[ $port ]] || die "empty DevToolsActivePort"

for _ in {1..10}; do
  ws=$(curl -fsS "http://127.0.0.1:$port/json/list" |
    jq -r '.[] | select(.type=="page" and (.url | test("index.html"))) | .webSocketDebuggerUrl' || true)
  [[ $ws == ws://* ]] && break
  sleep 0.5
done

[[ $ws == ws://* ]] || die "no page websocket on :$port"

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
<script type=module>await new Promise(r=>setTimeout(r,4_000))</script>
<body class=undocked id=-blink-dev-tools style="--user-color-source:baseline-default">
EOF
}

app="file://$tmp/devtools.html?ws=${ws#ws://}"

printf 'port %s\nfrontend %s\n%s\n' "$port" "$front" "$app"

function capture {
  for t in 1 2 3; do
    rm -rf "$tmp/cap"
    "$browser" \
      --allow-file-access-from-files \
      --disable-background-networking \
      --disable-gpu \
      --enable-unsafe-swiftshader \
      --force-device-scale-factor=1 \
      --headless=new \
      --hide-scrollbars \
      --no-sandbox --disable-dev-shm-usage \
      --run-all-compositor-stages-before-draw \
      --timeout=20000 \
      --user-data-dir="$tmp/cap" \
      --window-size=1200,800 \
      --screenshot="$out/screenshot-$1.png" \
      "${@:2}" \
      "$app" >"$tmp/cap.log" 2>&1
    bytes=$(stat -c%s "$out/screenshot-$1.png" 2>/dev/null || echo 0)
    ((bytes > 10000)) && {
      echo "$bytes bytes $1"
      return
    }
    echo "retry $1 ($t) ${bytes}b" >&2
  done
  cat "$tmp/cap.log" >&2 || true
  die "tiny screenshot $1"
}

read -ra hues <<<"${HUES:-270 180 90 0}"

for i in "${!hues[@]}"; do
  write_app "${hues[i]}"
  n=$((i + 1))
  capture "$n-light" --blink-settings=preferredColorScheme=1
  capture "$n-dark" --blink-settings=preferredColorScheme=0
done

ls -lh "$out"/screenshot-*.png
