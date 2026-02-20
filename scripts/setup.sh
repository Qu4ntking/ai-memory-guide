#!/bin/bash
# setup.sh — Create the full memory directory structure
# Usage: bash scripts/setup.sh [target_dir]
#   target_dir defaults to ./memory

set -euo pipefail

TARGET="${1:-./memory}"

echo "📁 Creating memory structure in $TARGET/"

dirs=(
  journal
  decisions
  threads
  "tasks/done"
  "knowledge/tokens"
  "knowledge/narratives"
  "knowledge/patterns/benched"
  "knowledge/insights"
  "knowledge/sources"
  predictions
  lessons
  preferences
  protocols
  templates
)

for d in "${dirs[@]}"; do
  mkdir -p "$TARGET/$d"
done

# Create stub files if they don't exist
[ -f "$TARGET/MEMORY.md" ] || cat > "$TARGET/MEMORY.md" << EOF
---
title: "MEMORY Index"
type: moc
created: $(date +%Y-%m-%d)
---

# MEMORY.md — Index

> Auto-generated. Do not edit manually — use \`scripts/generate-memory-index.sh\`
EOF

[ -f "$TARGET/../CONTEXT.md" ] || cat > "$TARGET/../CONTEXT.md" << 'EOF'
# CONTEXT.md — Current State

> Last updated: (never)

## Active Focus
(nothing yet)

## Next Steps
1. Start using the memory system
EOF

echo "✅ Structure created. $(find "$TARGET" -type d | wc -l | tr -d ' ') directories."
echo "   Open $TARGET/ as an Obsidian vault to get started."
