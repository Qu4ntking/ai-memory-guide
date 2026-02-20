# 04 — Frontmatter & Metadata

## Why Frontmatter

Every `.md` file in your memory vault should start with a YAML frontmatter block. This makes your files:

- **Queryable** — Obsidian Dataview can search/filter by any field
- **Sortable** — by date, type, status, tags
- **Machine-readable** — scripts can parse and generate indexes automatically
- **Self-documenting** — you always know what a file is and when it was created

## The Standard Fields

```yaml
---
title: "Human-readable title"
created: 2026-02-20
updated: 2026-02-20
type: journal         # see type list below
tags: [tag1, tag2]    # max 5, derived from content
---
```

### Required Fields

| Field | Format | Description |
|-------|--------|-------------|
| `title` | String | Human-readable name (quoted if special chars) |
| `created` | `YYYY-MM-DD` | When the file was first created |
| `updated` | `YYYY-MM-DD` | Last meaningful update |
| `type` | String | File type (see list below) |
| `tags` | Array | Categorization tags, max 5 |

### Optional Fields (by type)

| Field | Used By | Values |
|-------|---------|--------|
| `status` | decisions, threads, protocols | `active`, `closed`, `superseded` |
| `chain` | tokens | `base`, `ethereum`, `solana` |
| `category` | tokens, protocols | free text |
| `tier` | sources | `T1` through `T6` |
| `platform` | sources | `twitter`, `moltbook`, etc. |
| `confidence` | predictions | `0`-`100` (percentage) |
| `timeframe` | predictions | `24h`, `1w`, `1m` |
| `outcome` | predictions | `pending`, `correct`, `wrong` |
| `aliases` | tokens, sources | Array of alternative names |

## Type Values

```
journal, decision, thread, task, token, narrative, 
source, insight, protocol, prediction, lesson, 
preference, draft, moc, reference
```

## Adding Frontmatter to Existing Files

If you have a vault with files that lack frontmatter, you can bulk-add it with a script:

```bash
#!/bin/bash
# add-frontmatter.sh — Add YAML frontmatter to files without it

add_fm() {
  local file="$1" title="$2" created="$3" type="$4"
  shift 4; local tags="$*"
  
  # Skip if already has frontmatter
  head -1 "$file" | grep -q "^---" && return
  
  local tmp=$(mktemp)
  { echo "---"
    echo "title: \"$title\""
    echo "created: $created"
    echo "updated: $created"  
    echo "type: $type"
    echo "tags: [$tags]"
    echo "---"; echo ""
    cat "$file"
  } > "$tmp"
  mv "$tmp" "$file"
}

# Usage: add_fm "path/to/file.md" "Title" "2026-02-20" "type" "tag1, tag2"
```

### Date Derivation Strategy

For existing files without known dates:
1. **Journal files**: date is in the filename (`YYYY-MM-DD.md`) ✅
2. **Other files**: check `git log --format=%aI -1 -- file` for last commit date
3. **Fallback**: use file system `stat` modified time
4. **Manual review**: for important files, verify dates make sense

> ⚠️ Don't trust `stat` dates if files were copied or moved — they'll all show the same date.

## Querying Frontmatter with Dataview

Once you have frontmatter, Obsidian's Dataview plugin lets you query like a database:

```dataview
TABLE status, tags, updated
FROM "protocols"  
WHERE type = "protocol"
SORT updated DESC
```

```dataview
TABLE tier, platform
FROM "knowledge/sources"
WHERE type = "source"
SORT tier ASC
```

```dataview
TABLE chain, category
FROM "knowledge/tokens"
WHERE type = "token" AND status = "watching"
```

## Verification

After adding frontmatter, verify all files have it:

```bash
grep -rL "^---" memory/ --include="*.md" | grep -v .obsidian | grep -v templates
# Should return empty (all files have frontmatter)
```
