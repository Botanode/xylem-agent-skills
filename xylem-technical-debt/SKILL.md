---
name: xylem-technical-debt
description: "Identify architectural shortcuts and prevent them from becoming permanent compiler infrastructure."
---

# Technical Debt

## When to use

Identify architectural shortcuts and prevent them from becoming permanent compiler infrastructure.

## Procedure

1. Inventory fallback paths, TODOs, duplicated logic, suppressed diagnostics and temporary ABIs; rank by correctness and measured cost.
2. For each debt item, record a concrete trigger, owner, removal criterion and dependent features; avoid speculative cleanup.
3. Replace debt with the canonical design incrementally and prove old and new behavior during migration.

## Exit evidence

A debt ledger with reproducible impact and removal tests for items addressed.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
