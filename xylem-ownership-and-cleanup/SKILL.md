---
name: xylem-ownership-and-cleanup
description: "Maintain correct ownership transfers, drops and cleanup across every path."
---

# Ownership And Cleanup

## When to use

Maintain correct ownership transfers, drops and cleanup across every path.

## Procedure

1. Trace value creation, move/copy/borrow, return, reassignment and destruction; model partial initialization and early exits.
2. Eliminate retains/releases only when ownership proof permits; ensure no double drop, leaks or use-after-free.
3. Test nested owned aggregates, exceptional exits where applicable and aliasing interactions; inspect cleanup IR.

## Exit evidence

Ownership invariants, destructor/event-count tests and applicable memory-safety checks.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
