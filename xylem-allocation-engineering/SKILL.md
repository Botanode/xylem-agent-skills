---
name: xylem-allocation-engineering
description: "Find and reduce unnecessary allocation traffic without changing object lifetimes."
---

# Allocation Engineering

## When to use

Find and reduce unnecessary allocation traffic without changing object lifetimes.

## Procedure

1. Trace allocation sites, sizes, lifetime, escape behavior and failure semantics; distinguish workload allocations from compiler/runtime overhead.
2. Prefer stack/inline/arena storage only where lifetime and alignment proof permit; preserve ownership and OOM policy.
3. Measure allocation counts/bytes via authorized instrumentation; test reallocations, partial failures and escape paths.

## Exit evidence

Allocation inventory, safe lifetime tests and measured or explicitly unmeasured allocation delta.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
