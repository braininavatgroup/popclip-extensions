#!/usr/bin/env bash
# The one check: every script is valid shell and every config file parses.
set -euo pipefail
cd "$(dirname "$0")/.."
for f in */*.sh; do
  bash -n "$f"
  if head -1 "$f" | grep -q zsh; then zsh -n "$f"; fi
done
for f in */Config.json; do
  python3 -c 'import json, sys; json.load(open(sys.argv[1]))' "$f"
done
if python3 -c 'import yaml' 2>/dev/null; then
  for f in */Config.yaml; do
    python3 -c 'import yaml, sys; yaml.safe_load(open(sys.argv[1]))' "$f"
  done
else
  echo "pyyaml not available; skipping yaml parse"
fi
echo "popclip-extensions: ok"
