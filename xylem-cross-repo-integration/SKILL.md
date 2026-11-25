---
name: xylem-cross-repo-integration
description: "Integrate compiler, language spec, platform, backend and lab changes as one compatible product."
---

# Cross Repo Integration

## When to use

Integrate compiler, language spec, platform, backend and lab changes as one compatible product.

## Procedure

1. Discover repository responsibilities and version pins; map producer/consumer contracts, generated schemas and release order.
2. Coordinate migrations through compatible revisions or explicit atomic integration; avoid changing one repository without updating its consumers.
3. Build the integrated revision set and run representative downstream workflows; retain old compatibility only when intended.

## Exit evidence

Cross-repo revision manifest, contract tests and successful consumer workflow or precise blocker.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
