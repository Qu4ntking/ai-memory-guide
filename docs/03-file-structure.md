# 03 — File Structure & Naming

## The Directory Tree

```
memory/
├── MOC.md                 ← Master Map of Content (start here)
├── MEMORY.md              ← Auto-generated index (never edit manually)
├── OBSIDIAN-SETUP.md      ← Setup guide for Obsidian users
├── wikilink-rules.md      ← Wikilink conventions
│
├── journal/               ← Daily logs (YYYY-MM-DD.md)
│   ├── journal-moc.md     ← Chronological index
│   └── 2026-02-20.md
│
├── decisions/             ← Decisions with rationale
│   └── decisions-moc.md
│
├── threads/               ← Open discussions & evaluations
│   └── threads-moc.md
│
├── tasks/                 ← Task management
│   ├── active.md          ← Current tasks (this IS the index)
│   ├── backlog.md         ← Low priority / parked
│   └── done/              ← Completed (YYYY-MM.md)
│
├── knowledge/
│   ├── tokens/            ← Per-entity research files
│   │   └── tokens-moc.md
│   ├── narratives/        ← Tracked macro narratives
│   │   └── narratives-moc.md
│   ├── patterns/          ← Validated repeatable patterns
│   │   └── benched/       ← Failed patterns (3+ consecutive losses)
│   ├── insights/          ← Distilled analysis
│   │   └── insights-moc.md
│   └── sources/           ← Source reliability profiles
│       └── sources-moc.md
│
├── protocols/             ← External projects/protocols tracked
│   └── protocols-moc.md
│
├── predictions/           ← Monthly prediction logs
│   └── predictions-moc.md
│
├── lessons/               ← Post-mortems (NEVER archive these)
│   └── lessons-moc.md
│
├── preferences/           ← User preferences
│   └── user-prefs.md
│
├── drafts/                ← Work in progress
│   └── drafts-moc.md
│
└── templates/             ← Note templates for each type
    ├── journal-template.md
    ├── decision-template.md
    ├── token-template.md
    └── ...
```

## Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Journal | `YYYY-MM-DD.md` | `2026-02-20.md` |
| Decision | `YYYY-MM-DD-slug.md` | `2026-02-20-adopt-obsidian.md` |
| Thread | `slug.md` | `memory-improvement-research.md` |
| Token | `TICKER.md` (uppercase) | `ACME.md` |
| Lesson | `YYYY-MM-DD-slug.md` or `slug.md` | `timezone-handling.md` |
| Source | `handle.md` or `name.md` | `analyst-alice.md` |
| Protocol | `name-slug.md` | `vultisig-fast-vaults.md` |
| MOC | `type-moc.md` | `tokens-moc.md` |

## Rules

1. **No spaces in filenames** — use hyphens: `my-decision.md`
2. **Lowercase** for most files — exception: token tickers (`ACME.md`)
3. **One MOC per folder** — named `type-moc.md` (not `_index.md` — Obsidian handles unique names better)
4. **Templates stay in `templates/`** — never add frontmatter to templates
5. **No nesting beyond 2 levels** — `knowledge/tokens/` is the max depth

## The Decision Tree: "Where Do I Save This?"

```
New information →
├─ DECISION?    → decisions/ + CONTEXT.md + journal
├─ TASK?        → tasks/active.md or backlog.md + journal
├─ DISCUSSION?  → threads/slug.md
├─ PREFERENCE?  → preferences/user-prefs.md + journal
├─ CONTEXT CHANGE? → CONTEXT.md
└─ ANYTHING ELSE?  → journal/ under "Notes"
```
