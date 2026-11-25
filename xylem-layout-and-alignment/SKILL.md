---
name: xylem-layout-and-alignment
description: "Maintain correct target-aware type sizes, padding, alignment and discriminants."
---

# Layout And Alignment

## When to use

Maintain correct target-aware type sizes, padding, alignment and discriminants.

## Procedure

1. Derive layout from canonical target data and type definitions; check nested aggregates, zero-sized values, arrays and tagged variants.
2. Validate offsets, alignment, padding handling and pointer width across caller/callee, runtime and foreign interfaces.
3. Avoid relying on Rust host struct layout unless explicitly guaranteed; never read uninitialized padding as semantic data.

## Exit evidence

Layout assertions, round-trip tests and target/ABI evidence for supported architectures.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
