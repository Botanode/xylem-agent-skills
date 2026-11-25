---
name: xylem-resource-aware-builds
description: "Control CPU, memory, disk and process concurrency during compiler work."
---

# Resource Aware Builds

## When to use

Control CPU, memory, disk and process concurrency during compiler work.

## Procedure

1. Inspect available resources and existing build instructions; select appropriate parallelism, timeouts and artifact directories.
2. Coordinate shared builds with other agents; avoid redundant full builds and uncontrolled retries; preserve unrelated processes.
3. Use targeted checks before broad verification when appropriate; report resource failures accurately without suppressing necessary tests.

## Exit evidence

Resource-aware command log, bounded execution and clear remaining verification gaps.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
