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
# PopClip's own configs are YAML, so the parse needs pyyaml: use it if python3 has it, else borrow it through uv.
if python3 -c 'import yaml' 2>/dev/null; then
  py=(python3)
else
  py=(uv run --quiet --no-project --with pyyaml python3)
fi
for f in */Config.yaml; do
  "${py[@]}" -c 'import yaml, sys; yaml.safe_load(open(sys.argv[1]))' "$f"
done
# PopClip refuses to install a config whose requirement it doesn't know, so check them here.
"${py[@]}" - */Config.json */Config.yaml <<'PY'
import json, sys, yaml
known = {"text", "copy", "cut", "paste", "formatting", "url", "urls", "email", "emails", "path"}
for f in sys.argv[1:]:
    c = json.load(open(f)) if f.endswith(".json") else yaml.safe_load(open(f))
    for a in c.get("actions") or [c.get("action") or {}]:
        for r in a.get("requirements", []):
            if r.lstrip("!") not in known and not r.lstrip("!").startswith("option-"):
                sys.exit(f"{f}: PopClip does not know the requirement {r!r}")
PY
echo "popclip-extensions: ok"
