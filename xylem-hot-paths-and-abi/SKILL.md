---
name: xylem-hot-paths-and-abi
description: Trace high-frequency Xylem operations through representation, ABI, runtime calls and generated machine code. Use when a hot path is slower than expected, when runtime helper calls or allocations are suspected, or when deciding whether an overhead belongs in the application, stdlib, runtime or compiler.
---

# Hot paths and ABI

The goal is a verified chain: Xylem operation → compiler representation →
lowering path → generated operations → runtime calls → performance cost. Do not
populate it with hypothetical operations; inspect the compiler.

## The actual ABI (source-traced, not independently verified)

All claims in this section are `PENDING_INDEPENDENT_VERIFICATION` until an
independent verifier reproduces them.

- **[Cranelift, dev]** Every generated function takes I64 parameters and at most
  one I64 result; the hidden runtime pointer is the first parameter
  (`xylem-rust/crates/xylem-native/src/cranelift_full.rs:7043-7057`).
- **[LLVM, release]** LLVM emits `ptr %runtime` first, then `i64 %argN`, and
  returns `i64`/`void` (`xylem-rust/crates/xylem-llvm/src/full_lower.rs:6294-6298`).
  Do not transfer the all-I64 Cranelift claim to LLVM.
- `repr_plan` demotes **call arguments and return values only**; aggregate and
  store boundaries are deliberately left to per-temporary plans
  (`xylem-rust/crates/xylem-llvm/src/repr.rs:158-193`).
- Direct calls to scalar-only functions skip boxing
  (`xylem-rust/crates/xylem-native/src/cranelift_full.rs:1616-1669`; historical
  dev diagnostic: fib -57% after unboxed direct calls). Exported/task/dynamic
  calls box at the boundary (same range).
- C export wrapper creates a runtime, boxes args, unboxes result
  (`xylem-rust/crates/xylem-native/src/cranelift_full.rs:7202-7277`).

## Hot-path mechanisms (source-traced, not independently verified)

Cranelift numbers are development diagnostics and are not release performance
(`AGENTS.md:8`); all figures below are historical and
`PENDING_INDEPENDENT_VERIFICATION`.

- **Cells**: managed temporaries use a 64-cell inline frame arena (RT:71-88,
  2105-2134); `cell_get_fast`/`cell_set_fast` inline a load + tag test with
  helper fallback
  (`xylem-rust/crates/xylem-native/src/cranelift_full.rs:5351-5420`). Historical
  dev diagnostic: inline cell paths cut `a_cell_set` 10,479,268 → 4,380 and
  `a_cell_get` 3,921,734 → 19.
- **References**: tagged direct refs avoid allocation (RT:1032-1065); heap/path
  refs allocate `A_REF` nodes (RT:3422-3497).
- **Scalar arithmetic**: inline overflow-guarded ops with cold helpers
  (CF:3023-3189); floats inline with exponent trap test (CF:2891-2948).
- **Hash/index path**: 2 of ~3 allocations per `map_get` come from
  `__key_hash` + cast/modulo/index boxing; experimental raw-scalar patch cut
  3.15 → 0.03 allocations with checksum parity
  (`tests/perf/README.md:770-790`).
- **Trap sites**: lazy publication cut `set_trap` calls 31,343,357 → 4,228
  (archived runtime profile :546-594).

## Decision guide

1. Inspect the IR for the construct (`xylem ir --json` + pipeline-inspector).
2. Count calls and allocations in assembly (`objdump -d`) and with
   `XYLEM_MEMORY_STATS=1`.
3. Ask: is the helper semantically required (trap/bounds/drop) or an
   implementation artifact (cell boxing, refcount, path node, hash boxing)?
4. If source can avoid the overhead without semantic change, apply the smallest
   fix; otherwise record a compiler/runtime improvement with file:line.
5. Never normalize severe compiler overhead as an unavoidable language feature.
6. Hard constraints (`AGENTS.md:70,85`): never remove a helper that implements
   checked arithmetic, a finite-float trap, a bounds check, ownership/drop,
   trap-site publication, or a diagnostic location. Treat the `map_remove`
   ownership bug (`AGENTS.md:44-49`) as an active blocker before proposing any
   refcount or path-node removal.

## Evidence snapshot (diagnostic, historical)

`map-flat` Callgrind (`docs/development/performance-execution-record.md:1346-1363`):
109,966,288 IR vs Rust 1,873,600 / C 886,770; the same record also reports
109,968,292 at `:2583`/`:2741`/`:2745` — this conflict is unresolved, so do not
silently pick one. Dominant helpers `read_ref` 11.05%,
`a_ref_append_segment` 8.95%, `a_vec_index` 6.93%, `a_free_value` ~10.7%,
`a_cell_set` 5.55%, `a_allocate_uninit` ~9.5%, `a_int_kind` 4.74%.
All figures PENDING_INDEPENDENT_VERIFICATION; re-measure current compiler.

## References

- `references/abi-map.md` — ABI and helper-call map with source lines.
- `references/compiler-vs-source.md` — deciding ownership of a cost.
