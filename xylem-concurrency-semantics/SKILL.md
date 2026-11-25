---
name: xylem-concurrency-semantics
description: "Implement and validate supported concurrency, atomics and asynchronous behavior."
---

# Concurrency Semantics

## When to use

Implement and validate supported concurrency, atomics and asynchronous behavior.

## Procedure

1. Read the language memory model and supported async/concurrency features; map synchronization and suspension semantics.
2. Check data races, cancellation, lifetime across suspension, atomic orderings and scheduler behavior; avoid assuming deterministic execution unless specified.
3. Use stress/model tests where applicable; do not force unsupported features into readiness without a scoped specification decision.

## Exit evidence

Concurrency contract tests, race/safety evidence and documented support boundaries.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
