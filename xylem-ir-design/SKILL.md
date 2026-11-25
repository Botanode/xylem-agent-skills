---
name: xylem-ir-design
description: "Define typed IR contracts and avoid lowering semantics into unstructured helper calls prematurely."
---

# Ir Design

## When to use

Define typed IR contracts and avoid lowering semantics into unstructured helper calls prematurely.

## Procedure

1. Identify each IR layer's purpose, operation semantics, types, effects and legal transitions.
2. Preserve information required for aliasing, ownership, layout, overflow and optimization; use explicit representations for unknown facts.
3. Introduce an operation with verifier, lowering and tests across affected consumers; avoid parallel shadow IRs without migration plan.

## Exit evidence

IR contract, verifier tests and before/after IR examples across the affected stages.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
