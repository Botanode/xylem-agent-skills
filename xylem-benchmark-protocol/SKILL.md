---
name: xylem-benchmark-protocol
description: "Freeze and validate benchmark methodology before collecting timed samples."
---

# Benchmark Protocol

## When to use

Freeze and validate benchmark methodology before collecting timed samples.

## Procedure

1. Pin toolchains, build flags, workload version, CPU target, sizes, seeds, sample count/duration, warmup and scheduling.
2. Define timing boundaries, process startup, output validation, interleaving and outlier policy in advance; account for system conditions.
3. Avoid post-hoc exclusions or changing protocol mid-run; separate diagnostic experiments from certified campaigns.

## Exit evidence

A frozen protocol manifest and audit trail linking samples to the exact protocol and environment.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
