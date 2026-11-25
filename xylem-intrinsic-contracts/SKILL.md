---
name: xylem-intrinsic-contracts
description: "Keep intrinsic definitions, semantics, lowering and benchmark registries synchronized."
---

# Intrinsic Contracts

## When to use

Keep intrinsic definitions, semantics, lowering and benchmark registries synchronized.

## Procedure

1. Inventory canonical intrinsic names, signatures, widths, target feature requirements and semantics across spec/frontend/IR/backends.
2. For popcount, clz, ctz, bswap and bitreverse, explicitly test zero and width behavior as applicable; never assume backend defaults match.
3. Verify portable fallback, feature selection, rejected signatures and fixture catalog entries; prevent silent unsupported lowering.

## Exit evidence

Cross-layer registry diff and semantic/codegen tests for each intrinsic and target path.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
