#!/bin/bash
# check-wikilinks.sh — Find broken wikilinks in a memory vault
# Usage: bash scripts/check-wikilinks.sh [memory_dir]

set -euo pipefail

MEMORY_DIR="${1:-./memory}"
BROKEN_FILE=$(mktemp)
echo 0 > "$BROKEN_FILE"
trap 'rm -f "$BROKEN_FILE"' EXIT

# Build a list of all file basenames (without .md)
declare -A KNOWN_FILES
while IFS= read -r f; do
  base=$(basename "$f" .md)
  KNOWN_FILES["$base"]=1
done < <(find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*")

# Scan all files for wikilinks
while IFS= read -r f; do
  while IFS= read -r match; do
    # Strip [[ and ]], take target before |
    link=$(echo "$match" | sed 's/\[\[//;s/\]\]//;s/|.*//')
    # Skip external links and anchors
    [[ "$link" == http* ]] && continue
    [[ "$link" == "#"* ]] && continue
    link_base=$(echo "$link" | sed 's/#.*//')  # strip heading anchors
    [ -z "$link_base" ] && continue
    if [ -z "${KNOWN_FILES[$link_base]+x}" ]; then
      echo "❌ Broken: [[$link]] in $(basename "$f")"
      echo $(( $(cat "$BROKEN_FILE") + 1 )) > "$BROKEN_FILE"
    fi
  done < <(grep -oE '\[\[[^]]+\]\]' "$f" 2>/dev/null || true)
done < <(find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*")

BROKEN=$(cat "$BROKEN_FILE")
if [ "$BROKEN" -eq 0 ]; then
  echo "✅ All wikilinks resolve. No broken links found."
  exit 0
else
  echo ""
  echo "Found $BROKEN broken wikilink(s)."
  exit 1
fi
