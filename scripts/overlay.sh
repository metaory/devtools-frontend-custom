#!/bin/bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

knobs=(
  HUE=270
  HUE_ERROR=10
  HUE_BLUE=220
  HUE_GREEN=140
  HUE_ORANGE=30
  HUE_YELLOW=50
  HUE_CYAN=190
  HUE_PINK=330
  SPREAD=20
  SAT=50
)

expr=
for k in "${knobs[@]}"; do
  n=${k%%=*}
  d=${k#*=}
  v=${!n-}
  [[ $v =~ ^[0-9]+$ ]] || v=$d
  expr+="s/\"\\\$$n\"/$v/;"
done

sed "$expr" "$root/theme.css"
