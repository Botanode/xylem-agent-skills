---
name: xylem-lotus-kernel
description: Work in the Xylem-native Lotus kernel at L2b — contracts, ports, pure modules and schemas — without importing the Rust runtime. Use when porting a Lotus behaviour, distinguishing a contract from a module or schema, substituting SHA-256 for BLAKE3, preserving at-least-once semantics, or labeling verification status; trigger on "Lotus", "L2b", "5577f76", "BLAKE3", "at-least-once", "audit chain", or "workflow state".
---

# The Xylem-native Lotus kernel

Lotus is a platform meta-kernel, not a replacement for Xylem's compiler substrate or UI contract. The accepted strategy ports stable contracts, capability vocabulary, refusal rules, pure algorithms and evidence patterns into Xylem source at L2b; Rust crates stay a read-only reference specification (`docs/decisions/D-005-lotus-port-strategy.md:152-160`; `ecosystem-readiness/DESIGN/LOTUS_PORT.md:94-103`). Single source of truth: D-005 plus `lotus/README.md`, backed by pinned Lotus revision `5577f7660048be268bb0007cb212083af44b93eb` (short `5577f76`) (`lotus/README.md:9-10`; D-005:141-146).

## Four distinct artifacts

- **Contract** — a versioned identity, validation rule, or refusal vocabulary in Xylem source under `lotus/contracts/*.xy`. `core.xy` owns `family/vN` identities, `refusal.xy` owns the envelope and code registry, `version.xy` owns negotiation (`core.xy:16-19,118-141`; `refusal.xy:24-32,101-142`; `version.xy:11-70`). MUST add a new family here, never in an adapter.
- **Port** — a versioned interface with a host-injected effectful function value under `lotus/ports/*.xy` (`storage`, `clock`, `rng`, `transport`). The kernel owns the interface; L3/L7 supplies the implementation (D-005:188-192; `lotus/README.md:129-148`). Ports never open files, sockets, clocks, or RNGs themselves.
- **Module** — a portable pure algorithm in `lotus/modules/*.xy`: `catalog`, `engine`, `ops`, `runtime`, `sdk`, `supply_chain`. These are Xylem-native composition primitives with honest headers — no worker threads, host I/O, global subscriber, or release gate (`modules/runtime.xy:1-13`, `engine.xy:1-9`, `ops.xy:1-12`, `supply_chain.xy:1-10`, `catalog.xy:1-8`).
- **Schema** — a JSON Schema 2020-12 document plus accept/reject fixtures and the stdlib-only validator (`lotus/schemas`, `lotus/fixtures`, `lotus/tools/validate_lotus.py`). It checks structure only; semantic rules needing a provider registry remain `.xy` module obligations (`lotus/README.md:12-32,76-83`). Passing fixtures MUST NOT be reported as proof of semantics.

MUST NOT duplicate an identity, refusal code, or compatibility check across these artifacts. Rationale: one owner per fact is what keeps a port from becoming a second capability system (D-001:72-83; D-002:46-65).

## Placement and non-duplication

MUST keep the kernel at L2b — above protected L0/L1, below L3, consuming L2a capabilities; `xylem-ui` stays the only L4a UI contract (D-005:166-193). MUST place application-owned Lotus-style layers in the product-local `<product>.A2..A7` namespace instead of pasting Lotus's L0–L7 numbers onto Xylem's (`D-005:179-186`; `LOTUS_PORT.md:31-39`). MUST map advisory/SBOM/policy work to Xylem distribution authority rather than adding a second version or release gate (`D-005:215-218`; `modules/supply_chain.xy:1-10`), and MUST keep L7 conformance as Xylem-owned `PLT-*` structural checks, not a forked CLI/LSP (`docs/decisions/D-003-platform-app-conformance.md:44-56`). Rationale: duplicated policy layers are the exact collision that D-005's amendment resolves.

## SHA-256 substitution

MUST use `std/hash::sha256_text` for every digest and MUST record an explicit substitution note. Lotus 5577f76 hashes with BLAKE3; the Xylem port uses a length-prefixed encoding of sequence/previous_hash/payload and claims no byte compatibility with `event_hash` (`contracts/audit.xy:7-14,28-37,84-96,127-151`). Refusal correlation ids are likewise deterministic SHA-256 shapes, not random UUIDs (`refusal.xy:34-52`). MUST verify the chain linkage invariant — sequence from zero, each `previous_hash` equal to its predecessor's computed hash — and refuse tampering with `UMS-REF-0048` (`audit.xy:98-114`). Rationale: substitution is honest and testable; an unlabelled equivalence claim would be false (D-005:19-20,121).

## At-least-once semantics

MUST model duplicate delivery as idempotent replay, never exactly-once execution. `RunState` is `Pending`, `Running`, `Completed`, `Failed`, `Compensating`, `Waiting`, `Cancelled`; replay/duplicate events are accepted without a second run, terminal events can be replayed, a `Waiting` run resumes only on its matching trigger, and any other move out of a terminal or unrelated state is refused with `UMS-REF-0048` (`contracts/workflow.xy:1-11,16-24,60-81,122-133,175-210,212-234`). MUST leave authN, policy, and background coordination to the host (D-005:201-203; `LOTUS_PORT.md:55-59`). Rationale: the reference target is native-only, WASM/browser are plugin boundaries, and there is no OS sandbox — claiming exactly-once would overstate the contract.

## Explicitly out of scope here

MUST NOT add host adapters (SQLite/SeaORM, tokio/threads, HTTP/ureq, wasmtime or child-process plugin frames, browser bridges, concrete clocks/RNG), persisted workflow/lease/schedule, advisory or real SBOM artifacts, metrics/trace/telemetry, remote transport contracts, or the full upstream plugin ABI (`lotus/README.md:96-110`; D-005:117-123,137-138). MUST NOT change L0/L1, toolchain pins, Cargo dependencies, or CI/deploy triggers, and MUST NOT make performance or C-level parity claims (`D-004-product-surface.md:46-55`; D-005:199-200).

## Status and completion

MUST label each claim `IMPLEMENTED`, `PENDING_VERIFICATION`, or `PENDING_INDEPENDENT_VERIFICATION`, and MUST NOT tick a box without an independent verifier (D-005:115,236; `lotus/README.md:85-94`). The recorded `xylem test lotus` = 16 passed / 0 failed at push `7d5fcdc` is historical evidence, not a fresh run (D-005:6-11).

- [ ] Every ported behaviour cites the pinned 5577f76 source and names its owning artifact above.
- [ ] Digests use SHA-256 with a substitution note; no byte-compatibility claim appears.
- [ ] Replay and invalid-transition fixtures pass; at-least-once wording is preserved.
- [ ] No out-of-scope adapter, duplicate contract, or performance claim was introduced.
- [ ] Status labels are honest and independent verification is still PENDING unless reproduced.

## References

- Local: `docs/decisions/D-005-lotus-port-strategy.md:6-11,115-218,229-238`; `ecosystem-readiness/DESIGN/LOTUS_PORT.md:31-39,55-59,94-103`; `lotus/README.md:9-10,12-32,76-83,85-110,129-148`; `lotus/contracts/{core,refusal,version,audit,workflow}.xy` (lines above); `lotus/modules/*.xy` headers; `docs/decisions/D-001-platform-layering.md:72-83`; `docs/decisions/D-002-plugin-centric-platform.md:46-65`; `docs/decisions/D-003-platform-app-conformance.md:44-56`; `D-004-product-surface.md:46-55`.
- Web, fetched 2026-11-25: https://github.com/WebAssembly/component-model/blob/main/design/mvp/Explainer.md ; https://webassembly.org/docs/faq/ .
