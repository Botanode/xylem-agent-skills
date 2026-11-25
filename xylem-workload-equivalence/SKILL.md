---
name: xylem-workload-equivalence
description: "Ensure Xylem, Rust and C perform the same meaningful work before timing."
---

# Workload Equivalence

## When to use

Ensure Xylem, Rust and C perform the same meaningful work before timing.

## Procedure

1. Compare algorithms, data structures when required, input generation, operation counts, allocation/lifetime behavior and output observability.
2. Align integer/FP semantics, compiler options and setup/timed boundaries; avoid C UB, Rust mode mismatches and dead-code elimination.
3. Use shared fixtures and an independent oracle; separate algorithmic improvements into explicitly labeled comparisons.

## Exit evidence

A case-level equivalence contract, oracle checks and documented intentional differences.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
