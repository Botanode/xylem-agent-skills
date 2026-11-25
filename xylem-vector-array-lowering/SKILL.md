---
name: xylem-vector-array-lowering
description: "Implement typed contiguous arrays/vectors without per-element boxing where semantics permit."
---

# Vector Array Lowering

## When to use

Implement typed contiguous arrays/vectors without per-element boxing where semantics permit.

## Procedure

1. Inspect element layout, alignment, length/capacity, indexing, initialization and growth rules.
2. Use native element storage and amortized growth as appropriate; handle capacity overflow, allocation failure and element destruction.
3. Test zero length, boundary indexing, nested aggregates, reallocation and move/copy behavior; prove bounds-check optimizations.

## Exit evidence

Collection correctness tests and native storage/codegen evidence for representative element types.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
