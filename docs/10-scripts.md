# 10 — Maintenance Scripts

## Overview

Two scripts automate memory maintenance:

1. **`generate-memory-index.sh`** — regenerates MEMORY.md from file frontmatter
2. **`memory-health.sh`** — runs a 10-point health check with scoring

Both are bash-only (+ `yq` for YAML parsing). No Python, no Node.js.

## Script 1: generate-memory-index.sh

Scans all files in `memory/`, reads their YAML frontmatter, and generates a fresh `MEMORY.md` index.

### When to Run
- After 5+ files modified in a session
- After bulk operations (adding frontmatter, creating MOCs)
- Never modify MEMORY.md manually — always use this script

### Key Features
- Reads frontmatter via `yq` (install: `brew install yq`)
- Groups files by type (narrative, token, protocol, source, etc.)
- Includes file stats (total count by type)
- Adds frontmatter to the generated MEMORY.md itself
- Idempotent: running twice produces the same result
- Output stays under 2500 words (configurable)

### Usage

```bash
bash scripts/generate-memory-index.sh
# Output: ✅ MEMORY.md regenerated — 285 words
```

### Simplified Example

```bash
#!/bin/bash
MEMORY_DIR="memory"
TMPFILE=$(mktemp)

{
  echo "---"
  echo "title: \"MEMORY Index\""
  echo "type: moc"
  echo "---"
  echo ""
  echo "# MEMORY.md — Index"
  echo "> Last updated: $(date '+%Y-%m-%d %H:%M')"
  echo ""
  
  # List files by type using yq
  for type in narrative token protocol source lesson; do
    echo "## ${type^}s"
    find "$MEMORY_DIR" -name "*.md" -not -path "*/.obsidian/*" | while read f; do
      ftype=$(yq eval '.type // ""' "$f" 2>/dev/null)
      if [ "$ftype" = "$type" ]; then
        title=$(yq eval '.title // ""' "$f" 2>/dev/null)
        echo "- $title (\`$f\`)"
      fi
    done
    echo ""
  done
} > "$TMPFILE"

mv "$TMPFILE" "$MEMORY_DIR/MEMORY.md"
```

## Script 2: memory-health.sh

Runs 10 automated checks and produces a health score.

### Checks

| # | Check | Pass Condition |
|---|-------|---------------|
| 1 | Frontmatter | All .md files have YAML frontmatter |
| 2 | Orphans | No files without backlinks |
| 3 | Missing links | No broken wikilinks |
| 4 | Stale files | No files >30 days without update |
| 5 | Empty files | No files with <100 chars content |
| 6 | Duplicate titles | No two files with same title |
| 7 | MEMORY.md size | Under 2500 words |
| 8 | CONTEXT.md freshness | Updated within 24 hours |
| 9 | Journal continuity | Today's journal entry exists |
| 10 | MOC completeness | Master MOC + sub-MOCs exist |

### Scoring

- **80-100%**: ✅ HEALTHY (exit code 0)
- **60-79%**: ⚠️ NEEDS ATTENTION (exit code 0)
- **<60%**: 🔴 CRITICAL (exit code 1)

### Usage

```bash
bash scripts/memory-health.sh

# Output:
# 🧠 Memory Health Report — 2026-02-20 01:27
# 
# ✅ Frontmatter:    60/60 files OK
# ✅ Orfani:         0 files without backlinks
# ✅ Missing links:  0 broken wikilinks
# ✅ Stale files:    0 files > 30 days
# ✅ Empty files:    0
# ⚠️ Duplicates:     2 duplicate titles
# ✅ MEMORY.md:      285 words (< 2500)
# ✅ CONTEXT.md:     0h old
# ✅ Journal:        2026-02-20 entry exists
# ✅ MOC:            Master MOC exists
# 
# Score: 9/10 (90%) — ✅ HEALTHY
```

### Integration with Heartbeat

Add to your heartbeat/cron protocol (weekly, Monday morning):

```
## Health Check
- Run: `bash scripts/memory-health.sh`
- Exit 0 (healthy) → no action
- Exit 1 (needs attention) → prioritize fixing reported issues
- Track score over time: 80%+ = OK, <60% = critical
```

## Bonus: HTML Graph Visualization

Generate an interactive force-directed graph of your memory vault:

```bash
# Extract wikilinks from all files
cd memory/
for f in $(find . -name "*.md" -not -path "./.obsidian/*"); do
  fname=$(basename "$f" .md)
  links=$(grep -oh '\[\[[^]|]*' "$f" | sed 's/\[\[//' | sort -u | tr '\n' ',')
  echo "$fname|$links"
done > /tmp/graph-data.txt
```

Feed this into an HTML template with D3.js or vis.js for an interactive visualization. See the `templates/graph.html` file in this repo.
