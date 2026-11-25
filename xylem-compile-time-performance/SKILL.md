---
name: xylem-compile-time-performance
description: "Improve compiler throughput and memory use without conflating compilation with program speed."
---

# Compile Time Performance

## When to use

Improve compiler throughput and memory use without conflating compilation with program speed.

## Procedure

1. Separate parsing, typing, IR, optimization, codegen, linking and process overhead; capture input scale and cold/warm conditions.
2. Inspect interning, repeated traversals, allocation, incremental cache keys and parallelism; avoid correctness-risking caches.
3. Check output identity or semantic equivalence, invalidation and resource budgets; report build-time and runtime metrics separately.

## Exit evidence

Stage measurements when authorized, cache correctness tests and a bounded compile-time regression assessment.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
