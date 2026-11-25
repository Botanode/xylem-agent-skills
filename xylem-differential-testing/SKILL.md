---
name: xylem-differential-testing
description: "Compare semantics across compiler versions, backends and independent reference implementations."
---

# Differential Testing

## When to use

Compare semantics across compiler versions, backends and independent reference implementations.

## Procedure

1. Choose an oracle from spec-derived or independently validated reference behavior; ensure input and arithmetic contracts match.
2. Generate deterministic cases and compare output, traps or diagnostics as appropriate; preserve failing seeds and minimize divergences.
3. Avoid C undefined behavior and mismatched Rust overflow/FP settings; do not treat majority agreement as proof.

## Exit evidence

Reproducible seeds, divergence classification, minimized cases and passing comparisons after fixes.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
