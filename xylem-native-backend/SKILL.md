---
name: xylem-native-backend
description: "Develop the native code generation path without assuming completeness from repository naming."
---

# Native Backend

## When to use

Develop the native code generation path without assuming completeness from repository naming.

## Procedure

1. Discover actual native backend stages, supported ISA/targets and relationship to other backends; trace IR-to-object pipeline.
2. Verify register allocation, spills, stack alignment, relocations, instruction encoding and calling conventions where implemented.
3. Exercise control flow, mixed values, debug/unwind metadata as applicable; reject unsupported operations clearly.

## Exit evidence

Native pipeline support matrix and executable correctness/codegen tests on authorized targets.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
