---
name: xylem-profiling-and-counters
description: "Use hardware/software profiling to locate actual bottlenecks without inventing measurements."
---

# Profiling And Counters

## When to use

Use hardware/software profiling to locate actual bottlenecks without inventing measurements.

## Procedure

1. Record executable identity, workload, CPU and available permissions/counters; choose sampling or instrumentation appropriate to the hypothesis.
2. Separate wall time, instructions, cycles, allocations and helper calls; account for overhead and multiplexing.
3. If perf or counters are unavailable, record the restriction and use authorized alternatives such as IR/disassembly or instrumentation; do not alter host policy.

## Exit evidence

Reproducible profile/counter command, results or unavailability reason, and evidence-backed bottleneck interpretation.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
