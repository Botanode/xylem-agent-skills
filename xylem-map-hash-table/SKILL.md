---
name: xylem-map-hash-table
description: "Design and optimize maps without compromising hashing, equality or collision safety."
---

# Map Hash Table

## When to use

Design and optimize maps without compromising hashing, equality or collision safety.

## Procedure

1. Trace key/value representation, hash/equality contracts, probing, load factor, deletion and resize behavior.
2. Use typed storage, reuse hash results when legal and avoid per-lookup allocation; retain collision/security policy and specified iteration order.
3. Test collisions, tombstones, misses/hits, growth, adversarial keys, duplicate updates and iteration semantics; isolate build/lookup timings.

## Exit evidence

Correctness tests, memory/layout and helper-call inventory, and separately labeled map microbenchmark evidence if authorized.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
