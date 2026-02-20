#!/bin/bash
# check-wikilinks.sh — Find broken wikilinks in a memory vault
# Usage: bash scripts/check-wikilinks.sh [memory_dir]
# Compatible with bash 3.2+ (macOS default)

set -euo pipefail

MEMORY_DIR="${1:-./memory}"
BROKEN_FILE=$(mktemp)
echo 0 > "$BROKEN_FILE"
trap 'rm -f "$BROKEN_FILE" "$KNOWN_FILE"' EXIT

# Build a list of all file basenames (without .md)
KNOWN_FILE=$(mktemp)
find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*" | while IFS= read -r f; do
  basename "$f" .md
done | sort -u > "$KNOWN_FILE"

# Scan all files for wikilinks
while IFS= read -r f; do
  while IFS= read -r match; do
    link=$(echo "$match" | sed 's/\[\[//;s/\]\]//;s/|.*//' | sed 's/#.*//')
    [ -z "$link" ] && continue
    case "$link" in http*) continue ;; esac
    if ! grep -qx "$link" "$KNOWN_FILE"; then
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
