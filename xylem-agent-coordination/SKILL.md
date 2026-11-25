---
name: xylem-agent-coordination
description: "Coordinate multiple agents without overlapping edits, builds or false delegation claims."
---

# Agent Coordination

## When to use

Coordinate multiple agents without overlapping edits, builds or false delegation claims.

## Procedure

1. Partition work by subsystem and file ownership; assign explicit integration contracts and shared-file owners.
2. Use actual supported subagents and bounded concurrency; serialize expensive builds or shared output writes and reconcile worktrees deliberately.
3. Review and integrate each result, resolve conflicting edits, and rerun affected checks on the combined revision.

## Exit evidence

A work allocation record, integration revision and evidence for actual completed work, not agent counts.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
