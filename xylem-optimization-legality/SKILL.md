---
name: xylem-optimization-legality
description: "Require a semantic proof or conservative condition for every optimization transformation."
---

# Optimization Legality

## When to use

Require a semantic proof or conservative condition for every optimization transformation.

## Procedure

1. State the equivalence obligation, preconditions and relevant memory/effect/overflow rules.
2. Check dominance, aliasing, traps, evaluation order and poison/undef semantics; do not rely on benchmark inputs as proof.
3. Test positive and negative transform cases; use differential or translation validation where available and bounded.

## Exit evidence

Documented legality conditions, before/after IR and tests rejecting unsafe transformations.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
