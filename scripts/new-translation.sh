#!/usr/bin/env bash
# Create a new Finnish translation chapter from the English source.
# Usage: ./scripts/new-translation.sh Chapters/01-vision.qmd
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <Chapters/file.qmd|index.qmd>"
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REL="$1"
EN="$ROOT/$REL"
FI="$ROOT/fi/$REL"

if [[ ! -f "$EN" ]]; then
  echo "Source file not found: $EN"
  exit 1
fi

if [[ -f "$FI" ]]; then
  echo "Translation already exists: $FI"
  exit 1
fi

mkdir -p "$(dirname "$FI")"
EN_HASH="$(sha256sum "$EN" | awk '{print $1}')"

# Copy the English skeleton and fix relative asset paths for fi/.
sed -e 's|](Figures/|](../Figures/|g' \
    -e 's|](Cover/|](../Cover/|g' \
    -e 's|](Assets/|](../Assets/|g' \
    "$EN" > "$FI.tmp"

python3 - "$FI.tmp" "$REL" "$EN_HASH" "$FI" <<'PY'
import sys, re, pathlib

tmp, rel, en_hash, out = sys.argv[1:5]
text = pathlib.Path(tmp).read_text(encoding='utf-8')
m = re.match(r'^---\n(.*?)\n---\n', text, re.S)
if not m:
    raise SystemExit('No YAML frontmatter in source file')
header, body = m.group(1), text[m.end():]
extra = (
    f"translation:\n"
    f"  source: {rel}\n"
    f"  source_sha256: {en_hash}\n"
    f"  status: draft\n"
)
pathlib.Path(out).write_text(f"---\n{header}\n{extra}---\n{body}", encoding='utf-8', newline='\n')
pathlib.Path(tmp).unlink()
PY

echo "Created: $FI"
echo "Translate the body, keep code blocks/paths untranslated, set status: complete when done."
