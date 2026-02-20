# 09 — Anti-Amnesia Patterns

## The Amnesia Problem

AI agents lose memory in three ways:

1. **Context compaction** — when the context window fills up, old messages get summarized and details are lost
2. **Session switches** — starting a new session means starting from zero
3. **Drift** — over many turns, early information gets pushed out of attention

All three are solved by the same principle: **everything important is on disk**.

## Pattern 1: Boot Sequence

Every session starts by reading 5 files in order:

```
1. MEMORY.md      → structure, index, what exists
2. CONTEXT.md     → current state, what we were doing, next steps
3. tasks/active.md → open tasks, priorities, blockers
4. journal/today   → what happened recently
5. Relevant file   → whatever CONTEXT.md points to
```

This takes <10 seconds and reconstructs 90% of context. The agent should confirm: *"Last time we were working on X. Correct?"*

## Pattern 2: Pre-Compaction Flush

When context usage reaches ~60% capacity, or before forced compaction:

```
📋 PRE-COMPACTION CHECKLIST
□ 1. SCAN DECISIONS — discussed but not in decisions/?
□ 2. SCAN TASKS — mentioned but not in tasks/?
□ 3. SCAN DISCUSSIONS — significant threads not captured?
□ 4. SCAN PREFERENCES — user preferences not saved?
□ 5. SCAN NOTES — side comments not logged?
□ 6. UPDATE CONTEXT.md — current state, next steps
□ 7. UPDATE MEMORY.md — index aligned with actual files?
□ 8. DIFF-CHECK — anything in conversation NOT captured?
```

### Silent Pre-Compaction (NO_REPLY pattern)

Some platforms support a silent save before compaction. The agent writes all pending information to disk, then responds with `NO_REPLY` (no visible message to the user). This ensures nothing is lost even if compaction happens between turns.

## Pattern 3: Context Recovery

If CONTEXT.md is empty or absent:

```
1. Read MEMORY.md → get the map
2. Read last 2-3 journal entries → recent activity
3. Read tasks/active.md → open work
4. Reconstruct CONTEXT.md from these
5. Tell the user: "I found a gap. Here's what I reconstructed..."
```

Always signal gaps honestly. Don't pretend to remember.

## Pattern 4: Compaction Summary Format

The compaction summary is NOT a replacement for files. It's a bridge:

```
- Current state → "Read CONTEXT.md"
- 2-3 sentences on what happened
- List of decisions with file references
- Modified tasks with references
- Open threads with references
- Emotional/relational context (urgency, frustration, enthusiasm)
- ⚠️ Things not to forget
- Files modified in this session
```

## Pattern 5: Heartbeat Protocol

A periodic check (every 30 minutes or triggered by cron) that verifies:

1. **File integrity** — critical files haven't been tampered with
2. **Memory hygiene** — MEMORY.md isn't bloated, journal exists, CONTEXT.md is fresh
3. **Pending work** — stale tasks, unscored predictions
4. **Health score** — automated check (see [Chapter 10](10-scripts.md))

If nothing needs action → respond `HEARTBEAT_OK` and stop.  
If something needs attention → act on it.

## Pattern 6: Soul Lock

Hash critical identity files and store the hashes:

```bash
sha256sum SOUL.md AGENTS.md IDENTITY.md > memory/identity-hashes.json
```

On every heartbeat, verify hashes match. If they don't → 🔴 immediate alert. This catches both accidental edits and prompt injection attacks that try to modify agent behavior.

## Pattern 7: Archival Rotation

Prevent vault bloat with time-based archival:

| Content | Threshold | Archive Location |
|---------|-----------|-----------------|
| Journal entries | >90 days | `journal/archive/YYYY-MM/` |
| Closed threads | >30 days inactive | `threads/archive/` |
| Completed tasks | Immediately | `tasks/done/YYYY-MM.md` |
| Lessons | **NEVER** | Stay in `lessons/` forever |

Lessons are never archived because they're the most valuable long-term memory.

## What Doesn't Work

- **Single MEMORY.md**: gets bloated, loses structure, hard to maintain
- **Trusting compaction summaries**: they lose nuance and detail
- **Writing to memory "later"**: later = never in agent context
- **Over-engineering**: vector databases and embeddings are overkill for <500 files
