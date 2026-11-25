---
name: xylem-ffi-and-linking
description: "Validate foreign calls, symbol resolution, object generation and linker compatibility."
---

# Ffi And Linking

## When to use

Validate foreign calls, symbol resolution, object generation and linker compatibility.

## Procedure

1. Trace object format, symbol names, visibility, relocation, calling convention, target triple and library dependencies.
2. Verify foreign type layout and ownership contracts; avoid assuming host and target match in cross compilation.
3. Test link failures, missing symbols, mixed-language round trips and unsupported targets; record exact linker and flags.

## Exit evidence

Successful supported link/execute or explicit rejection, with object/symbol inspection and ABI tests.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
