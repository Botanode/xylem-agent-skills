---
name: xylem-aggregate-lowering
description: "Lower structs, tuples, enums and composite values to sound native storage."
---

# Aggregate Lowering

## When to use

Lower structs, tuples, enums and composite values to sound native storage.

## Procedure

1. Trace construction, projection, assignment, moves, copies, discriminants and destructors; choose layout from the canonical ABI.
2. Handle partial initialization, nested aggregates and return conventions; avoid whole-value boxing solely for field access.
3. Test aggregate values across calls, branches, arrays, references and optimization; check generated IR for avoidable helper traffic.

## Exit evidence

Semantic and ABI tests plus native representation evidence on representative workloads.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
