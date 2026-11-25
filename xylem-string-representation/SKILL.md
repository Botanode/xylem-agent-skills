---
name: xylem-string-representation
description: "Implement efficient strings and byte buffers with correct encoding and lifetime semantics."
---

# String Representation

## When to use

Implement efficient strings and byte buffers with correct encoding and lifetime semantics.

## Procedure

1. Establish byte/character indexing, UTF validity, immutability and ownership contracts; trace length, capacity and slice representation.
2. Avoid repeated scans, allocations and copies in known-length operations; use safe views where lifetimes allow.
3. Test empty strings, embedded NUL, non-ASCII, boundary indices and concatenation/growth; distinguish byte from text operations.

## Exit evidence

String semantic tests, representation evidence and allocation/copy inventory.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
