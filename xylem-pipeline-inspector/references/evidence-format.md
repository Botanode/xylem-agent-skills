# Trace record format

One trace record per investigated construct. Store under
`docs/development/traces/<id>.md` or the benchmark laboratory's `reports/`.

```markdown
# TRACE-<id>: <source construct>

## Source
- File:line and the minimal snippet.
- Checksum under `xylem run` and under `xylem build --release --backend llvm`.

## Identities
- Xylem compiler SHA-256, backend host SHA-256, LLVM/clang version, flags, seed, host.
- Commands that produced each artifact.

## Stage evidence
Mirror of `references/pipeline-stages.md` (Stages 1–6); keep the two in sync.
| Stage | Artifact | Observation | Source location |
|---|---|---|---|
| canonical IR | path | instruction kinds / checked flags | compiler/src/ir.xy:4-60, 75-92 |
| optimizer | before/after diff | pass responsible for each change | compiler/src/optimize.xy:213-272 |
| wire | request json | schema/abi/target/backend | compiler/src/ir_json.xy:400-435 |
| LLVM lowering | full_lower dump | helper calls / guards / GEPs | full_lower.rs:5046-5057 (functions) — see references/pipeline-stages.md §Stage 5 |
| LLVM IR | .ll | attributes, intrinsics, vector ops | xylem-rust/crates/xylem-llvm/src/emit.rs:82-103 |
| machine code | objdump | call/branch/vector/spill counts | artifact path |
| behaviour | stats | allocations, checksum, timing | artifact path |

## Attribution
- Semantic (A): required by checked arithmetic / traps / ownership / bounds.
- Runtime (B): boxing, refcount, helper calls, library implementation.
- Optimizer (C): legal transformation not performed.
- Backend (D): instruction selection, ABI, register allocation, layout.
- Hardware (E): bandwidth, latency, cache, predictor.

## Conclusion
- What the code does, where it does it, why, and which layer could legally
  change it. Every claim carries an artifact path or a source file:line.
```

Rules: no claim without an artifact; no "missing optimization" without a
legality check; no performance number without the protocol in
`<workspace>/xylem-benchmarks/research/methodology.md`; all traces are
`PENDING_INDEPENDENT_VERIFICATION` until a second agent reproduces them.
