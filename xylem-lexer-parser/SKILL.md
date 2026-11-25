---
name: xylem-lexer-parser
description: "Maintain robust lexing, parsing, syntax recovery and source spans."
---

# Lexer Parser

## When to use

Maintain robust lexing, parsing, syntax recovery and source spans.

## Procedure

1. Define token/grammar changes, precedence, associativity and ambiguity cases; avoid ad hoc syntax recognition downstream.
2. Test malformed UTF-8/input as applicable, nested syntax, comments, escapes, recovery progress and diagnostic spans.
3. Bound recursion/resource use for hostile inputs; ensure recovery cannot loop or silently accept invalid syntax.

## Exit evidence

Golden AST/token tests, negative cases and a minimal syntax reproducer with expected diagnostics.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
