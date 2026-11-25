---
name: xylem-dependency-closure
description: "Resolve missing symbols, stubs, outdated registries and unimplemented prerequisites."
---

# Dependency Closure

## When to use

Resolve missing symbols, stubs, outdated registries and unimplemented prerequisites.

## Procedure

1. Follow imports, calls, generated files, symbol references and consumer contracts to find the complete dependency chain.
2. Implement missing producer and consumer pieces using real semantics; search for other uses and analogous incomplete hooks.
3. Run the actual consumer path, not just the producer unit test; identify external credentials/authorization separately from code defects.

## Exit evidence

No unresolved required symbols or placeholders on the target path, plus a consumer-level reproduction and passing check.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
