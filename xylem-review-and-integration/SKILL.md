---
name: xylem-review-and-integration
description: "Review a change as an integrated compiler product rather than an isolated patch."
---

# Review And Integration

## When to use

Review a change as an integrated compiler product rather than an isolated patch.

## Procedure

1. Inspect full diff, public contracts, invariants, feature combinations and affected downstream consumers.
2. Check correctness, safety, maintainability and performance evidence independently of the author's summary.
3. Reproduce essential tests on the integrated revision; require resolution of actionable defects or explicit scoped exceptions.

## Exit evidence

A review verdict with exact revision, findings, evidence and merge readiness, not merely approval of a plan.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
