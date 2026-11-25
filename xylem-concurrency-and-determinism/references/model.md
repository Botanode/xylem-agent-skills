# Concurrency model (verified from contract and conformance)

Syntax (dev line): `async fn main() -> i32 { return 0 }` (conformance/cases/async-main.xy:1-3);
`scope {}`, `spawn`, `await handle`, `channel<T>(cap)` (`contract.md:1965-2017`).
Torture cases exercise spawn, channel, cancel and scope failure.

Semantics: deterministic scheduler, structured scopes, cancellation, no
preemption, no real-time guarantee. Mutex/RwLock interpreter-only
(`contract.md:2327-2343`). Frozen edition rejects all concurrency (`scope.md:120`).
Native backend support is not established; the benchmark lab marks concurrency
cases FUTURE. Do not invent parallel-speedup claims.
