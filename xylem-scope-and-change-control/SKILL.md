---
name: xylem-scope-and-change-control
description: "Keep implementation bounded and avoid speculative rewrites or silent requirement changes."
---

# Scope And Change Control

## When to use

Keep implementation bounded and avoid speculative rewrites or silent requirement changes.

## Procedure

1. Define the smallest coherent change that meets the actual mission; map related tasks and non-goals.
2. Inspect existing local changes before editing; isolate unrelated cleanup and keep feature changes separate from refactors.
3. Expand scope only for demonstrated dependencies; document impact and preserve established interfaces unless migration is agreed.

## Exit evidence

A scoped diff, dependency rationale and a clear list of intentional behavior changes.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
