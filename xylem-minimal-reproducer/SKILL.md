---
name: xylem-minimal-reproducer
description: "Reduce compiler failures to a stable, actionable test case."
---

# Minimal Reproducer

## When to use

Reduce compiler failures to a stable, actionable test case.

## Procedure

1. Record original command, source revision, target, inputs, expected and actual output; classify compile/link/runtime/semantic failures.
2. Minimize the input and flags while preserving the failure; avoid changing semantics or deleting a necessary trigger.
3. Trace the first divergent stage and add the reproducer to the correct regression suite; keep larger integration coverage when needed.

## Exit evidence

A small runnable reproduction, first failing stage, root-cause hypothesis and regression test.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
