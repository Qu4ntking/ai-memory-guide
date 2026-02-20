# 🧠 AI Memory Guide

**A practical guide to building persistent AI agent memory with structured Markdown.**

> How to give your AI agent a memory that survives restarts, compaction, and session switches — using Obsidian, YAML frontmatter, wikilinks, and a few bash scripts.

---

## Why This Exists

Every AI agent has the same problem: **amnesia**. You explain your project, set up context, make decisions — and the next session it's all gone. Context compaction silently destroys hours of accumulated knowledge.

Current solutions are either:
- Too simple (a single MEMORY.md that gets bloated)
- Too complex (vector databases, embeddings, external services)
- Too fragile (breaks on compaction, doesn't survive restarts)

This guide shows a **middle path**: a structured, human-readable memory system that works in practice, using tools you already have. It's an opinionated approach, born from building and maintaining a real agent vault (~60 files, daily use).

---

## What You'll Learn

1. **Architecture** — How to structure AI memory for long-term retention
2. **Write-Through Protocol** — Rules that ensure nothing gets lost
3. **Obsidian Integration** — Using a knowledge graph to visualize agent memory
4. **Continual Learning** — How your agent improves over time
5. **Anti-Amnesia Patterns** — Surviving compaction and session switches
6. **Maintenance Scripts** — Automated health checks and index generation (real scripts included)
7. **Platform Integration** — Concrete setup for OpenClaw (adaptable to others)

---

## Quick Start

### 1. Create the structure

```bash
bash scripts/setup.sh        # creates memory/ with all subdirectories
```

Or manually:

```bash
mkdir -p memory/{journal,decisions,threads,tasks/done,knowledge/{tokens,narratives,patterns/benched,insights,sources},predictions,lessons,preferences,templates}
```

### 2. Add frontmatter to every file

```yaml
---
title: "My Decision"
created: 2026-02-20
updated: 2026-02-20
type: decision
tags: [architecture, memory]
---
```

### 3. Use wikilinks

```markdown
This decision relates to [[token-research]] and impacts the [[ai-agents]] narrative.
See also: [[2026-02-20]] journal entry.
```

### 4. Open in Obsidian

Open `memory/` as an Obsidian vault. Enable Graph View. See your knowledge graph come alive.

### 5. Run health checks

```bash
bash scripts/memory-health.sh     # 10-point health check with scoring
bash scripts/generate-memory-index.sh  # regenerate MEMORY.md index
bash scripts/check-wikilinks.sh   # find broken links
```

---

## Example: End-to-End Workflow

**User asks:** *"What did we decide about the database migration?"*

```
1. Agent searches memory → finds decisions/2026-02-10-db-migration-delayed.md
2. Reads the file → "Postponed until v2.0, waiting on test coverage"
3. Responds with context + citation
4. Logs the interaction in today's journal (write-through)
```

Without this system, the agent would say *"I don't have context about the migration"* and force you to repeat yourself.

→ Full walkthrough: [docs/12-example-workflow.md](docs/12-example-workflow.md)

---

## Architecture Overview

```
┌─────────────────────────────────────────────┐
│                AGENT RUNTIME                 │
│  ┌──────────────────────────────────────┐    │
│  │ SOUL.md + USER.md + AGENTS.md       │    │
│  │ MEMORY.md (auto-generated index)     │    │
│  │ CONTEXT.md (current state)           │    │
│  │ Today's journal                      │    │
│  └──────────────────────────────────────┘    │
└──────────────────┬──────────────────────────┘
                   │ read/write
                   ▼
┌─────────────────────────────────────────────┐
│           PERSISTENT MEMORY (disk)           │
│  memory/                                     │
│  ├── journal/        ← daily logs            │
│  ├── decisions/      ← decisions + rationale │
│  ├── threads/        ← open discussions      │
│  ├── tasks/          ← active + backlog      │
│  ├── knowledge/      ← tokens, narratives…   │
│  ├── predictions/    ← tracked predictions   │
│  ├── lessons/        ← post-mortems          │
│  └── preferences/    ← user preferences      │
│                                              │
│  All files: YAML frontmatter + wikilinks     │
└──────────────────┬──────────────────────────┘
                   │ browse/edit
                   ▼
┌─────────────────────────────────────────────┐
│              OBSIDIAN (optional)              │
│  Graph View · Dataview · Templater · Git     │
└─────────────────────────────────────────────┘
```

---

## Table of Contents

| Chapter | Topic | File |
|---------|-------|------|
| 1 | The Problem: AI Amnesia | [docs/01-the-problem.md](docs/01-the-problem.md) |
| 2 | Architecture: 3-Layer Memory | [docs/02-architecture.md](docs/02-architecture.md) |
| 3 | File Structure & Naming | [docs/03-file-structure.md](docs/03-file-structure.md) |
| 4 | Frontmatter & Metadata | [docs/04-frontmatter.md](docs/04-frontmatter.md) |
| 5 | Wikilinks & Knowledge Graph | [docs/05-wikilinks.md](docs/05-wikilinks.md) |
| 6 | Write-Through Protocol | [docs/06-write-through.md](docs/06-write-through.md) |
| 7 | Continual Learning Loop | [docs/07-continual-learning.md](docs/07-continual-learning.md) |
| 8 | Obsidian Integration | [docs/08-obsidian.md](docs/08-obsidian.md) |
| 9 | Anti-Amnesia Patterns | [docs/09-anti-amnesia.md](docs/09-anti-amnesia.md) |
| 10 | Maintenance Scripts | [docs/10-scripts.md](docs/10-scripts.md) |
| 11 | Advanced: Semantic Search | [docs/11-advanced.md](docs/11-advanced.md) |
| 12 | Example: End-to-End Workflow | [docs/12-example-workflow.md](docs/12-example-workflow.md) |
| 13 | OpenClaw Integration | [docs/13-openclaw-integration.md](docs/13-openclaw-integration.md) |
| A | Templates | [templates/](templates/) |
| B | Scripts | [scripts/](scripts/) |
| C | Research & Sources | [docs/research.md](docs/research.md) |

---

## Scripts

Real, working scripts — not just documentation:

| Script | Purpose |
|--------|---------|
| [`scripts/setup.sh`](scripts/setup.sh) | Create the full memory directory structure |
| [`scripts/generate-memory-index.sh`](scripts/generate-memory-index.sh) | Auto-regenerate MEMORY.md from frontmatter |
| [`scripts/memory-health.sh`](scripts/memory-health.sh) | 10-point health check with scoring |
| [`scripts/check-wikilinks.sh`](scripts/check-wikilinks.sh) | Find broken wikilinks |

Requires: `bash`, `yq` (`brew install yq`).

---

## Who Is This For

- **AI agent builders** who want persistent memory without infrastructure overhead
- **OpenClaw users** — includes a dedicated [integration guide](docs/13-openclaw-integration.md)
- **Obsidian users** who want their AI to use their vault as a knowledge base
- **Anyone** tired of their AI assistant forgetting everything between sessions

---

## Principles

1. **Human-readable first** — All memory is Markdown. You can read, edit, delete it.
2. **No vendor lock-in** — No cloud services. Everything runs locally.
3. **Write-through, not write-back** — Save immediately, not "later".
4. **Structured but simple** — YAML frontmatter + wikilinks. That's it.
5. **Verify, don't trust** — Health checks catch drift before it becomes a problem.

---

## Status

This is a living document based on a system in active daily use. It works well for vaults up to ~500 files. The approach is opinionated — there are other valid ways to do this.

Issues and PRs welcome.

---

## License

MIT

---

*Built by [@Qu4ntking](https://github.com/Qu4ntking)*
