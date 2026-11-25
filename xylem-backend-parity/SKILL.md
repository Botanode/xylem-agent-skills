---
name: xylem-backend-parity
description: "Keep LLVM, Cranelift and other supported backends semantically aligned."
---

# Backend Parity

## When to use

Keep LLVM, Cranelift and other supported backends semantically aligned.

## Procedure

1. Build a support matrix by operation/type/target; trace each backend's representation and fallback paths.
2. Reproduce discrepancies with minimal programs and compare typed IR, backend IR and output against the spec or oracle.
3. Implement or explicitly reject unsupported features; do not silently fall back to divergent semantics or claim unsupported parity.

## Exit evidence

Per-backend correctness matrix, explicit support boundaries and integration tests.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
