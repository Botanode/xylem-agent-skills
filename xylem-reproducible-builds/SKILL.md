---
name: xylem-reproducible-builds
description: "Make compiler and lab builds repeatable within known environment constraints."
---

# Reproducible Builds

## When to use

Make compiler and lab builds repeatable within known environment constraints.

## Procedure

1. Inspect lockfiles, toolchain pins, generated sources, environment variables, target features and offline/cache requirements.
2. Use existing canonical build commands and isolated output directories when appropriate; avoid arbitrary dependency upgrades.
3. Record exact commands and artifact hashes; distinguish byte-for-byte reproducibility from semantic equivalence and explain nondeterminism.

## Exit evidence

A reproducible build recipe and observed artifact/verification record for the current revision.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
