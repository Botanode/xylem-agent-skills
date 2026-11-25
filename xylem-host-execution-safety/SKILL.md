---
name: xylem-host-execution-safety
description: "Preserve benchmark host authorization, isolation, locking and resource limits."
---

# Host Execution Safety

## When to use

Preserve benchmark host authorization, isolation, locking and resource limits.

## Procedure

1. Inspect the actual policy and required operator inputs; validate authorization and isolation independently of execution intent flags.
2. Use exclusive host locks, bounded process groups, timeouts, cancellation and cleanup; never set authorization/isolation claims without authority/evidence.
3. Test refusal, lock contention, timeout and cleanup using permitted fixtures; continue non-execution work if host authorization is absent.

## Exit evidence

Policy-conformant execution or explicit refusal evidence with no unauthorized workload launched.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
