---
name: xylem-translation-validation
description: "Check transformations or lowering against source-level semantics using bounded formal or executable models."
---

# Translation Validation

## When to use

Check transformations or lowering against source-level semantics using bounded formal or executable models.

## Procedure

1. Define pre/post IR semantics and domain assumptions; choose available equivalence tools or explicit proof obligations.
2. Model overflow, memory effects, aliasing, traps and nondeterminism accurately; do not claim proof outside modeled domain.
3. Record counterexamples, tool versions and proof gaps; use tests for areas not formally covered.

## Exit evidence

Reproducible proof/check result with stated assumptions and counterexamples, or clearly labeled unverified obligations.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
