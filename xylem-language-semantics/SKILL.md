---
name: xylem-language-semantics
description: "Implement language behavior from explicit semantics rather than C or Rust assumptions."
---

# Language Semantics

## When to use

Implement language behavior from explicit semantics rather than C or Rust assumptions.

## Procedure

1. Find normative definitions for types, evaluation order, overflow, ownership, effects and failures; distinguish unspecified behavior from implementation bugs.
2. Write edge-case examples before changing semantics; propagate intentional changes through frontend, IR, runtime and documentation.
3. Preserve semantics across optimization levels/backends; resolve ambiguities through specification governance rather than implicit guesses.

## Exit evidence

A spec-referenced behavior matrix and cross-layer tests including invalid programs.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
