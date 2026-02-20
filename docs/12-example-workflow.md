# 12 — Example: End-to-End Workflow

A concrete example of how the memory system works in a real agent session.

## Scenario

Your agent is a project management assistant. The user asks: *"What did we decide about the database migration last week?"*

## Step 1: Agent Reads Context

On session start, the agent loads:
- `MEMORY.md` — sees "database migration" in active threads
- `CONTEXT.md` — sees current focus is "v2.0 release prep"
- Today's journal — no mention of the migration yet

## Step 2: Agent Searches Memory

```
memory_search("database migration decision")
→ Hit: memory/decisions/2026-02-10-db-migration-delayed.md (score: 0.89)
→ Hit: memory/journal/2026-02-10.md (score: 0.72)
→ Hit: memory/threads/db-migration.md (score: 0.68)
```

## Step 3: Agent Reads the Decision File

```yaml
---
title: "Delay DB Migration — Wait for v2.0"
created: 2026-02-10
type: decision
tags: [database, migration, v2]
---

# Decision: Delay DB Migration

## Context
Migration from PostgreSQL to the new schema was planned for this sprint.
Two blockers identified: missing indexes and incomplete test coverage.

## Decision
Postpone migration until v2.0 release. Don't proceed until:
- Test coverage reaches 80%, OR
- Manual QA sign-off on critical paths

## Rationale
- Risk of data loss too high with current coverage [[db-migration]]
- v2.0 timeline gives 3 more weeks [[tasks/active]]
- Team bandwidth is stretched [[2026-02-10]]
```

## Step 4: Agent Responds

> "On Feb 10 we decided to postpone the database migration until v2.0 — the blockers were missing indexes and incomplete test coverage (currently below 80%). That decision is still in effect. Want me to check the current coverage status?"

## Step 5: Agent Logs the Interaction

The agent adds to today's journal:

```markdown
## Threads
- Revisited [[2026-02-10-db-migration-delayed]] — still valid, checking coverage status
```

## The Full Loop

```
User asks question
    ↓
Agent searches memory (memory_search)
    ↓
Agent reads relevant files (decisions/, knowledge/)
    ↓
Agent answers with context + citations
    ↓
Agent writes interaction to today's journal (write-through)
    ↓
If decision changed → new file in decisions/ + update CONTEXT.md
```

## What Would Happen WITHOUT This System

Without structured memory, the agent would say: *"I don't have any context about the database migration. Can you tell me what we discussed?"* — forcing the user to repeat themselves. Every. Single. Session.

## Key Takeaway

The memory system isn't magic. It's just **organized files + consistent write discipline + search**. The agent follows simple rules:
1. Always search before saying "I don't know"
2. Always write decisions to `decisions/`
3. Always log interactions in the daily journal
4. Always update `CONTEXT.md` when focus changes
