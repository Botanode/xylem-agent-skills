---
name: xylem-performance-analysis
description: Investigate and explain real Xylem performance, classify root causes, and design fair experiments. Use when a workload is slow, a regression is suspected, allocations or runtime calls are high, or when asked why Xylem underperforms Rust or C.
---

# Xylem performance analysis

A benchmark result is only useful if it explains which subsystem is responsible.
A difference is not evidence of a compiler defect until semantics, representation
and hardware are accounted for.

## Decision model (follow in order)

1. **Workload** — input size, operation frequency, latency/throughput target,
   memory constraints, data distribution, worst case.
2. **Algorithm** — time/space complexity, data structure choice, unnecessary work.
3. **Representation** — primitive vs dynamic, aggregate layout, copies,
   allocation, lifetime.
4. **Lowering** — canonical IR, runtime calls, ABI crossings, optimization
   opportunities, backend restrictions.
5. **Machine code** — instructions, loads/stores, branches, calls, vectorization.
6. **Root cause** — source / frontend / IR / optimizer / backend / ABI / runtime /
   memory manager / stdlib / benchmark method / hardware.
7. **Smallest justified change** — source workaround only when compiler fix is
   not feasible; otherwise propose a compiler/runtime change.
8. **Verify** — correctness gates first, then paired A/B with exact identities.
9. **Generalize** — update the pattern library only when evidence supports it.

## Classification labels

Use VERIFIED, MEASURED, INFERRED, HYPOTHESIS, PLANNED, UNKNOWN. Every
architecture/performance claim in a report carries one.

## Evidence to collect

- Checksum equality across implementations (currently only 49/86 in the lab).
- `XYLEM_MEMORY_STATS=1` allocation counts; `xylem profile` runtime helper census.
- Canonical IR **after** optimization (`xylem ir --json` prints only the optimized
  program — see `compiler/src/cli_ir.xy:51-57`). For a before/after pair, use an
  IR canary or a command that exposes both stages; verify support before relying
  on it.
- Assembly (`objdump -d`) call/branch/vector/spill counts.
- Artifact identities: compiler/host hashes, LLVM/clang version, flags, seed,
  target, samples.
- Noise floor: instructions ±0.2% typical, wall ±9% outliers; significance
  requires CI excluding 1.0 AND effect above noise AND reproducibility.

## Known bottlenecks (from historical diagnostics, re-check before applying)

- Boxed `AValue`, per-temp cells, refcount traffic and opaque helper calls
  dominate both compiler and generated program time. Evidence:
  `docs/development/PERFORMANCE.md:51,60-66` and
  `docs/development/performance-execution-record.md:1355-1363`. The archived
  `docs/development/_archive/native-runtime-profile.md.bak` is superseded, not
  canonical; `docs/development/PERFORMANCE.md` is the source of truth.
- `map_remove` ownership bug blocks the remove path (execution record §18.1).
- Compiler throughput ~45× for 10× source (COMP-002).
- LLVM emits no IR `target triple`/`target datalayout` directive and no
  `!range`/`nsw/nuw` flags (verified by absence across
  `xylem-rust/crates/xylem-llvm/src/**`; `docs/development/performance-execution-record.md:2455`).
  Native struct-vector lowering is gated, so there is no guaranteed-native
  vector IR on the hot path (`xylem-rust/crates/xylem-llvm/src/lib.rs:864-912`).
  Cranelift is development-only.
- Only 49/86 C↔Rust checksums match — no ranking until equivalence is fixed.

Re-verify current compiler before repeating old advice; fixes land frequently.

## Reporting

State: workload, equivalent-work evidence, root cause with file:line/artifact,
classification, fix ownership (application/stdlib/runtime/compiler), measured
effect with CI, remaining limitations, and what an independent verifier must
reproduce. Never claim language-wide parity from a subset.

## References

- `references/attribution.md` — A/B/C/D/E classification and evidence requirements.
- `references/current-evidence.md` — pointers to authoritative measurement records.
