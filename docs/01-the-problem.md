# Chapter 1: The Problem — AI Amnesia

## The Context Window Trap

Every LLM has a context window — a fixed amount of text it can "see" at once. Think of it as a whiteboard:

- You write on it as you talk
- When it fills up, old stuff gets erased
- The AI literally cannot remember what was erased

**Context compaction** is the mechanism that manages this. When the window fills up, the system summarizes older content to make room. The summary is lossy — details, nuances, and decisions get compressed or dropped entirely.

## Real Impact

A user [documented losing 45 hours](https://github.com/OpenClaw/OpenClaw/issues/5429) of accumulated work to silent compaction. No warning. No save. No recovery.

Common symptoms:
- "What project were we working on?" (after 2 hours of discussion)
- Repeating the same decision because the agent forgot the previous one
- Agent contradicts itself because it lost context
- Settings/preferences reset every session

## Why Bigger Context Windows Don't Fix It

Studies show dumping entire conversation history into a large context window actually **degrades reasoning quality**. The model gets overwhelmed by noise and can't find the signal.

Memory is a **knowledge management** problem, not a context window problem.

## The Three Types of Memory an AI Agent Needs

| Type | Lifespan | Example | Storage |
|------|----------|---------|---------|
| **Working Memory** | Current session | "We're debugging the login flow" | Context window |
| **Short-term Memory** | Days | "Yesterday we decided to use Redis" | Daily journal |
| **Long-term Memory** | Weeks/months | "User prefers concise answers, works on Project X" | Curated files |

Most AI agents only have working memory. This guide shows you how to add all three.

## What a Good Memory System Looks Like

✅ Survives restarts and compaction
✅ Human-readable and editable
✅ Searchable (both keyword and semantic)
✅ Self-maintaining (health checks, auto-indexing)
✅ Connected (entities link to each other)
✅ Versioned (you can see what changed and when)

❌ NOT a black box
❌ NOT dependent on cloud services
❌ NOT requiring a PhD to set up
