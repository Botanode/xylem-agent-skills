---
name: xylem-unsafe-code-review
description: "Review unsafe compiler/runtime code for soundness rather than trusting successful tests."
---

# Unsafe Code Review

## When to use

Review unsafe compiler/runtime code for soundness rather than trusting successful tests.

## Procedure

1. Inventory unsafe blocks, pointer operations, transmute, FFI, manual allocation and unchecked indexing; identify each safety invariant.
2. Check provenance, alignment, initialization, aliasing, lifetime, integer overflow, unwind and concurrency interactions.
3. Add safety comments and targeted tests; use applicable sanitizers or Miri only for supported code and environments.

## Exit evidence

A safety-invariant review, test results and explicitly unresolved risks; no blanket claim of soundness.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
