# Current blockers (verified from execution records)

- **`map_remove` correctness** — nondeterministic repeated remove/reinsert;
  the compiler-side prelude path is `xylem-rust/crates/xylem-compiler/src/loader.rs:498-514`.
  No map-path optimization may be accepted until probe returns 201837219 every run.
- **Equivalence** — 49/86 C↔Rust checksum matches in the benchmark laboratory;
  executing a case is not equivalent work. Establish equivalence before ranking.
- **Compiler scalability** — COMP-002: 1,300 ms at 1k lines, 58,481 ms at 10k
  lines vs Rust 207/836 ms; roughly 45× compile time for 10× source. Known
  O(n²) patterns: `typecheck_if.xy:11-17`, `safety.xy:389-413`,
  `optimize_cse.xy:6-38`, `optimize_hoist_cfg.xy:147-158`.
- **Representation** — boxed `AValue`, refcount traffic and helper calls dominate
  both compiler and generated program time; part of the fix is in `xylem-rust`.
- **Protocol ceilings** — no `checked` bit for vectors or non-trapping
  arithmetic flag in `xylem-bootstrap-ir/1`; proof bits need an ADR and host
  update.
- **LLVM adoption** — correctness regressions and coverage inventory
  inconsistencies remain; use LLVM for release measurement but record the
  identities honestly.

Full details: `docs/development/PERFORMANCE.md` §§10-11,
`docs/development/performance-execution-record.md` §§17-21,
`docs/development/EVIDENCE_LEDGER.md`.

## Protocol and target-aware facts (verified audit)

- The only proof bit in canonical IR is `checked: bool`, meaningful on array
  `Index` (`ir_array.xy:19-27`, `ir_array_json.xy:36-44`) and `VecIndex`
  (`lower_index.xy:59-60`, `ir_place_json.xy:32-36`). All other kinds ignore it.
  `IrInstr` at `ir.xy:75-92` has no spare typed slot for a new fact.
- `request` envelope (`ir_json.xy:400-435`) carries `target` as a **triple string
  only** — no CPU features, vector width, alignment or cache description. It
  never reaches the optimizer: `optimize_program(program, optimization, timing)`
  at `optimize.xy:279` has no target argument.
- `toolchain.toml:23-25` explicitly forbids emitting `arithmetic:"proven"`
  against the pinned host. `VecIndex` proofs are emitted but the host accepts
  and ignores them; `SliceIndex` proofs have no serializer (`ir_slice_json.xy:24-31`).
- `scripts/check-ir-instruction-parity.xy:144-146` gates the instruction inventory:
  new IR kinds require a coordinated host change.
- No cost model exists: only inliner caps (`optimize_inline.xy:30-44`), a
  wall-clock stage budget (`stage_budget.xy:7-11`) and local table caps.
- Dormant aggregate pass insertion points: `optimize_fold_agg.xy` needs re-keying
  to `FoldFacts` (`optimize_fold.xy:5-8`) and calls at `optimize.xy:221,255`.
- `cse_key` (`optimize_cse_table.xy:43-79`) only keys `Unary|Binary|Cast|VecLen`,
  despite ADR-0101 claiming pure-read CSE; cross-block `VecLen` reuse is
  deliberately disabled at `:132`.
- `merge_once` is defined (`optimize_merge.xy:183-239`) but never called.
