---
name: xylem-compiler-interning
description: "Optimize identifier/string interning and compiler symbol lookups safely."
---

# Compiler Interning

## When to use

Optimize identifier/string interning and compiler symbol lookups safely.

## Procedure

1. Trace ownership, normalization, hash/equality, stable ID lifetime and interner consumers.
2. Avoid repeated allocation/copy/hash; choose appropriate storage and table growth without invalidating live IDs.
3. Test repeated inserts, collisions, Unicode policy, module boundaries and deterministic behavior where required.

## Exit evidence

Interning semantic tests plus allocation/lookup evidence on compiler-relevant inputs.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
