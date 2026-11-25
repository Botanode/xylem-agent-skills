---
name: xylem-performance-regression-gates
description: "Prevent speed improvements in one area from hiding correctness, resource or other workload regressions."
---

# Performance Regression Gates

## When to use

Prevent speed improvements in one area from hiding correctness, resource or other workload regressions.

## Procedure

1. Select representative affected workloads and comparable baseline/candidate revisions; define meaningful thresholds before measurement.
2. Check correctness and protocol admissibility first; distinguish noise from persistent change and evaluate code size/build cost where relevant.
3. Require review for regressions or intentional tradeoffs; do not manipulate suite composition to improve aggregate metrics.

## Exit evidence

A revision-pinned regression comparison or pending measurement status with required next checks.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
