---
name: xylem-native-representation
description: "Prevent a dynamic boxed representation from becoming the default for statically typed values."
---

# Native Representation

## When to use

Prevent a dynamic boxed representation from becoming the default for statically typed values.

## Procedure

1. Trace source type to IR, ABI, storage and machine code; inventory dynamic values and runtime helpers on the target workload.
2. Choose native scalars, inline aggregates, typed buffers or explicit handles as semantics permit; keep dynamic representation at genuine dynamic boundaries.
3. Define migration and fallback policy; prove semantic equivalence and check emitted code for unintended reboxing.

## Exit evidence

Before/after representation and helper-call inventory, semantic tests and no unsupported performance claim.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
