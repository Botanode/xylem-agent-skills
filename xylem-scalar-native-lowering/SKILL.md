---
name: xylem-scalar-native-lowering
description: "Emit machine-level scalar operations with correct types and edge semantics."
---

# Scalar Native Lowering

## When to use

Emit machine-level scalar operations with correct types and edge semantics.

## Procedure

1. Trace scalar operations through each backend; verify width, signedness, overflow, casts and call ABI.
2. Lower directly to legal IR/machine operations when possible; preserve required checks rather than using unchecked shortcuts.
3. Inspect emitted IR/disassembly for dynamic allocations/helper calls, and test boundary values and cross-call behavior.

## Exit evidence

Correctness tests and code-generation evidence for scalar paths, with fallback reasons if needed.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
