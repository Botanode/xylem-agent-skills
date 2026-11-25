---
name: xylem-escape-analysis
description: "Use escape and lifetime facts to eliminate unnecessary heap storage or copies."
---

# Escape Analysis

## When to use

Use escape and lifetime facts to eliminate unnecessary heap storage or copies.

## Procedure

1. Define escape lattice and conservative treatment of unknown calls, FFI, captured values and aliasing.
2. Propagate facts through calls/CFG; only promote objects to local storage when lifetime, identity and destructor behavior remain correct.
3. Test escaping returns, captured values, aliases, recursive calls and negative optimization cases.

## Exit evidence

Analysis tests, transformation evidence and correctness checks for both escaping and nonescaping values.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
