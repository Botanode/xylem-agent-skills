---
name: xylem-compiler-security
description: "Protect the compiler/runtime and benchmark harness against malformed input and unsafe defaults."
---

# Compiler Security

## When to use

Protect the compiler/runtime and benchmark harness against malformed input and unsafe defaults.

## Procedure

1. Identify trust boundaries, untrusted source/fixtures, plugins, subprocesses, artifact paths and resource amplification.
2. Validate inputs, bound recursion/allocation/process lifetime, avoid shell interpolation and keep secrets out of artifacts.
3. Preserve runtime checks and authorization; test malformed data and refusal paths without weakening protections for performance.

## Exit evidence

Threat-boundary review, negative tests and clear residual risks.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
