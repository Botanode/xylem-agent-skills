---
name: xylem-toolchain-provenance
description: "Prevent stale compiler/backend binaries and misleading measurements."
---

# Toolchain Provenance

## When to use

Prevent stale compiler/backend binaries and misleading measurements.

## Procedure

1. Record resolved executable paths, versions, content hashes, source revisions, target, build profile and backend-host identity.
2. Validate compatibility and dynamic dependencies; reject stale or incompatible artifacts rather than silently picking PATH alternatives.
3. Pin the exact tools in the benchmark protocol and repeat validation after rebuilding; preserve separate build and run identities.

## Exit evidence

A reproducible manifest linking actual invoked binaries to source/build settings and compatibility checks.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
