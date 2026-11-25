---
name: xylem-cranelift-lowering
description: "Lower Xylem IR into valid Cranelift IR with native representations and ABI consistency."
---

# Cranelift Lowering

## When to use

Lower Xylem IR into valid Cranelift IR with native representations and ABI consistency.

## Procedure

1. Inspect supported types, block parameters, signatures, target ISA and runtime imports; identify accidental dynamic fallbacks.
2. Match arithmetic, traps, comparisons, aggregate layout and calling conventions to language semantics and target capabilities.
3. Validate emitted functions and cross-call behavior; compare representative outputs with the reference and other backends.

## Exit evidence

Cranelift verification/codegen evidence and semantic tests with explicit unsupported paths.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
