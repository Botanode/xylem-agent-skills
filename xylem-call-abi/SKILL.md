---
name: xylem-call-abi
description: "Maintain efficient and compatible native call, return and foreign-function conventions."
---

# Call Abi

## When to use

Maintain efficient and compatible native call, return and foreign-function conventions.

## Procedure

1. Identify target ABI, argument classifications, stack alignment, register preservation, return layout and calling conventions.
2. Test mixed scalar/aggregate arguments, nested calls, recursion, variadic or FFI cases only where supported.
3. Ensure caller, callee, backend, runtime and generated declarations agree; avoid dynamic marshaling for statically known native calls.

## Exit evidence

ABI contract tests and disassembly/IR showing compatible calls and returns.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
