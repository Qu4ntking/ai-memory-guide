# 13 — OpenClaw Integration

How to use this memory system with [OpenClaw](https://github.com/openclaw/openclaw).

## Setup

1. **Create the structure** in your OpenClaw workspace:

```bash
cd ~/.openclaw/workspace
bash scripts/setup.sh memory
```

2. **Add to your `AGENTS.md`** — the boot sequence and write-through rules:

```markdown
## Session Start — Boot Sequence
1. Read MEMORY.md → index, structure
2. Read CONTEXT.md → current state, next steps
3. Read memory/tasks/active.md → open tasks
4. Read memory/journal/[latest].md → recent activity
```

3. **Add to your `SOUL.md`** — how the agent uses memory:

```markdown
## Continuity
Wake fresh each session. Memory files = everything you know.
Read MEMORY.md first. If not in memory, you don't know it.
```

## OpenClaw's Built-in Tools

OpenClaw provides two key tools that work out of the box:

### `memory_search`
Semantic search over all `.md` files in `memory/`. No setup needed.

```
memory_search("database migration decision")
→ Returns: top matching snippets with file path + line numbers
```

### `memory_get`
Read specific lines from a memory file (after search):

```
memory_get(path="memory/decisions/2026-02-10-db-migration-delayed.md", from=1, lines=20)
```

## Heartbeat Integration

Add memory health checks to your `HEARTBEAT.md`:

```markdown
## Memory Hygiene
- MEMORY.md near 2500 words → regenerate with script
- Today's journal missing → create it
- CONTEXT.md stale → update it
```

## Pre-Compaction Protocol

Add to `AGENTS.md` to protect against context compaction:

```markdown
## Pre-Compaction Checklist
□ Scan for unsaved decisions
□ Scan for unlogged tasks
□ Update CONTEXT.md
□ Update today's journal
□ Verify MEMORY.md is current
```

## Cron / Heartbeat Scripts

Schedule memory health checks via OpenClaw cron:

```bash
# Weekly Monday morning health check
openclaw cron add --schedule "0 7 * * 1" --command "bash scripts/memory-health.sh"
```

## Project Files

Your workspace should look like:

```
~/.openclaw/workspace/
├── SOUL.md          ← agent personality
├── USER.md          ← user profile
├── AGENTS.md        ← operational rules (boot sequence, write-through)
├── CONTEXT.md       ← current state (updates every session)
├── HEARTBEAT.md     ← periodic check protocol
├── MEMORY.md        ← auto-generated index (→ memory/)
├── memory/          ← the vault (open in Obsidian)
│   ├── journal/
│   ├── decisions/
│   ├── ...
│   └── templates/
└── scripts/
    ├── generate-memory-index.sh
    ├── memory-health.sh
    └── check-wikilinks.sh
```

## Tips

- **Don't edit MEMORY.md manually** — always regenerate with `scripts/generate-memory-index.sh`
- **Open `memory/` in Obsidian** for graph view and manual browsing
- **Use `memory_search` first**, then `memory_get` for specific lines — saves tokens
- **Write immediately** — the biggest memory improvement is discipline, not technology
