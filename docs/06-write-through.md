# 06 — Write-Through Protocol

## The Core Principle

> **Write-through, not write-back.**  
> Every decision, task, or significant information MUST be written to memory files **in the same turn** it emerges. Never defer to "later".

"Later" in AI agent context means "after compaction" which means "never".

## Write Triggers

| Trigger | Priority | Where to Write |
|---------|----------|----------------|
| Decision made | 🔴 Immediate | `decisions/` + `CONTEXT.md` + `journal/` |
| New task identified | 🔴 Immediate | `tasks/active.md` or `backlog.md` + `journal/` |
| Task completed | 🔴 Immediate | `tasks/active.md` → `tasks/done/` |
| Significant discussion | 🟡 Within turn | `threads/` |
| Plan/approach change | 🟡 Within turn | `CONTEXT.md` + `journal/` |
| User preference expressed | 🟡 Within turn | `preferences/user-prefs.md` + `journal/` |
| Side note / observation | 🟢 Max 3 turns | `journal/` under "Notes" |
| Background info | 🟢 Max 3 turns | `journal/` |

### Batching Rules

- 🔴 items: **always immediately**, no exceptions
- 🟡 items: if 3+ are pending, write them all before next turn
- 🟢 items: accumulate and batch-write to journal
- `CONTEXT.md`: only rewrite when something **materially changes**

## CONTEXT.md Is Sacred

`CONTEXT.md` must always reflect the current state of work. It answers:
- What are we working on right now?
- What's blocked and why?
- What are the next steps?

If CONTEXT.md is stale, update it **before** proceeding with new work.

```markdown
# CONTEXT.md — Current State
> Last updated: 2026-02-20 01:25 UTC

## Active Focus
📊 Memory System Upgrade — Phase 1 & 2 Complete ✅

## In Progress
- Memory improvement: 9-step upgrade plan...

## Blockers
- Webapp backend: API-51 bug blocking integration...

## Next Steps
1. Publish ScanFirst to ClawHub
2. ...
```

## Auto-Linking on Write

When creating a new file:
1. **Add full frontmatter** using the appropriate template
2. **Add to the folder's MOC** — the new file must be linked in the MOC
3. **Add bidirectional wikilinks** — if the new file mentions `[[X]]`, check if X should link back
4. **Connect to journal** — if it's a decision/lesson/protocol, add it to today's journal

## Write Rules

- Always: ISO timestamp, source attribution
- Always: use `[[wikilinks]]` for tracked entities
- Predictions: must include confidence %, timeframe, success/failure criteria
- Lessons: must explain what went wrong, the reasoning flaw, and what to change
- Never: modify `MEMORY.md` manually — use the generation script

## Self-Diagnosis

If you notice information was lost or the user repeats something already said:
1. Apologize
2. Capture the information immediately
3. Check for other gaps
4. Consider if a systemic fix is needed (missing trigger? wrong priority?)

## MEMORY.md Refresh

After 5+ files modified in a session → regenerate `MEMORY.md`:

```bash
bash scripts/generate-memory-index.sh
```

This ensures the root index always matches reality.
