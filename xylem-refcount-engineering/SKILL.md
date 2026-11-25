---
name: xylem-refcount-engineering
description: "Reduce retain/release overhead without breaking ownership or concurrency."
---

# Refcount Engineering

## When to use

Reduce retain/release overhead without breaking ownership or concurrency.

## Procedure

1. Trace ownership and reference-count operations along hot paths; classify redundant pairs and shared versus local ownership.
2. Prove elimination, borrowing or coalescing legality across calls, branches, exceptions and thread boundaries; preserve required atomic ordering.
3. Check counter overflow policy, final release, reentrancy and cleanup; use instrumentation or code inspection to identify residual traffic.

## Exit evidence

Ownership proof/tests and before/after retain-release evidence; no blanket non-atomic conversion.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
