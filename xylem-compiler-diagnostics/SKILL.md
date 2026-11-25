---
name: xylem-compiler-diagnostics
description: "Produce precise actionable diagnostics without panic or silent recovery."
---

# Compiler Diagnostics

## When to use

Produce precise actionable diagnostics without panic or silent recovery.

## Procedure

1. Identify the stage that owns the error; preserve source spans, cause chains and stable diagnostic identifiers.
2. Test primary/secondary spans, malformed input, duplicate errors and deterministic ordering; avoid leaking secrets in logs.
3. Keep error recovery separate from executable output; avoid success exit status on compilation failure.

## Exit evidence

Golden negative tests, expected status codes and no invalid artifact published on failure.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
