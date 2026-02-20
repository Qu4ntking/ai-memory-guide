#!/bin/bash
# memory-health.sh — 10-point health check for a memory vault
# Usage: bash scripts/memory-health.sh [memory_dir]
# Requires: yq (brew install yq)

MEMORY_DIR="${1:-./memory}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
SCORE=0

echo "🧠 Memory Health Report — $TIMESTAMP"
echo ""

# Helper: extract frontmatter YAML from a markdown file
extract_fm() {
  sed -n '/^---$/,/^---$/p' "$1" 2>/dev/null | sed '1d;$d'
}

# Helper: cross-platform file modification time (epoch)
file_mtime() {
  if stat --version &>/dev/null 2>&1; then
    stat -c%Y "$1" 2>/dev/null
  else
    stat -f%m "$1" 2>/dev/null
  fi
}

# 1. FRONTMATTER CHECK
TOTAL_MD=$(find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*" -not -path "*/templates/*" | wc -l | tr -d ' ')
MISSING_FM=0
while IFS= read -r f; do
  head -1 "$f" | grep -q '^---$' || MISSING_FM=$((MISSING_FM + 1))
done < <(find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*" -not -path "*/templates/*")
WITH_FM=$((TOTAL_MD - MISSING_FM))
if [ "$MISSING_FM" -eq 0 ]; then
  echo "✅ Frontmatter:    $WITH_FM/$TOTAL_MD files OK"
  SCORE=$((SCORE + 1))
else
  echo "❌ Frontmatter:    $MISSING_FM/$TOTAL_MD files missing"
fi

# 2. ORPHAN FILES CHECK
ORPHAN_COUNT=0
while IFS= read -r f; do
  fname=$(basename "$f" .md)
  ref_count=$(grep -rl "\[\[$fname" "$MEMORY_DIR" --include="*.md" 2>/dev/null | grep -v "$f" | wc -l | tr -d ' ')
  if [ "$ref_count" -eq 0 ]; then
    ORPHAN_COUNT=$((ORPHAN_COUNT + 1))
    echo "  → orphan: $f"
  fi
done < <(find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*" -not -name "_index.md" -not -name "MOC.md" -not -path "*/templates/*" | sort)

if [ "$ORPHAN_COUNT" -eq 0 ]; then
  echo "✅ Orphans:        0 files without backlinks"
  SCORE=$((SCORE + 1))
else
  echo "⚠️ Orphans:        $ORPHAN_COUNT files without backlinks"
fi

# 3. MISSING LINKS CHECK (real wikilink validation)
BROKEN_LINKS=0
declare -A KNOWN_BASES
while IFS= read -r f; do
  KNOWN_BASES["$(basename "$f" .md)"]=1
done < <(find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*")

while IFS= read -r f; do
  while IFS= read -r match; do
    link=$(echo "$match" | sed 's/\[\[//;s/\]\]//;s/|.*//' | sed 's/#.*//')
    [ -z "$link" ] && continue
    [[ "$link" == http* ]] && continue
    if [ -z "${KNOWN_BASES[$link]+x}" ]; then
      BROKEN_LINKS=$((BROKEN_LINKS + 1))
    fi
  done < <(grep -oE '\[\[[^]]+\]\]' "$f" 2>/dev/null || true)
done < <(find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*")

if [ "$BROKEN_LINKS" -eq 0 ]; then
  echo "✅ Missing links:  0 broken wikilinks"
  SCORE=$((SCORE + 1))
else
  echo "⚠️ Missing links:  $BROKEN_LINKS broken wikilinks"
fi

# 4. STALE FILES CHECK (>30 days)
STALE_COUNT=$(find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*" -not -path "*/templates/*" -type f -mtime +30 2>/dev/null | wc -l | tr -d ' ')
if [ "$STALE_COUNT" -eq 0 ]; then
  echo "✅ Stale files:    0 files > 30 days"
  SCORE=$((SCORE + 1))
else
  echo "⚠️ Stale files:    $STALE_COUNT files > 30 days"
fi

# 5. EMPTY FILES CHECK (content < 100 chars after frontmatter)
EMPTY_COUNT=0
while IFS= read -r f; do
  # Strip frontmatter, count remaining chars
  content_len=$(sed '1{/^---$/!q};1,/^---$/d' "$f" 2>/dev/null | wc -c | tr -d ' ')
  if [ "$content_len" -lt 100 ]; then
    EMPTY_COUNT=$((EMPTY_COUNT + 1))
  fi
done < <(find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*" -not -path "*/templates/*" -not -name "_index.md")

if [ "$EMPTY_COUNT" -eq 0 ]; then
  echo "✅ Empty files:    0 critically empty files"
  SCORE=$((SCORE + 1))
else
  echo "⚠️ Empty files:    $EMPTY_COUNT files with < 100 chars content"
fi

# 6. DUPLICATE TITLES CHECK
DUPS_COUNT=0
if command -v yq &>/dev/null; then
  TITLES_FILE=$(mktemp)
  while IFS= read -r f; do
    title=$(extract_fm "$f" | yq eval '.title // ""' - 2>/dev/null)
    [ -n "$title" ] && echo "$title" >> "$TITLES_FILE"
  done < <(find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*" -not -path "*/templates/*")
  DUPS_COUNT=$(sort "$TITLES_FILE" | uniq -d | wc -l | tr -d ' ')
  rm -f "$TITLES_FILE"
else
  # Fallback: grep-based
  DUPS_COUNT=$(grep -rh "^title:" "$MEMORY_DIR" --include="*.md" 2>/dev/null | sort | uniq -d | wc -l | tr -d ' ')
fi

if [ "$DUPS_COUNT" -eq 0 ]; then
  echo "✅ Duplicates:     0 duplicate titles"
  SCORE=$((SCORE + 1))
else
  echo "⚠️ Duplicates:     $DUPS_COUNT duplicate titles"
fi

# 7. MEMORY.MD SIZE
if [ -f "$MEMORY_DIR/MEMORY.md" ]; then
  MEMSIZE=$(wc -w < "$MEMORY_DIR/MEMORY.md" | tr -d ' ')
  if [ "$MEMSIZE" -lt 2500 ]; then
    echo "✅ MEMORY.md:      $MEMSIZE words (< 2500)"
    SCORE=$((SCORE + 1))
  else
    echo "⚠️ MEMORY.md:      $MEMSIZE words (> 2500 threshold)"
  fi
else
  echo "❌ MEMORY.md:      file not found"
fi

# 8. CONTEXT.MD FRESHNESS
if [ -f "$MEMORY_DIR/../CONTEXT.md" ]; then
  CONTEXT_MTIME=$(file_mtime "$MEMORY_DIR/../CONTEXT.md")
  NOW=$(date +%s)
  CONTEXT_AGE_HOURS=$(( (NOW - CONTEXT_MTIME) / 3600 ))
  if [ "$CONTEXT_AGE_HOURS" -lt 24 ]; then
    echo "✅ CONTEXT.md:     ${CONTEXT_AGE_HOURS}h old"
    SCORE=$((SCORE + 1))
  else
    echo "⚠️ CONTEXT.md:     ${CONTEXT_AGE_HOURS}h old (> 24h)"
  fi
else
  echo "❌ CONTEXT.md:     file not found"
fi

# 9. JOURNAL CONTINUITY
TODAY=$(date +%Y-%m-%d)
if [ -f "$MEMORY_DIR/journal/${TODAY}.md" ]; then
  echo "✅ Journal:        ${TODAY} entry exists"
  SCORE=$((SCORE + 1))
else
  echo "⚠️ Journal:        ${TODAY} entry missing"
fi

# 10. MOC COMPLETENESS
if [ -f "$MEMORY_DIR/MOC.md" ]; then
  echo "✅ MOC:            Master MOC exists"
  SCORE=$((SCORE + 1))
else
  echo "⚠️ MOC:            Missing MOC.md"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

MAX_CHECKS=10
PERCENTAGE=$((SCORE * 100 / MAX_CHECKS))

if [ "$PERCENTAGE" -ge 80 ]; then
  HEALTH="✅ HEALTHY"
  EXIT_CODE=0
elif [ "$PERCENTAGE" -ge 60 ]; then
  HEALTH="⚠️ NEEDS ATTENTION"
  EXIT_CODE=0
else
  HEALTH="🔴 CRITICAL"
  EXIT_CODE=1
fi

echo "Score: $SCORE/$MAX_CHECKS ($PERCENTAGE%) — $HEALTH"
echo ""

exit $EXIT_CODE
