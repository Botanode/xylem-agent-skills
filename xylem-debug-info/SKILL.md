---
name: xylem-debug-info
description: "Investigate debug metadata failures instead of dismissing them as unrelated noise."
---

# Debug Info

## When to use

Investigate debug metadata failures instead of dismissing them as unrelated noise.

## Procedure

1. Reduce failing debug_info case, identify backend, metadata producer, expected source locations and revision baseline.
2. Validate line tables, scopes, types, inlining and variable location rules as applicable; avoid masking defects via test removal.
3. Determine impact on correctness, profiling and tooling; run targeted tests and representative debugger/object inspection where available.

## Exit evidence

Minimal reproduction, fix or evidence of scoped nonimpact, and regression test results.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
