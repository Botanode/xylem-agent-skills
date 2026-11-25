---
name: xylem-property-and-fuzz-testing
description: "Discover compiler defects with bounded generative and metamorphic tests."
---

# Property And Fuzz Testing

## When to use

Discover compiler defects with bounded generative and metamorphic tests.

## Procedure

1. Define properties, valid/invalid generators, seed control and expected invariants for the target stage.
2. Use bounded corpus mutation, shrinking and metamorphic transforms; isolate crashes and timeouts and avoid running unbounded fuzz jobs.
3. Persist minimized inputs and convert important failures into deterministic regression tests.

## Exit evidence

Property definitions, seeds/corpus, resource limits and observed failures or passing bounded run.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
