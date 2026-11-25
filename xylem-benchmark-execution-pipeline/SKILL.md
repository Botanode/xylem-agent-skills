---
name: xylem-benchmark-execution-pipeline
description: "Integrate build, verify, run, cancellation, sample persistence and reporting into a real workflow."
---

# Benchmark Execution Pipeline

## When to use

Integrate build, verify, run, cancellation, sample persistence and reporting into a real workflow.

## Procedure

1. Trace CLI commands and execution gates from catalog selection through tool resolution, build and oracle verification.
2. Freeze protocol before timed samples; run only on authorized hosts; preserve raw data, failures and cleanup behavior.
3. Test permitted refusal paths, build-only checks and authorized representative smoke runs; ensure no phantom run directory or metrics on refusal.

## Exit evidence

An end-to-end command and observed outcome, including raw artifacts only where actually produced.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
