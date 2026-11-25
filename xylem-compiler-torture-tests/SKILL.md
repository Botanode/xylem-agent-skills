---
name: xylem-compiler-torture-tests
description: "Exercise adversarial but bounded programs across the full compiler pipeline."
---

# Compiler Torture Tests

## When to use

Exercise adversarial but bounded programs across the full compiler pipeline.

## Procedure

1. Create targeted cases for deep nesting, CFGs, generics, large types, recursion, arithmetic edges, malformed syntax and optimizer interactions.
2. Specify expected result or rejection; cap input size, execution time and memory; separate correctness stress from timed performance.
3. Run relevant backend/optimization combinations where supported; preserve minimized failures without weakening test scope.

## Exit evidence

Torture corpus with explicit oracle, limits, support status and reproducible failures.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
