---
name: xylem-fixture-driver-integration
description: "Implement benchmark fixture hooks as real runtime/compiler integrations, not stubs."
---

# Fixture Driver Integration

## When to use

Implement benchmark fixture hooks as real runtime/compiler integrations, not stubs.

## Procedure

1. Locate declarations and consumers of fixture_read_u64_values, fixture_monotonic_ticks and fixture_emit_u64; verify exact signatures and current requirements.
2. Implement deterministic input parsing, width/endian rules, monotonic timing and output/error semantics consistent with other benchmark arms.
3. Test malformed and boundary inputs, seeds, I/O failures and exact oracle results; build/link the actual Xylem fixture path.

## Exit evidence

Fixture driver contract tests and end-to-end build/verify evidence with real output.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
