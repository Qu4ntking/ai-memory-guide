# Research & Sources

## Memory Systems Analyzed

### Basic Memory (MCP-based)
- **What**: Local knowledge graph in Markdown + SQLite, Obsidian compatible
- **How**: Semantic search, graph traversal via `memory://` URLs
- **OpenClaw plugin**: `openclaw-basic-memory` (CLI fallback, since OpenClaw doesn't use MCP)
- **Modes**: Archive (passive), Agent-Memory (replaces built-in), Both
- **Source**: [GitHub](https://github.com/basicmachines-co/basic-memory) | [Blog](https://basicmemory.com/blog/basic-memory-for-open-claw/)
- **Verdict**: Best semantic layer if you need graph queries. Archive mode is safe to try.

### Mem0 (Cloud or Self-hosted)
- **What**: External memory outside context window, Auto-Recall + Auto-Capture per turn
- **How**: Survives compaction and restarts. Long-term (user-scoped) + short-term (session-scoped)
- **Self-hosted**: Ollama embedder + Qdrant vector store + LLM
- **Source**: [Blog](https://mem0.ai/blog/mem0-memory-for-openclaw) | [GitHub](https://github.com/mem0ai/mem0/tree/main/openclaw)
- **Verdict**: Powerful but adds infrastructure. Best for users who need cross-tool memory.

### Redis + Qdrant ("Jarvis" approach)
- **What**: Redis as short-term buffer, Qdrant as long-term vector store
- **How**: Heartbeat dumps context to Redis, 3am cron converts to Qdrant, 3:30am cron adds markdown logs
- **Source**: [YouTube](https://www.youtube.com/watch?v=sIpXN2yyD78) | [GitHub](https://github.com/mdkrush/openclaw-jarvis-memory)
- **Verdict**: Creative but over-engineered for most use cases. 30+ Python scripts.

### Obsidian Native (our approach)
- **What**: Structured Markdown + YAML frontmatter + wikilinks in Obsidian vault
- **How**: Human-readable knowledge graph, queryable with Dataview, versioned with Git
- **Plugins**: Dataview, Graph Analysis, Templater, Git
- **Verdict**: Simple, powerful, zero external dependencies. This is what we recommend.

## Key Articles & Discussions

### Reddit
- [Comparing Memory In OpenClaw vs Claude Code](https://www.reddit.com/r/AI_Agents/comments/1r3vk5a/) — 3-layer system analysis
- [8 Ways OpenClaw Reduces Context Loss](https://www.reddit.com/r/AI_Agents/comments/1quy0b9/) — Community workarounds
- [Basic Memory + Obsidian](https://www.reddit.com/r/ObsidianMD/comments/1l9rdnb/) — Integration demo
- [The real problem with OpenClaw](https://www.reddit.com/r/AI_Agents/comments/1qvynpz/) — Architecture critique
- [CORE: Obsidian + AI temporal knowledge graph](https://www.reddit.com/r/ObsidianMD/comments/1nuiwhk/)

### Tutorials & Guides
- [How OpenClaw memory works](https://lumadock.com/tutorials/openclaw-memory-explained) — Best plain-language explanation
- [OpenClaw memory docs](https://docs.openclaw.ai/concepts/memory) — Official documentation
- [The Ultimate Guide to OpenClaw](https://corpwaters.substack.com/p/the-ultimate-guide-to-openclaw)

### YouTube
- [OpenClaw Memory Architecture Explained](https://www.youtube.com/watch?v=UUa7nyj2pc0) — 3-tier overview
- [Jarvis-like Memory Blueprint](https://www.youtube.com/watch?v=sIpXN2yyD78) — Redis + Qdrant approach

### GitHub
- [awesome-openclaw-skills](https://github.com/VoltAgent/awesome-openclaw-skills) — 3000+ skills catalog
- [openclaw-basic-memory](https://github.com/basicmachines-co/openclaw-basic-memory) — Basic Memory plugin
- [openclaw-memory](https://github.com/s1nthagent/openclaw-memory) — Alternative memory system
- [Context loss issue #5429](https://github.com/openclaw/openclaw/issues/5429) — 45 hours lost to compaction

## Key Insights

1. **Memory is knowledge management, not a context window problem** — Bigger windows don't help; structured retrieval does
2. **File-first is the right abstraction** — Markdown files are human-readable, version-controllable, and universal
3. **Wikilinks create a knowledge graph for free** — No database needed
4. **Write-through beats write-back** — Save immediately or lose it to compaction
5. **Health checks prevent rot** — Orphan files, stale content, and broken links degrade memory quality over time
6. **Pre-compaction flush is critical** — The agent must save everything before context is compressed
7. **Obsidian is the best visualization layer** — Graph View, Dataview queries, and human editing in one tool
