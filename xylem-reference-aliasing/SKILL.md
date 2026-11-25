---
name: xylem-reference-aliasing
description: "Preserve reference lifetimes, provenance, mutability and alias guarantees."
---

# Reference Aliasing

## When to use

Preserve reference lifetimes, provenance, mutability and alias guarantees.

## Procedure

1. Inspect authoritative borrowing/aliasing rules; trace reference creation, escape, reborrow and mutation.
2. Prove assumptions used for noalias, lifetime markers and load/store optimization; use conservative lowering when proof is absent.
3. Test conflicting borrows, nonoverlapping access, escaped locals, invalidation and FFI boundaries as applicable.

## Exit evidence

Positive/negative lifetime tests and evidence for any alias attributes or unsafe assumptions.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
