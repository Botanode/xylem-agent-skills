---
name: xylem-capabilities-and-effects
description: "Preserve capability or effect guarantees where they are specified by Xylem."
---

# Capabilities And Effects

## When to use

Preserve capability or effect guarantees where they are specified by Xylem.

## Procedure

1. Verify the feature exists and identify its exact boundary semantics, inference, attenuation or effect rules; do not import another language's design.
2. Trace authority through calls, storage, plugins and FFI; prevent optimizations from duplicating or dropping effectful operations.
3. Test rejected unauthorized operations, inferred effects and legal boundary crossings; distinguish implementation from future proposals.

## Exit evidence

Spec-backed effect/capability tests, boundary review and explicit unsupported status if outside current scope.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
