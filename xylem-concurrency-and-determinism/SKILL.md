---
name: xylem-concurrency-and-determinism
description: Understand Xylem's implemented deterministic concurrency model and its current limitations. Use when asked about async, scope, spawn, channels, cancellation, scheduling, determinism, or parallel speedup in Xylem.
---

# Concurrency and determinism

Concurrency exists in the **development line** (edition 2027/2028) but is
deliberately absent from frozen 1.0 and from the current native backend path.
`docs/language/contract.md:1965-2017` specifies `async fn`, `async {}`, `scope
{}`, `spawn`, `await handle`, `channel<T>(cap)` and cancellation; conformance
cases `async-main`, torture cases `async_spawn.xy`, `async_channel.xy`,
`async_cancel.xy`, `async_scope.xy`, `async_scope_failure.xy` pin behavior.

## What is verified

- Scheduler is deterministic; no preemption and no real-time guarantee
  (`contract.md:2004-2017`; `scope.md:488`). Do not promise parallel speedup.
- Mutex/RwLock are interpreter-only; native parallel runtime work belongs in
  `xylem-rust` (`contract.md:2327-2343`).
- Frozen edition 2026 rejects concurrency constructs; check `xylem.toml`.
- Native backend does not support concurrency in the current release path;
  treat any native concurrency result as UNKNOWN until verified on the exact
  compiler/host pair.
- Replay/observable-state tooling exists (`xylem replay record/run`) for
  deterministic investigation; use it with `--native` where supported.

## Guidance

1. Check edition and capability matrix before using any concurrency construct.
2. Validate with `xylem check` and `xylem run` first; treat native as a separate
   backend question.
3. Prefer structured `scope`/`await` over detached tasks; document ordering.
4. Never assume atomics are free on ARM64 (weak memory model); do not bake
   fences into source — backend lowering owns that.
5. Record performance claims only with an equivalent serial baseline and exact
   identities; the "no parallel speedup" rule is current, not a law of the
   language's future.

## References

- `references/model.md` — construct list, semantics and current backend limits.
