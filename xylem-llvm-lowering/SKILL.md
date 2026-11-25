---
name: xylem-llvm-lowering
description: "Lower Xylem IR into legal LLVM IR with correct target data, attributes and semantics."
---

# Llvm Lowering

## When to use

Lower Xylem IR into legal LLVM IR with correct target data, attributes and semantics.

## Procedure

1. Inspect LLVM version, data layout, target triple and actual IR emitter; verify instructions and ABI match the pinned toolchain.
2. Guard poison/undef, overflow flags, alignment, alias attributes and fast-math; preserve checks and correct intrinsic signatures.
3. Run appropriate LLVM verification and semantic tests; inspect optimized IR/assembly for the actual path.

## Exit evidence

Pinned tool identity, verifier results, IR snippets and differential correctness tests.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
