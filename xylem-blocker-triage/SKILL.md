---
name: xylem-blocker-triage
description: "Distinguish resolvable engineering work from genuine external blockers."
---

# Blocker Triage

## When to use

Distinguish resolvable engineering work from genuine external blockers.

## Procedure

1. Reproduce the failure and classify code, configuration, environment, permissions, resource or upstream dependency.
2. Inspect alternative authorized routes, implement local prerequisites and bound repeated attempts using evidence.
3. For an external blocker, specify exact missing input, why it is required, safe commands or actions for the operator, and remaining independent work.

## Exit evidence

A minimal reproduction plus resolved cause or actionable external blocker; no vague handoffs.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
