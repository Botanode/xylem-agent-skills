---
name: xylem-architecture-decision
description: "Make durable architecture decisions with explicit tradeoffs and migration gates."
---

# Architecture Decision

## When to use

Make durable architecture decisions with explicit tradeoffs and migration gates.

## Procedure

1. State problem, constraints, candidate designs and measurable costs; compare relevant existing compiler designs without blindly copying them.
2. Separate semantic requirements from implementation choices; record affected layers, compatibility and rollback strategy.
3. Use a small representative prototype where authorized; keep ADR status proposed until accepted by authorized governance.

## Exit evidence

An ADR with rationale, alternatives, testable invariants, migration gates and outstanding uncertainties.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
