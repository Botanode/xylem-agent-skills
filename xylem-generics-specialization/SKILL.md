---
name: xylem-generics-specialization
description: "Implement generics with correct substitution, representation and bounded compilation cost."
---

# Generics Specialization

## When to use

Implement generics with correct substitution, representation and bounded compilation cost.

## Procedure

1. Trace generic identity, substitutions, constraints and instantiation keys; detect recursive instantiation and cycles.
2. Choose specialization or shared code according to semantics and ABI; avoid accidental boxing caused by unresolved type parameters.
3. Test distinct instantiations, nested generic aggregates, cross-module symbols, code size and cache invalidation.

## Exit evidence

Generic semantic tests, emitted representation evidence and bounded-instantiation behavior.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
