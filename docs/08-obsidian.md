# 08 — Obsidian Integration

## Why Obsidian

Your memory vault is already structured Markdown. Obsidian adds:
- **Graph View** — visual map of all connections between files
- **Dataview** — SQL-like queries on frontmatter metadata
- **Templater** — consistent file creation from templates
- **Git** — version control and backup
- **Live editing** — humans can browse and edit AI memory naturally

Zero infrastructure. No databases. No APIs. Just a folder of `.md` files.

## Setup

### 1. Open the Vault

1. Open Obsidian → "Open folder as vault"
2. Select your `memory/` folder
3. The `.obsidian/` config folder will be created (or use your existing one)

### 2. Configure Settings

In `.obsidian/app.json`:

```json
{
  "newLinkFormat": "shortest",
  "useMarkdownLinks": false,
  "showFrontmatter": true,
  "dailyNotes": {
    "format": "YYYY-MM-DD",
    "folder": "journal",
    "template": "templates/journal-template"
  }
}
```

Key settings:
- **Shortest path links** — `[[ACME]]` resolves to `knowledge/tokens/ACME.md` automatically
- **Wikilinks over Markdown links** — `[[file]]` not `[file](path/file.md)`
- **Show frontmatter** — see metadata in reading view

### 3. Install Plugins

Recommended community plugins (`.obsidian/community-plugins.json`):

```json
["dataview", "graph-analysis", "templater-obsidian", "obsidian-git", "obsidian-outliner"]
```

| Plugin | Purpose |
|--------|---------|
| **Dataview** | Query frontmatter like a database |
| **Graph Analysis** | Advanced graph metrics and analysis |
| **Templater** | Create notes from templates with variables |
| **Obsidian Git** | Auto-backup to git repository |
| **Outliner** | Better list/outline management |

### 4. Set Up Templates

Configure Templater → Template folder: `templates/`

Create templates for each file type. Example journal template:

```yaml
---
title: "{{date}}"
created: {{date}}
updated: {{date}}
type: journal
tags: [journal]
---

# Daily Log — {{date}} {{day}}

## Status

## Events

## Work Done

## Decisions

## Notes
```

## Useful Dataview Queries

### All tokens being watched
```dataview
TABLE chain, category, status
FROM "knowledge/tokens"
WHERE type = "token"
SORT file.name ASC
```

### Recent decisions
```dataview
TABLE status, tags
FROM "decisions"
WHERE type = "decision"
SORT created DESC
LIMIT 10
```

### Sources by reliability tier
```dataview
TABLE tier, platform
FROM "knowledge/sources"
WHERE type = "source"
SORT tier ASC
```

### Lessons (most recent first)
```dataview
TABLE category, created
FROM "lessons"
WHERE type = "lesson"
SORT created DESC
```

### Files modified this week
```dataview
TABLE type, updated
WHERE updated >= date(today) - dur(7 days)
SORT updated DESC
```

## Graph View Tips

- Press `Cmd+G` / `Ctrl+G` to open
- MOC files appear as large hub nodes (many connections)
- Orphaned files appear as isolated dots — fix these!
- Color-code by folder or tag in graph settings
- Use filters to focus on specific areas (e.g., show only tokens + narratives)

## What Obsidian Is NOT

Obsidian is a **viewing layer**, not the source of truth. The AI agent reads/writes files directly. Obsidian adds visual navigation for the human. Both can edit the same files.

Key rule: **the AI never depends on Obsidian being open**. Everything works from the command line.
