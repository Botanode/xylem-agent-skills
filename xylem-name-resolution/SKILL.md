---
name: xylem-name-resolution
description: "Implement correct binding, scope, imports and symbol identity."
---

# Name Resolution

## When to use

Implement correct binding, scope, imports and symbol identity.

## Procedure

1. Map scopes, namespaces, visibility, shadowing and module graph rules; distinguish names from stable symbol IDs.
2. Test forward references, cycles, aliases, duplicate definitions, generic scopes and hygiene where applicable.
3. Avoid reliance on hash iteration order; ensure diagnostic ordering and resolution results are deterministic.

## Exit evidence

Resolution tests with shadowing, ambiguous/import failure cases and reproducible symbol identity.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
