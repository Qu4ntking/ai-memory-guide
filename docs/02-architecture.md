# Chapter 2: Architecture — 3-Layer Memory

## Overview

The memory system has three layers, each with a different purpose and lifespan:

```
Layer 3 — Core Directives (permanent)
  SOUL.md, USER.md, AGENTS.md
  Loaded every session. Defines identity, rules, preferences.
  
Layer 2 — Distilled Knowledge (long-term)
  MEMORY.md (auto-generated index)
  memory/knowledge/, memory/lessons/, memory/predictions/
  Curated facts, patterns, research. Updated when things change.
  
Layer 1 — Active Thread (short-term)
  CONTEXT.md (current state)
  memory/journal/ (daily logs)
  memory/tasks/, memory/threads/, memory/decisions/
  What's happening right now. Rotated regularly.
```

## How They Interact

### Session Start (Boot Sequence)
1. Read `MEMORY.md` → understand structure, index, recent changes
2. Read `CONTEXT.md` → what we were doing, next steps
3. Read `memory/tasks/active.md` → open tasks, priorities, blockers
4. Read most recent journal → last activities, notes
5. Read most relevant file indicated by CONTEXT.md

**Total boot cost**: 5 file reads. Minimal token usage.

### During Session (Write-Through)
Every significant piece of information gets written to disk **in the same turn** it emerges:
- Decision → `memory/decisions/` + `CONTEXT.md` + journal
- New task → `memory/tasks/active.md` + journal
- User preference → `memory/preferences/user-prefs.md`

### Session End / Compaction
Before context is compacted, the agent performs a **pre-compaction flush**:
1. Scan for unwritten decisions
2. Scan for unwritten tasks
3. Scan for unwritten preferences
4. Update CONTEXT.md with current state
5. Update MEMORY.md index

## The Index Problem

MEMORY.md is the **index** to the entire memory system. Without it, the agent would need to read every file to understand what it knows.

But manually maintaining an index is error-prone. The solution: **auto-generate it** from frontmatter metadata. A script scans all files, reads their YAML frontmatter, and produces a fresh MEMORY.md.

## File Naming Convention

| Type | Pattern | Example |
|------|---------|---------|
| Journal | `YYYY-MM-DD.md` | `2026-02-20.md` |
| Decision | `YYYY-MM-DD-slug.md` | `2026-02-20-use-obsidian.md` |
| Thread | `slug.md` | `memory-improvement.md` |
| Token | `TICKER.md` | `ACME.md` |
| Lesson | `name.md` or `YYYY-MM-DD-slug.md` | `cron-errors.md` |

## Why Markdown + YAML + Wikilinks

This triple combination gives you:
- **Markdown**: Human-readable, universal, version-control friendly
- **YAML frontmatter**: Structured metadata, queryable with Obsidian Dataview
- **Wikilinks**: Knowledge graph, bidirectional connections, Obsidian Graph View

No databases. No APIs. No dependencies. Just files.
