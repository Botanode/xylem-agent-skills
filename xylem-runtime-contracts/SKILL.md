---
name: xylem-runtime-contracts
description: "Maintain runtime helper contracts and prevent runtime fallbacks from swallowing compiler responsibilities."
---

# Runtime Contracts

## When to use

Maintain runtime helper contracts and prevent runtime fallbacks from swallowing compiler responsibilities.

## Procedure

1. Inventory runtime functions, ownership, effects, error semantics, ABI and consumers; identify hot helpers versus legitimate boundaries.
2. Keep helper declarations and implementations synchronized; use native lowering for proven statically typed paths.
3. Test symbol resolution, invalid inputs, allocation failure and lifetime boundaries; record intentional runtime calls and reasons.

## Exit evidence

Runtime ABI inventory, integration tests and helper/fallback evidence for affected paths.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
