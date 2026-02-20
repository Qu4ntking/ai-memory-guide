# 11 — Advanced: Semantic Search & Beyond

## When You Need More

The system described in this guide works well for vaults up to ~500 files. Beyond that, or if you need fuzzy/semantic search, consider these options.

## Option 1: Built-in Semantic Search

Most AI agent platforms (OpenClaw, Claude Code, etc.) include a built-in `memory_search` tool that does semantic search over your markdown files. **Try this first.** It requires zero setup and works on your existing files.

Pros:
- Zero config, zero dependencies
- Works on existing markdown files immediately
- Maintained by the platform

Cons:
- Quality varies by platform
- No knowledge graph traversal
- Limited filtering options

## Option 2: Basic Memory (MCP-based)

[Basic Memory](https://github.com/basicmachines-co/basic-memory) is a knowledge graph tool that stores entities and relations in SQLite alongside markdown files.

**Our evaluation (v0.18.4):**
- ❌ Cannot import existing markdown files into its database
- ❌ Only indexes files created via its own MCP `write_note` tool
- ✅ Clean CLI, good architecture concept
- ✅ Has an OpenClaw plugin (`openclaw-basic-memory`)

**Verdict:** Good for starting fresh with MCP-native workflows. Not suitable for existing vaults. If you're building from scratch and use MCP, worth evaluating.

## Option 3: sqlite-vec + Local Embeddings

For true semantic search on existing files:

```
1. Generate embeddings for each file (e.g., using Ollama + nomic-embed-text)
2. Store in sqlite-vec (SQLite extension for vector search)
3. Query with cosine similarity
```

Pros:
- Works on existing files
- Fully local, no cloud dependency
- Fast (SQLite is fast)
- Can combine with metadata filters

Cons:
- Requires embedding model (Ollama ~4GB)
- Need to rebuild index when files change
- More complex setup

## Option 4: Redis + Qdrant (Full Stack)

The "Jarvis approach" from various tutorials:
- Redis as short-term buffer (recent conversations)
- Qdrant as long-term vector store (all memory)
- Cron job moves Redis → Qdrant nightly
- Deduplication via content hashing

**Our take:** Massively over-engineered for most use cases. If you need 30+ Python scripts to manage memory, you've gone too far. Consider this only if you're running multiple agents with shared memory.

## Option 5: Mem0

[Mem0](https://mem0.ai) offers persistent memory with auto-recall and auto-capture:
- Cloud version: 30-second setup, works with OpenClaw
- Self-hosted: Ollama + Qdrant + LLM

**Our take:** Cloud version creates vendor dependency. Self-hosted version requires significant infrastructure. For most agents, structured markdown + good write discipline is sufficient.

## Decision Framework

```
< 100 files  → Markdown + wikilinks + MOCs (this guide)
100-500 files → Add built-in semantic search
500+ files    → Consider sqlite-vec + embeddings
Multi-agent   → Consider Redis + Qdrant or Mem0
```

## What Matters Most

The biggest memory improvement doesn't come from technology — it comes from **discipline**:

1. Write immediately, not later
2. Use frontmatter consistently  
3. Link everything with wikilinks
4. Run health checks regularly
5. Never skip the pre-compaction flush

A well-maintained vault of 50 files beats a poorly-maintained vector database of 5000 embeddings every time.
