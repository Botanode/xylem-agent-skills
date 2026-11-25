---
name: xylem-benchmark-admissibility
description: "Decide whether each benchmark result is valid before computing ratios or aggregates."
---

# Benchmark Admissibility

## When to use

Decide whether each benchmark result is valid before computing ratios or aggregates.

## Procedure

1. Require pinned tools, equivalent workload, successful build/run, oracle checksum, frozen protocol and valid raw samples.
2. Classify build failure, divergence, unsupported feature, execution failure and insufficient samples separately; keep invalid rows visible.
3. Never substitute zero or fabricated metrics; distinguish diagnostic from certified evidence and report denominators/exclusions.

## Exit evidence

A per-case admissibility record with exact reasons and metrics only for eligible samples.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
