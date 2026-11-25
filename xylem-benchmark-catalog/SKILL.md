---
name: xylem-benchmark-catalog
description: "Maintain a meaningful, representative benchmark suite rather than cherry-picked passing cases."
---

# Benchmark Catalog

## When to use

Maintain a meaningful, representative benchmark suite rather than cherry-picked passing cases.

## Procedure

1. Map each case to language/compiler feature, workload family, size/seed and intended metric; identify missing coverage or duplicates.
2. Define reference arms, oracle, prerequisites and admission rules; keep unsupported cases visible instead of deleting them.
3. Separate microbenchmarks, application workloads, stress tests, compile-time tests and profiling scenarios; freeze versions for campaigns.

## Exit evidence

A versioned catalog with feature coverage, support status, equivalence requirements and change rationale.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
