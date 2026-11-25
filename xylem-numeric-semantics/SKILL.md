---
name: xylem-numeric-semantics
description: "Preserve integer widths, overflow, shifts, casts, comparisons and floating-point rules."
---

# Numeric Semantics

## When to use

Preserve integer widths, overflow, shifts, casts, comparisons and floating-point rules.

## Procedure

1. Resolve signedness, extension/truncation, overflow mode, shift bounds, division edge cases and FP contract from spec.
2. Test min/max values, zero, NaN, infinities, signed zero, subnormals and rounding where relevant; use a suitable oracle.
3. Do not introduce LLVM poison/UB or fast-math assumptions without proof; distinguish checked/wrapping/saturating operations.

## Exit evidence

Boundary-value and differential tests across relevant optimization levels/backends with exact expected behavior.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
