#!/bin/bash
set -euo pipefail

c0=$'\e[0m'
c1=$'\e[31m'
c2=$'\e[32m'
c3=$'\e[33m'
c4=$'\e[34m'
c5=$'\e[35m'

cat <<EOF
 ${c3}${c1}usage${c0} ${c4}screenshot.sh${c3} front_end
   ${c5}writes${c2} .github/assets/screenshot-{light,dark}.png ${c0}
EOF

[[ ${1-} ]]

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
front=$(realpath "$1")
out="$root/.github/assets"
pid=

need() { command -v "$1"; }
need chromium
need curl
need jq

test -f "$front/devtools_app.html"

tmp=$(mktemp -d)
trap '[[ ${pid-} ]] && kill $pid 2>/dev/null || true; rm -rf "$tmp"' EXIT

cat >"$tmp/index.html" <<'HTML'
<!doctype html>
<meta charset=utf-8>
<title>Custom DevTools</title>
<style>
:root { color-scheme: light dark }
body { font: 18px system-ui; margin: 2rem }
h1 { color: hsl(281 100% 45%) }
.card { padding: 1rem; border: 4px solid hsl(307 100% 47%); border-radius: 16px }
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

chromium --headless=new \
  --user-data-dir="$tmp/profile" \
  --remote-debugging-port=0 \
  --remote-allow-origins=* \
  --custom-devtools-frontend="file://$front" \
  --no-first-run --disable-extensions --hide-scrollbars \
  "file://$tmp/index.html" >"$tmp/chrome.log" 2>&1 &
pid=$!

for _ in {1..100}; do
  [[ -s $tmp/profile/DevToolsActivePort ]] && break
  sleep 0.05
done
port=$(head -n1 "$tmp/profile/DevToolsActivePort")
[[ $port ]]

ws=
for _ in {1..50}; do
  ws=$(curl -fsS "http://127.0.0.1:$port/json/list" |
    jq -r '.[] | select(.type=="page" and (.url | test("index.html"))) | .webSocketDebuggerUrl' || true)
  [[ $ws == ws://* ]] && break
  sleep 0.1
done
[[ $ws == ws://* ]]

cat >"$tmp/devtools.html" <<EOF
<!doctype html>
<html lang=en>
<meta charset=utf-8>
<title>DevTools</title>
<base href="file://$front/">
<script type=module src="entrypoints/devtools_app/devtools_app.js"></script>
<link href="application_tokens.css" rel=stylesheet>
<link href="design_system_tokens.css" rel=stylesheet>
<body class=undocked id=-blink-dev-tools style="--user-color-source:baseline-default">
EOF

app="file://$tmp/devtools.html?ws=${ws#ws://}"
printf 'port %s\nfrontend %s\n%s\n' "$port" "$front" "$app"

capture() {
  chromium --headless=new --disable-gpu --hide-scrollbars \
    --window-size=1200,800 \
    --force-device-scale-factor=1 \
    --virtual-time-budget=15000 \
    --allow-file-access-from-files \
    --disable-background-networking \
    --user-data-dir="$tmp/$1" \
    --screenshot="$out/screenshot-$1.png" \
    "${@:2}" \
    "$app"
  test -s "$out/screenshot-$1.png"
  test "$(stat -c%s "$out/screenshot-$1.png")" -gt 10000
}

capture light --blink-settings=preferredColorScheme=1
capture dark --blink-settings=preferredColorScheme=0

ls -lh "$out"/screenshot-light.png "$out"/screenshot-dark.png
