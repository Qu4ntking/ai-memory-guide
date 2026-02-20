# 05 — Wikilinks & Knowledge Graph

## Why Wikilinks

Wikilinks (`[[filename]]`) are the connective tissue of your memory vault. They turn a collection of files into a **knowledge graph** — a network where you can traverse from any concept to related concepts.

Without wikilinks: 50 isolated files, no connections, orphaned knowledge.  
With wikilinks: 50 connected nodes, navigable graph, discoverable relationships.

## Syntax

```markdown
Basic link:       [[filename]]
Aliased link:     [[filename|Display Text]]
```

> ⚠️ **Don't use aliased wikilinks inside markdown tables!** The `|` in `[[file|alias]]` conflicts with the table column separator. Use plain `[[filename]]` in tables, or use list format instead.

## What to Link

Link any **tracked entity** that has its own file:

```markdown
## Tokens & Projects
The [[ACME]] token is part of the [[ai-agents]] narrative on [[Base]].

## People & Sources  
According to [[analyst-alice]], the market is shifting.

## Protocols
The [[x402]] protocol enables agent-to-agent payments via [[Coinbase]].

## Internal References
See [[2026-02-20]] journal entry. Related decision: [[2026-02-20-adopt-obsidian]].
```

## Rules

1. **Link to filenames, not paths** — `[[ACME]]` not `[[knowledge/tokens/ACME]]`
2. **Set Obsidian to "shortest path"** — it resolves `[[ACME]]` to wherever `ACME.md` lives
3. **Unique filenames** — no two files should have the same name (even in different folders)
4. **Bidirectional links** — if A links to B, consider if B should link back to A
5. **Potential links are OK** — `[[Base]]` can exist without a `Base.md` file (Obsidian shows it as unresolved, which is useful for future expansion)

## MOC (Map of Content) Pattern

Every folder gets a MOC file that links to all files in that folder:

```markdown
# Protocols

- [[ERC-8004]] — Identity Standard
- [[x402]] — Payments (Coinbase)
- [[xbird]] — Twitter API
- [[openserv]] — Agent Marketplace 🟢
```

A **Master MOC** at the root links to all sub-MOCs:

```markdown
# 🧠 Memory — Master MOC

## Knowledge
- [[tokens-moc]] — Tokens (4 files)
- [[narratives-moc]] — Narratives (3 files)
- [[sources-moc]] — Sources (5 files)

## Operations
- [[journal-moc]] — Journal (10 entries)
- [[protocols-moc]] — Protocols (11 files)
- [[lessons-moc]] — Lessons (3 files)
```

## Fixing Orphans

An orphan is a file that no other file links to. Check for orphans:

```bash
for f in $(find memory/ -name "*.md" -not -path "*/.obsidian/*" \
  -not -name "*-moc.md" -not -name "MOC.md" -not -path "*/templates/*"); do
  fname=$(basename "$f" .md)
  refs=$(grep -rl "\[\[$fname" memory/ --include="*.md" | grep -v "$f" | wc -l)
  [ "$refs" -eq 0 ] && echo "ORPHAN: $f"
done
```

Fix orphans by:
1. Adding the file to its folder's MOC
2. Adding wikilinks from related files
3. Mentioning it in the journal entry where it was created

## Graph View

In Obsidian, press `Cmd+G` (or `Ctrl+G`) to open the Graph View. You'll see:
- **Large nodes** = files with many connections (hubs)
- **Clusters** = groups of related files
- **Isolated dots** = orphans (fix these!)
- **Color coding** = set by folder or tag in Obsidian settings

For a standalone HTML graph visualization, see [Chapter 10: Scripts](10-scripts.md).
