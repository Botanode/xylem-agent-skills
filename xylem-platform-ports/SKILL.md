---
name: xylem-platform-ports
description: Add or change a host-injected Xylem platform port and its deterministic tests. Use when defining a port interface, injecting an implementation, choosing an effect row, wiring an adapter, or debugging E3019 on a function-valued field; trigger on "inject", "port version", "stub", "effect row", "adapter boundary", or "lotus.storage/v1".
---

# Host-injected platform ports

The kernel owns the port interface; the host injects the implementation as an effectful function value. No host intrinsic, Rust crate, or concrete adapter is compiled into the kernel (`lotus/README.md:129-148`; `docs/decisions/D-005-lotus-port-strategy.md:31-38,188-192`). The four port modules under `lotus/ports/*.xy` are the single source of truth for signatures and effect rows; do not mirror them in an adapter package (`docs/decisions/D-001-platform-layering.md:72-83`).

## The four current ports

| Port module | Versioned id | Injected function type | Effect row |
|---|---|---|---|
| `ports/storage.xy` | `lotus.storage/v1` | `StorageRead = fn(&String) -> Result<String, Refusal>`, `StorageWrite = fn(&String, &String) -> Result<Unit, Refusal>` | `allocation` |
| `ports/clock.xy` | `lotus.clock/v1` | `NowMillis = fn() -> i64` | `external` |
| `ports/rng.xy` | `lotus.rng/v1` | `NextU64 = fn() -> u64` | `external` |
| `ports/transport.xy` | `lotus.transport/v1` | `SendText = fn(&String, &String) -> Result<Unit, Refusal>` | `network, allocation` |

Types and rows: `storage.xy:13-20`, `clock.xy:10-15`, `rng.xy:10-15`, `transport.xy:11-16`; catalog cross-check at `lotus/README.md:135-140`. Rationale: a port is a purposeful conversation, not a technology binding; a small fixed set of ports stays testable (Alistair Cockburn, https://alistair.cockburn.us/hexagonal-architecture/; AWS prescriptive guidance, https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/hexagonal-architecture.html — both note that extra adapter layers carry maintenance and latency cost).

## Interface rules

- MUST carry a canonical `version: String` built by `core.contract_id`, and MUST pin the supported port version to `/vN` (`storage.xy:22-42`; `clock.xy:17-35`; `contracts/core.xy:16-19`). The constructor accepts a family or an already-versioned id and canonicalizes it in one place (`canonical_version`, `storage.xy:28-35`). Rationale: identity lives with the port owner, so hosts cannot silently redefine it; component interfaces use versioned names to offer side-by-side versions (WebAssembly Component Model Explainer, https://github.com/WebAssembly/component-model/blob/main/design/mvp/Explainer.md).
- MUST declare the effect row on the injected function type and on every dispatcher helper that calls it (`transport.xy:11,38-41`; `clock.xy:10,37-40`). Rationale: the row is part of the interface; omitting it hides external or network behaviour from the caller's effects.
- MUST copy a function-valued field into a local before calling it: `let reader = port.read; reader(key)`. The direct form `port.read(key)` is rejected as `E3019` by the pinned compiler (`storage.xy:7-9,45-53`; `clock.xy:4-7,37-40`; `rng.xy:4-7,37-40`; `transport.xy:5-7,38-41`). Rationale: this is the verified indirect-call shape, not a style preference.
- MUST expose the injected function through a typed wrapper (`port_read`, `port_write`, `now`, `next_u64`, `send_text`) so callers never reach into the struct field. MUST keep returned errors in the shared `Refusal` envelope (`storage.xy:45-53`; `contracts/refusal.xy:101-114`).
- MUST NOT import a Rust runtime, call a host intrinsic, open a socket, read a clock, or draw randomness inside a port module (`ports/*.xy` headers; D-005:117-123). MUST NOT let an adapter depend on a sibling adapter or install a global mutable registry; wiring stays explicit at L6/L7 (`D-001:70,95-105`; `docs/decisions/D-002-plugin-centric-platform.md:46-65`). Rationale: substitutability and isolated tests are the point of the seam; a global registry re-couples what the port separates.
- MUST treat a new major as a new contract identity with explicit refusal of the old one, not an in-place signature change (D-005:194-196; `contracts/version.xy:11-45`). Rationale: callers must see an incompatibility, never a coerced call.

## Deterministic stub tests

- MUST construct each port in tests from a host-side function value with a fixed result and assert the report byte-for-byte. The four consumer examples show the pattern: `table_read`/`table_write` in `examples/lotus-web-consumer/src/consumer.xy:67-97`, `send_stub` in `examples/lotus-server-consumer/src/server.xy:95-107`, `fixed_now() -> 1234` in `examples/lotus-desktop-consumer/src/desktop.xy:93-104`, `fixed_next() -> 42` in `examples/lotus-mobile-consumer/src/mobile.xy:93-104`; main modules drive accepted and refused fixtures (`examples/lotus-web-consumer/src/main.xy:35-96`). The kernel-level suite is `lotus/tests/p1_ports.xy` (D-005:55-63).
- MUST include a negative case: unknown key → `UMS-REF-0048`, unknown major → `UMS-REF-0009` (`examples/lotus-web-consumer/src/consumer.xy:67-86,122-142`). Rationale: a stub that only returns success proves nothing about refusal behaviour.
- MUST keep stubs host-free: an in-memory table, a fixed integer, or an `Result.Ok(())` acknowledgement is sufficient; no file, process, or network is needed. Rationale: core WebAssembly exposes only i32/i64/f32/f64 through its basic ABI, and richer values require explicit glue (`https://wasm-bindgen.github.io/wasm-bindgen/contributing/design/index.html`); portable, stable interfaces beat embedding host types (https://webassembly.org/docs/faq/).

## Completion criteria

- [ ] Port has a `contract_id`-canonical version pinned to `/vN`.
- [ ] Injected function type and every dispatcher declare the same effect row.
- [ ] Every function-field call is made through a local copy; no `port.field(...)` remains.
- [ ] A deterministic stub and a negative refusal fixture both pass with the pinned compiler.
- [ ] No host intrinsic, Rust import, sibling-adapter import, or global mutable registry was added.
- [ ] Any version change is a new identity with an explicit refusal for the old major.

## References

- Local: `lotus/ports/{storage,clock,rng,transport}.xy` (headers and type/helper lines above); `lotus/contracts/core.xy:16-19`; `lotus/contracts/version.xy:11-45`; `lotus/contracts/refusal.xy:101-114`; `lotus/README.md:129-148`; `docs/decisions/D-005-lotus-port-strategy.md:31-38,55-63,117-123,188-196`; `docs/decisions/D-001-platform-layering.md:70,72-83,95-105`; `docs/decisions/D-002-plugin-centric-platform.md:46-65`; `examples/lotus-*-consumer/src/*.xy`.
- Web, fetched 2026-11-25: https://alistair.cockburn.us/hexagonal-architecture/ ; https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/hexagonal-architecture.html ; https://github.com/WebAssembly/component-model/blob/main/design/mvp/Explainer.md ; https://wasm-bindgen.github.io/wasm-bindgen/contributing/design/index.html ; https://webassembly.org/docs/faq/ .
