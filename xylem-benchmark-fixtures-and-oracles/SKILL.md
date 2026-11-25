---
name: xylem-benchmark-fixtures-and-oracles
description: "Make deterministic shared fixtures and independently justified expected outputs."
---

# Benchmark Fixtures And Oracles

## When to use

Make deterministic shared fixtures and independently justified expected outputs.

## Procedure

1. Define schema, seed algorithm, widths, endianness, limits and checksum semantics across all arms.
2. Generate or validate expected outputs independently; ensure malformed input fails explicitly and timing does not contaminate correctness.
3. Test seeds, sizes, empty/boundary cases and fixture hashes; distinguish collision-prone checksum evidence from full equivalence when necessary.

## Exit evidence

Versioned fixture/oracle contract, reproducible artifacts and exact cross-arm verification results.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
