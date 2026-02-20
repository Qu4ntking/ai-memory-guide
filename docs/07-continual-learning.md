# Chapter 7: Continual Learning Loop

> **Note:** Examples in this chapter use trading/research terminology for concreteness. The patterns apply to any domain — project management, coding, research, writing. Replace "prediction" with "estimate", "token" with "project", etc.

## The Loop

Continual learning isn't magic — it's a discipline. Every interaction is an opportunity to learn, but only if you capture it.

```
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│  INGEST  │───▶│ ANALYZE  │───▶│ RECORD  │───▶│  TRACK  │───▶│ CORRECT │───▶│  ADAPT  │
└─────────┘    └─────────┘    └─────────┘    └─────────┘    └─────────┘    └─────────┘
     ▲                                                                           │
     └───────────────────────────────────────────────────────────────────────────┘
```

### 1. INGEST
Consume information: news, data, user input, on-chain activity, tweets.
- Classify immediately: 🟢 ALPHA / 🟡 CONTEXT / 🔴 NOISE
- Single tweet is never sufficient for conviction

### 2. ANALYZE
What does this mean? Who benefits? What's the implication?
- Cross-reference with existing knowledge (`memory/knowledge/`)
- Check source reliability (`memory/knowledge/sources/`)
- Never form conviction from single source

### 3. RECORD
Write analysis + prediction to memory **in the same turn**.
- Predictions go in `memory/predictions/YYYY-MM.md` with:
  - Confidence percentage
  - Timeframe
  - Success/failure criteria (must be measurable)
- Analysis goes in relevant knowledge file

### 4. TRACK
Compare prediction to outcome when deadline arrives.
- Heartbeat checks predictions monthly
- Score: ✅ correct / ❌ wrong / ⏳ pending

### 5. CORRECT
If wrong, write WHY in `memory/lessons/`:
- What happened vs. what was predicted
- The reasoning flaw (not just "I was wrong")
- What evidence was misread or missing
- What would have been the correct analysis

### 6. ADAPT
Update mental models based on lessons:
- If a pattern fails 3 consecutive times → bench it (`patterns/benched/`)
- If a source is consistently wrong → downgrade reliability tier
- If a reasoning pattern keeps failing → document the anti-pattern

## The Strategy Decay Rule

```
Pattern active → fails → still active (1st failure)
Pattern active → fails again → extra scrutiny (2nd failure)  
Pattern active → fails third time → BENCHED
  Move to patterns/benched/ with failure hypothesis
  
Benched pattern re-activated → next failure = PERMANENT BENCH
```

## What NOT to Learn

- Don't memorize every price tick — only significant moves with context
- Don't save every tweet — only market-moving or genuine alpha
- Don't build opinions from single source — cross-reference
- Don't treat own past predictions as evidence — they're hypotheses until validated

## Weekly Self-Assessment

Every Sunday, write to `memory/lessons/weekly-YYYY-WW.md`:

```markdown
---
title: Weekly Assessment W08
created: 2026-02-23
type: lesson
tags: [weekly, self-assessment]
---

# Weekly Assessment — W08 2026

## Prediction Accuracy
- Total: X predictions scored
- Correct: Y (Z%)
- Wrong: W

## Biggest Miss
- What: [prediction]
- Why wrong: [reasoning flaw]
- Lesson: [what to change]

## Biggest Hit  
- What: [prediction]
- Why right: [what worked]

## Blind Spots
- [areas not covered]

## Pattern Health
- Active: N patterns, avg win rate X%
- Benched: M patterns

## One Specific Adjustment
[concrete change for next week]
```

## Metrics That Matter

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Prediction accuracy | >60% | Scored predictions / total |
| Info retention | 0 repeats | User never has to repeat info |
| Pattern win rate | >60% per pattern | Correct / total per pattern |
| Source accuracy | Track per source | Correct calls / total claims |
| Response to lessons | 100% | Every miss has a lesson file |

## The Compound Effect

After 30 days:
- 30 journal entries = complete activity log
- 10+ predictions scored = accuracy baseline
- 5+ lessons = growing wisdom
- Source reliability map = know who to trust
- Pattern library = validated strategies

After 90 days:
- Patterns with statistical significance
- Source tiers backed by data, not assumptions
- Prediction accuracy trend (improving or not)
- Anti-patterns documented (mistakes not to repeat)

This is genuine continual learning. Not training. Not fine-tuning. Just disciplined knowledge management.
