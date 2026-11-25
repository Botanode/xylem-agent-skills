---
name: xylem-ir-verification
description: "Detect malformed compiler IR before optimization, code generation or linking."
---

# Ir Verification

## When to use

Detect malformed compiler IR before optimization, code generation or linking.

## Procedure

1. Validate SSA definitions/dominance, block terminators, phi/block arguments, operand types and effect/layout invariants as applicable.
2. Run verifier at transformation boundaries in appropriate validation configurations; produce minimal failing IR and pass identity.
3. Test deliberately invalid IR and ensure unsupported constructs fail explicitly rather than generating wrong code.

## Exit evidence

Verifier coverage for new invariants and evidence that valid fixtures survive relevant pipeline boundaries.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
