---
name: xylem-architecture-boundaries
description: "Prevent compiler subsystems from becoming duplicated or tightly coupled projects."
---

# Architecture Boundaries

## When to use

Prevent compiler subsystems from becoming duplicated or tightly coupled projects.

## Procedure

1. Trace dependencies and ownership across frontend, IR, optimizer, backend, runtime and tools; identify forbidden dependency directions.
2. Define a narrow typed interface and invariants; reuse the canonical implementation rather than creating parallel subsystems.
3. Evaluate alternatives and migration impact; remove obsolete paths only after consumers migrate and tests pass.

## Exit evidence

A dependency/ownership map, interface tests and evidence that legacy paths are either removed or deliberately retained.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
