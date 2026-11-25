---
name: xylem-test-design
description: "Build meaningful unit, integration, negative and end-to-end tests rather than superficial coverage."
---

# Test Design

## When to use

Build meaningful unit, integration, negative and end-to-end tests rather than superficial coverage.

## Procedure

1. Map acceptance criteria to tests at appropriate layers; identify failure modes and boundary cases.
2. Assert actual semantic values, side effects and failure behavior, not only successful compilation; use independent expected results.
3. Prefer deterministic fixtures and avoid snapshots that simply bless wrong output; verify the test detects the defect when feasible.

## Exit evidence

A test matrix covering contract, regression and real consumer path with exact executed/skipped results.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
