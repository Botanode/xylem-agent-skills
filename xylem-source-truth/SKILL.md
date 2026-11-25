---
name: xylem-source-truth
description: "Establish current source and specification truth before implementing or diagnosing."
---

# Source Truth

## When to use

Establish current source and specification truth before implementing or diagnosing.

## Procedure

1. Record repository roots, HEADs, dirty status, active feature flags, authoritative spec/ADR revisions and relevant call sites.
2. Trace actual execution paths and compare against documentation; distinguish historical evidence from current revision evidence.
3. If semantics conflict, identify the authority and resolve or escalate the policy decision before changing behavior.

## Exit evidence

A revision-pinned inventory with file/symbol references and explicit unresolved contradictions.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
