---
name: xylem-regression-control
description: "Prevent regressions from being ignored because they predate a change."
---

# Regression Control

## When to use

Prevent regressions from being ignored because they predate a change.

## Procedure

1. Capture a clean baseline on a comparable revision/environment when feasible; classify new, existing, flaky and unverified failures.
2. Reduce and investigate failures that affect mission readiness even if pre-existing; never suppress a test to manufacture green status.
3. Add a regression test that fails on the defective behavior and passes after the fix; verify nearby affected cases.

## Exit evidence

A baseline comparison, regression test, exact failing/passing commands and any remaining known failures.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
