---
name: xylem-mission-state
description: "Persist a dependency-aware mission ledger across sessions, agents and context compaction."
---

# Mission State

## When to use

Persist a dependency-aware mission ledger across sessions, agents and context compaction.

## Procedure

1. Use stable IDs, priorities, dependencies, scope, owner, status and measurable acceptance criteria; reuse the existing ledger rather than create competing trackers.
2. Record exact edits, commands, outcomes, revision and next task after each meaningful step; update state atomically when shared.
3. Resume from the latest verified checkpoint; reconcile stale or contradictory entries against source and tests.

## Exit evidence

A resumable state record distinguishing implemented, verified, failed and externally blocked tasks.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
