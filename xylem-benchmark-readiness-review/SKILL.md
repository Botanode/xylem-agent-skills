---
name: xylem-benchmark-readiness-review
description: "Independently determine whether the compiler and lab can start the full benchmark campaign."
---

# Benchmark Readiness Review

## When to use

Independently determine whether the compiler and lab can start the full benchmark campaign.

## Procedure

1. Inspect all in-scope cases, current tool manifest, fixture completeness, backend support, test outcomes and pending defects.
2. Verify representative authorized smoke execution, exact checksums and raw artifacts; distinguish build-only readiness from execution readiness.
3. Check remaining external authorization and resource requirements; provide exact campaign entry point and reject premature completion.

## Exit evidence

A readiness verdict (ready/not ready/blocked), acceptance matrix, exact evidence and launch command if available.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
