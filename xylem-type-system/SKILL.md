---
name: xylem-type-system
description: "Implement sound type checking, inference, coercions and type errors."
---

# Type System

## When to use

Implement sound type checking, inference, coercions and type errors.

## Procedure

1. Define constraints and allowed conversions; ensure unresolved or error types cannot enter executable IR as valid values.
2. Check generic bounds, variance/lifetimes where applicable, ambiguity, integer widths, coercion and recursive types.
3. Separate inference from lowering; verify rejection of invalid programs and agreement with runtime representation.

## Exit evidence

Positive and negative typing tests, diagnostic snapshots and typed-IR invariants.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
