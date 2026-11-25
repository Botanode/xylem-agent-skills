# Deciding who owns a cost

Every claim here is `PENDING_INDEPENDENT_VERIFICATION` until an agent re-derives
it from the cited lines (AGENTS.md verification rule). Paths are
workspace-relative and resolved in [Citations](#citations); numeric magnitudes
carry their artifact identity inline.

| Observation | Likely owner | Evidence needed |
|---|---|---|
| Helper call for overflow/range/bounds/drop | Semantic + backend | IR trap site plus R6001/2/4/5, reverse-declaration-order drops and caret preserved (`xylem-rust/crates/xylem-llvm/src/full_lower.rs:1708-1712`, `xylem-lang/docs/decisions/README.md:10254`). A proved access with `checked:false` may be removed with no behavior change — distinguish trap semantics from `set_trap` publication. |
| Cell boxing at a call boundary | Compiler/runtime — LLVM `repr_plan` demotion (`xylem-rust/crates/xylem-llvm/src/repr.rs:163-191`); Cranelift scalar-call ABI (`xylem-rust/crates/xylem-native/src/cranelift_full.rs:1620`). `analyse_temps` is dev-only *promotion* that refuses parameters (`xylem-rust/crates/xylem-native/src/cranelift_full.rs:1004`, `xylem-rust/crates/xylem-native/src/cranelift_full.rs:1069-1072`), not a boxer. | IR shows a non-scalar arg/return; `repr_plan[temp] == Managed`; confirm callee is scalar-only. |
| Refcount increments on shared container | Runtime semantics + optimization opportunity | `a_refs_increment` / `a_refs_decrement` (`xylem-rust/crates/xylem-native/src/cranelift_runtime.c:1218-1235`) plus `copy_value` (`xylem-rust/crates/xylem-native/src/cranelift_runtime.c:1924-1928`) census; `a_unshare` (`xylem-rust/crates/xylem-native/src/cranelift_runtime.c:1935-1945`) is only the COW gate — a fresh value already has a refcount above one. Allocation count ≠ RC count. |
| `A_REF` path node per field borrow | Backend lowering — multi-segment / non-inline / fallback borrows only | `borrow-place` (`xylem-lang/compiler/src/ir_text.xy:150-151`, `xylem-lang/compiler/src/ir.xy:34`); `a_ref_append_segment` (`xylem-rust/crates/xylem-native/src/cranelift_runtime.c:3393-3411`) allocates, but simple field borrows use `a_ref_field_direct` (`xylem-rust/crates/xylem-native/src/cranelift_runtime.c:3488-3506`) / `xylem_rt_a_ref_field_read_direct` (`xylem-rust/crates/xylem-native/src/cranelift_runtime.c:11859`) on both backends (`xylem-rust/crates/xylem-llvm/src/full_lower.rs:2431-2449`), no path node. |
| Hash/index boxing per map lookup | Runtime representation | `PENDING_INDEPENDENT_VERIFICATION`: 3 allocations/lookup is a dated diagnostic (`xylem-lang/tests/perf/README.md:770-790`, compiler SHA `cd5d4415…`, host SHA `ff7b7018…`, experimental tree; patch `xylem-lang/docs/development/patches/llvm-raw-key-hash.patch`). Re-measure on pinned release. |
| Loop-invariant bounds branch | Optimizer — narrow induction/vector bounds only; no general range pass (`xylem-lang/compiler/src/optimize_induction.xy:7-11`, `xylem-lang/compiler/src/optimize_induction.xy:47-116`; O03 proposal) | IR `checked` bit before/after; R6004 trap still at original caret. |
| No vector instructions | Optimizer/backend + semantics | vectorizer remarks if available; legality check (no fast-math) per `xylem-rust/AGENTS.md:13`. |
| Random access slower than sequential | Hardware/data layout | counters/model; same shape across languages (`xylem-lang/docs/development/PERFORMANCE.md:7`). |

Rule: application changes are valid only when they preserve the required
semantics and remove a demonstrable source-level cause. If the cause is a
representation/lowering decision, write a compiler improvement proposal with
file:line and evidence instead of contorting source code.

### Citations

- Representation / call boundary: `repr_plan` → `xylem-rust/crates/xylem-llvm/src/repr.rs:163-191`; Cranelift scalar-call ABI → `xylem-rust/crates/xylem-native/src/cranelift_full.rs:1620`; `analyse_temps` promotion and parameter refusal → `xylem-rust/crates/xylem-native/src/cranelift_full.rs:1004` and `xylem-rust/crates/xylem-native/src/cranelift_full.rs:1069-1072`.
- Refcount / COW: `a_refs_increment` and `a_refs_decrement` → `xylem-rust/crates/xylem-native/src/cranelift_runtime.c:1218-1235`; `copy_value` → `xylem-rust/crates/xylem-native/src/cranelift_runtime.c:1924-1928`; `a_unshare` → `xylem-rust/crates/xylem-native/src/cranelift_runtime.c:1935-1945`.
- Borrow path: `a_ref_append_segment` → `xylem-rust/crates/xylem-native/src/cranelift_runtime.c:3393-3411`; `a_ref_field_direct` → `xylem-rust/crates/xylem-native/src/cranelift_runtime.c:3488-3506`; `xylem_rt_a_ref_field_read_direct` → `xylem-rust/crates/xylem-native/src/cranelift_runtime.c:11859`; LLVM direct helpers → `xylem-rust/crates/xylem-llvm/src/full_lower.rs:2431-2449`; opcode `borrow-place` → `xylem-lang/compiler/src/ir_text.xy:150-151` and `xylem-lang/compiler/src/ir.xy:34`.
- Bounds / trap: ADR-0103 trap-site rule → `xylem-lang/docs/decisions/README.md:10254`; LLVM unchecked-access site → `xylem-rust/crates/xylem-llvm/src/full_lower.rs:1708-1712`.
- Bounds proof: canonical induction matcher → `xylem-lang/compiler/src/optimize_induction.xy:7-11` and `xylem-lang/compiler/src/optimize_induction.xy:47-116`.
- Allocation diagnostic and patch: `xylem-lang/tests/perf/README.md:770-790`; `xylem-lang/docs/development/patches/llvm-raw-key-hash.patch`.
- Legality / provenance: `xylem-rust/AGENTS.md:13`; `xylem-lang/docs/development/PERFORMANCE.md:7`.

Run `python3 scripts/check-skill-citations.py` from the repository root after
editing this table; every row must cite a resolvable path:line and every
magnitude must carry an artifact identity plus the PENDING tag.
