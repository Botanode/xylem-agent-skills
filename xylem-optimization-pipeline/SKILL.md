---
name: xylem-optimization-pipeline
description: "Maintain an effective and predictable optimization pipeline rather than indiscriminate pass additions."
---

# Optimization Pipeline

## When to use

Maintain an effective and predictable optimization pipeline rather than indiscriminate pass additions.

## Procedure

1. Inventory pass order, analysis invalidation, prerequisites, optimization levels and current bottlenecks.
2. Prefer correcting representation/ABI before tuning passes; select transformations based on IR evidence or measurements.
3. Test pass interactions, fixed-point termination, compile-time cost, code size and semantic preservation.

## Exit evidence

Pipeline change rationale, pass-level IR evidence and correctness/compile-cost checks.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
