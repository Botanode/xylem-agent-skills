---
name: xylem-simd-vectorization
description: "Introduce vector operations only when target support and scalar equivalence are established."
---

# Simd Vectorization

## When to use

Introduce vector operations only when target support and scalar equivalence are established.

## Procedure

1. Inspect loop dependencies, alignment, aliasing, target features and reduction semantics.
2. Handle scalar tails, lane widths, unaligned access and portable fallbacks; avoid out-of-bounds overreads and unsupported CPU instructions.
3. Test lengths around vector width, feature-disabled targets and FP/determinism constraints; inspect generated instructions.

## Exit evidence

Scalar-vs-vector correctness matrix and target-specific codegen evidence.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
