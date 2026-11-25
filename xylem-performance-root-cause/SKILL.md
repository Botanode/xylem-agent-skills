---
name: xylem-performance-root-cause
description: "Prioritize physical execution costs over speculative optimizer work."
---

# Performance Root Cause

## When to use

Prioritize physical execution costs over speculative optimizer work.

## Procedure

1. Break workload cost into representation, allocations, helper calls, copies, branches, memory and generated instructions; inspect actual hot paths.
2. Use minimal equivalent reproductions and authorized profiling; isolate compiler cost from runtime cost and startup.
3. Address largest demonstrated source of work first; check correctness and other workload regressions before claiming improvement.

## Exit evidence

A causal explanation supported by profiles/IR or clearly labeled hypotheses, plus targeted fixes and verification.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
