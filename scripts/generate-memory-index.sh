#!/bin/bash
# Step 2.1 — Auto-generate MEMORY.md from frontmatter of all files in memory/

MEMORY_DIR="${1:-./memory}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M UTC')
MEMORY_FILE="$MEMORY_DIR/MEMORY.md"

# Create temp file for new MEMORY.md
TMPFILE=$(mktemp)

# Helper: extract YAML frontmatter from markdown file, then query with yq
extract_fm() {
  local file="$1"
  local field="$2"
  local default="${3:-}"
  sed -n '/^---$/,/^---$/p' "$file" 2>/dev/null | sed '1d;$d' | yq eval ".${field} // \"${default}\"" - 2>/dev/null || echo "$default"
}

# Helper: get frontmatter field via yq (safe for markdown files)
fm_field() {
  local file="$1" field="$2" default="${3:-}"
  sed -n '/^---$/,/^---$/p' "$file" 2>/dev/null | sed '1d;$d' | yq eval ".${field} // \"${default}\"" - 2>/dev/null || echo "$default"
}

# Helper: count files by type
count_by_type() {
  local type="$1"
  find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*" -not -path "*/templates/*" -not -name "_index.md" -not -name "MOC.md" 2>/dev/null | while read f; do
    ftype=$(fm_field "$f" "type" "unknown")
    [ "$ftype" = "$type" ] && echo "$f"
  done | wc -l | tr -d ' '
}

# Helper: list files by type (sorted)
list_by_type() {
  local type="$1"
  find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*" -not -path "*/templates/*" -not -name "_index.md" -not -name "MOC.md" 2>/dev/null | sort | while read f; do
    ftype=$(fm_field "$f" "type" "unknown")
    if [ "$ftype" = "$type" ]; then
      title=$(fm_field "$f" "title" "" | sed 's/"//g')
      fname=$(basename "$f" .md)
      [ -n "$title" ] && echo "$fname|$title"
    fi
  done
}

# Start building MEMORY.md
{
  echo "---"
  echo "title: \"MEMORY Index\""
  echo "created: $(date +%Y-%m-%d)"
  echo "updated: $(date +%Y-%m-%d)"
  echo "type: moc"
  echo "tags: [moc, master, memory]"
  echo "---"
  echo ""
  echo "# MEMORY.md — Memory Index"
  echo ""
  echo "> Last updated: $TIMESTAMP"
  echo "> Architecture: v2 (write-through, structured)"
  echo ""
  
  echo "## Quick Nav"
  echo "- **Stato attivo** → \`CONTEXT.md\`"
  echo "- **Task attivi** → \`memory/tasks/active.md\`"
  echo "- **Task backlog** → \`memory/tasks/backlog.md\`"
  echo "- **Journal oggi** → \`memory/journal/$(date +%Y-%m-%d).md\`"
  echo "- **Preferenze utente** → \`memory/preferences/user-prefs.md\`"
  echo ""
  
  # Prediction Stats (placeholder)
  echo "## Prediction Stats"
  PRED_COUNT=$(find "$MEMORY_DIR/predictions" -name "*.md" | wc -l | tr -d ' ')
  echo "- Streak: 0/0 · Accuracy: —% · Patterns: 0 active, 0 benched"
  echo ""
  
  # Active Narratives
  echo "## Active Narratives"
  echo "| Narrative | Status | File |"
  echo "|-----------|--------|------|"
  list_by_type "narrative" | while IFS='|' read fname title; do
    echo "| $title | 🟢 | \`memory/knowledge/narratives/$fname.md\` |"
  done
  echo ""
  
  # Token Watchlist
  echo "## Token Watchlist"
  echo "| Token | Chain | File |"
  echo "|-------|-------|------|"
  list_by_type "token" | while IFS='|' read fname title; do
    chain=$(fm_field "$MEMORY_DIR/knowledge/tokens/$fname.md" "chain" "—")
    echo "| $title | $chain | \`memory/knowledge/tokens/$fname.md\` |"
  done
  echo ""
  
  # Protocol Tracker
  echo "## Protocol Tracker"
  echo "| Protocol | Category | File |"
  echo "|----------|----------|------|"
  list_by_type "protocol" | while IFS='|' read fname title; do
    echo "| $title | Various | \`memory/protocols/$fname.md\` |"
  done
  echo ""
  
  # Source Reliability
  echo "## Source Reliability"
  echo "| Source | Tier | File |"
  echo "|--------|------|------|"
  list_by_type "source" | while IFS='|' read fname title; do
    echo "| $title | T? | \`memory/knowledge/sources/$fname.md\` |"
  done
  echo ""
  
  # Insights
  echo "## Insights"
  echo "| Topic | File |"
  echo "|-------|------|"
  list_by_type "insight" | while IFS='|' read fname title; do
    echo "| $title | \`memory/knowledge/insights/$fname.md\` |"
  done
  echo ""
  
  # Open Predictions
  echo "## Open Predictions"
  echo "→ Full: \`memory/predictions/$(date +%Y-%m).md\`"
  echo ""
  
  # Validated Patterns
  echo "## Validated Patterns"
  echo "(none yet)"
  echo ""
  
  # Knowledge Base Structure
  echo "## Knowledge Base Structure"
  echo "\`\`\`"
  echo "memory/"
  echo "├── journal/       ← daily logs strutturati (YYYY-MM-DD.md)"
  echo "├── decisions/     ← decisioni con rationale"
  echo "├── threads/       ← discussioni aperte"
  echo "├── tasks/         ← active.md, backlog.md, done/"
  echo "├── preferences/   ← user-prefs.md"
  echo "├── knowledge/"
  echo "│   ├── tokens/    ← per-token research"
  echo "│   ├── narratives/← narrative tracciate"
  echo "│   ├── patterns/  ← pattern validati (+ benched/)"
  echo "│   ├── insights/  ← analisi distillate"
  echo "│   └── sources/   ← profili affidabilità fonti"
  echo "├── protocols/     ← protocolli/progetti"
  echo "├── predictions/   ← monthly prediction logs"
  echo "└── lessons/       ← post-mortem"
  echo "\`\`\`"
  echo ""
  
  echo "## File Stats"
  TOTAL=$(find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*" | wc -l | tr -d ' ')
  JOURNAL=$(count_by_type "journal")
  TOKEN=$(count_by_type "token")
  SOURCE=$(count_by_type "source")
  NARRATIVE=$(count_by_type "narrative")
  PROTOCOL=$(count_by_type "protocol")
  LESSON=$(count_by_type "lesson")
  THREAD=$(count_by_type "thread")
  
  echo "- Total files: $TOTAL"
  echo "- Journal entries: $JOURNAL"
  echo "- Tokens: $TOKEN"
  echo "- Sources: $SOURCE"
  echo "- Narratives: $NARRATIVE"
  echo "- Protocols: $PROTOCOL"
  echo "- Lessons: $LESSON"
  echo "- Threads: $THREAD"
  echo ""
  
  echo "## Silent Replies"
  echo "When you have nothing to say, respond with ONLY: NO_REPLY"
  echo ""
  
} > "$TMPFILE"

# Check word count
WORDCOUNT=$(wc -w < "$TMPFILE" | tr -d ' ')
if [ "$WORDCOUNT" -gt 3000 ]; then
  echo "⚠️  WARNING: MEMORY.md would be $WORDCOUNT words (limit: 2500)"
  rm "$TMPFILE"
  exit 1
fi

# Compare with existing
if [ -f "$MEMORY_FILE" ]; then
  if diff -q "$TMPFILE" "$MEMORY_FILE" > /dev/null 2>&1; then
    echo "✅ MEMORY.md unchanged (already up-to-date)"
    rm "$TMPFILE"
    exit 0
  fi
fi

# Update MEMORY.md
mv "$TMPFILE" "$MEMORY_FILE"
echo "✅ MEMORY.md regenerated — $WORDCOUNT words"
