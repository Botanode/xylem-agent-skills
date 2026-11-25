---
name: xylem-platform-performance-guardrails
description: Translate verified Xylem compiler inefficiencies into design-time rules for platform products. Use when writing or reviewing a platform design doc, budget table, layer diagram, or counter schema, or before attributing a slowdown to a platform layer.
trigger:
  branches:
    - "task/ecosystem/*"
    - "ecosystem-readiness/DESIGN/*"
  signals:
    - "a platform design doc, budget table or layer diagram"
    - "a proposed per-node container, helper call or cross-layer subscription"
source_of_truth: "ecosystem-readiness/DESIGN/PERFORMANCE_GUARDRAILS.md (v2 rules R1-R8; D-001 is authoritative layer contract)"
---

# Xylem platform performance guardrails

MUST express performance as design rules and blank budget fields, never as measurements. MUST NOT originate a performance number, claim, build, benchmark or CI action in this campaign (`PERFORMANCE_GUARDRAILS.md:21-28,100-106`). DEFAULT TO escalating a lower-layer gap as an interface request, never a protected-code edit (`:41,193-203`). For compiler depth, defer to `xylem-efficient-code` and `xylem-performance-analysis` (`.agents/skills/INDEX.md:14,22`); do not duplicate their IR/backend analysis here.

## Compiler inefficiency → platform rule (MUST apply)

- MUST store contiguous arenas and borrow views, never a heap box per UI/document node, and MUST make RC/COW visible and bounded — because F1 boxed `AValue` + RC helpers dominate instructions (`docs/development/PERFORMANCE.md:51,60-66`; R5, `PERFORMANCE_GUARDRAILS.md:64`).
- MUST cross a boundary only through a typed, versioned port owned by the owning layer and MUST NOT embed opaque per-node helper calls or mirrored ports in a hot path — because F2's C ABI helper table defeats the optimizer (`docs/development/PERFORMANCE.md:63-74`; R2/R3, `PERFORMANCE_GUARDRAILS.md:65`).
- MUST compute layout, validation and bindings once into stable indexed storage and MUST NOT per-event walk frames or allocate per-temp cells — because F3 cells/frames dominate teardown (`docs/development/PERFORMANCE.md:64`; R4/R5, `:66`).
- MUST keep one release authority with bounded RC/COW and MUST NOT hold a global mutable lock in a hot path — because F4 recursive RC and unshare locks dominate (`docs/development/PERFORMANCE.md:65,67`; R5, `:67`).
- MUST index once with integer IDs/maps and reuse, and MUST NOT re-parse or rescan a tree per change — because F5 whole-program scans grow superlinearly (`docs/development/PERFORMANCE.md:76-86,247-250`; R4, `:68`).
- MUST borrow/index once then measure and MUST NOT mandate interning or a buffer rewrite without protected-campaign A/B — because F6 rewrites were falsified (`docs/development/PERFORMANCE.md:82-86`; `:69`).
- MUST consume only published versioned identities and MUST NOT mirror or patch L0/L1 internals — because F7 IR/ABI churn requires migration (`AGENTS.md:14-20,109-115`; R2/R8, `:70`).
- MUST freeze workload + checksum and exact artifact identities and MUST treat counters as canaries, not results — because F8/F9 stale baselines and helper-count-as-speed mislead (`docs/development/PERFORMANCE.md:193,218`; R7, `:71-72`).
- MUST keep the rendering port in L4a and source dependencies downward while allowing upward runtime subscription flow — because F11 was the v1 `L3→L4` inversion (`PERFORMANCE_GUARDRAILS.md:74`; R1/R3).

## Stable boundaries and data-oriented layout

MUST name every consumed port with owner layer and version identity; MUST NOT let an adapter define or mirror the policy contract (R2, `PERFORMANCE_GUARDRAILS.md:34-41`). MUST list source dependency direction separately from runtime call/data flow: subscriptions established above, no lower layer storing upper-owned state, callbacks using explicit lifetimes/ids/borrowed snapshots (R3, `:36`). MUST prefer chunks of small contiguous components over boxed node objects — the layout Unity documents for ECS (`https://docs.unity3d.com/Packages/com.unity.entities@0.51/manual/ecs_components.html`); adapters translate technology-agnostic ports rather than owning policy (AWS hexagonal architecture, `https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/hexagonal-architecture.html`). MUST keep the encoding portable and stable so decoding stays cheap and payloads small (WebAssembly FAQ, `https://webassembly.org/docs/faq/`).

## Per-layer counters and honest budgets

MUST provide a per-layer counter schema — allocations per node/op, RC/COW increments, helper census, instruction count, upward borrowed-snapshot count — as exact, non-sampled fields (`PERFORMANCE_GUARDRAILS.md:112-113,141-154`). MUST leave every budget cell `PENDING_VERIFICATION` with a named workload, host and artifact/port IDs; MUST NOT invent a target or hide a failing row in a geomean (`:136-159`). MUST label claims VERIFIED / MEASURED / INFERRED / HYPOTHESIS / PLANNED / UNKNOWN (`.agents/skills/INDEX.md:48`). MUST NOT use fast-math-style nondeterminism or delete required checks; proofs belong in L0, not guessed at L3/L4b (LLVM `https://llvm.org/docs/Frontend/PerformanceTips.html`; FaultMaps `https://llvm.org/docs/FaultMaps.html`; WebAssembly FAQ). Allocation regressions are testable — reuse collections and add allocation tests (Rust Performance Book `https://nnethercote.github.io/perf-book/heap-allocations.html`). The protected benchmark harness and its binaries are off-limits (`PERFORMANCE_GUARDRAILS.md:98-106`; `AGENTS.md:14-20,138-142`).

## Completion criteria (checkable)

- [ ] R1-R8 each marked PASS / FAIL / N_A with `file:line` evidence (`:161-191`).
- [ ] Budget table present with PENDING cells, workload, host, artifact and port/layer IDs; zero invented numbers.
- [ ] Counters are exact fields per layer; no number originates in this campaign.
- [ ] Every L0/L1 gap is an interface request with no protected-file edit.
- [ ] No benchmark/CI/push invoked and no protected harness touched.

## References

- Local: `ecosystem-readiness/DESIGN/PERFORMANCE_GUARDRAILS.md:12-41,60-74,92-106,108-159,161-203`; `docs/development/PERFORMANCE.md:51,60-66,76-86,193-218`; `AGENTS.md:14-20,91-99,109-142`; `.agents/skills/INDEX.md:14,22,48`.
- Web: https://llvm.org/docs/Frontend/PerformanceTips.html ; https://llvm.org/docs/Passes.html ; https://llvm.org/docs/FaultMaps.html ; https://nnethercote.github.io/perf-book/heap-allocations.html ; https://nnethercote.github.io/perf-book/benchmarking.html ; https://webassembly.org/docs/faq/ ; https://docs.unity3d.com/Packages/com.unity.entities@0.51/manual/ecs_components.html ; https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/hexagonal-architecture.html .
