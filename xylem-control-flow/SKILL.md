---
name: xylem-control-flow
description: "Lower branches, loops, calls and exits without changing evaluation or cleanup semantics."
---

# Control Flow

## When to use

Lower branches, loops, calls and exits without changing evaluation or cleanup semantics.

## Procedure

1. Trace CFG edges, dominance, phi/block arguments, short-circuit evaluation and exceptional/early exits where supported.
2. Test nested loops, zero iterations, breaks, continues, recursion and cleanup on every exit path.
3. Inspect optimized IR and emitted code for accidental duplicated effects or invalid reachability assumptions.

## Exit evidence

CFG/semantic tests including side effects and cleanup; verifier passes before and after transformations.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
