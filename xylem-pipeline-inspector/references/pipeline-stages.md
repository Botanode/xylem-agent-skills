# Pipeline stage map — source to machine code (file:line anchors; PENDING_INDEPENDENT_VERIFICATION)

This reference is the inspectable map an agent uses to answer "how does this
high-level construct become machine code?" Anchors are a snapshot and were not
independently verified; verify each path in the current tree before relying on
it. Line numbers drift, so backend rows prefer function/symbol names.

## Stage 1 — Source and frontend

| Concern | Location |
|---|---|
| Program parsing / AST | `compiler/src/parser*.xy` |
| Name resolution | `resolver.xy`, `resolver_symbols.xy`, `resolve_*.xy` |
| Type checking | `typecheck*.xy` (hot: `typecheck_expr.xy:51-135`, `typecheck_if.xy:11-17`) |
| Effects / ownership | `effects*.xy`, `ownership*.xy`, `safety.xy:389-413` |
| Driver / stage order | `driver.xy`, `pipeline.xy:55-82` |
| Stdlib / prelude | `stdlib/src/std/*`, `compiler/src/prelude*.xy`, `loader.xy:385-397` |

Command: `xylem check <file>` for diagnostics; `xylem ir <file> --json` for the
canonical IR dump.

## Stage 2 — Canonical IR

| Concern | Location |
|---|---|
| Instruction kinds (55) | `IrInstrKind` at `compiler/src/ir.xy:4-60` (variants `:5-59`; enumerate from source) |
| Instruction record fields | `compiler/src/ir.xy:75-92` (`checked` is one bool) |
| Array `Index` construction | `ir_array.xy:19-27`; wire `ir_array_json.xy:36-44` |
| `VecIndex` construction / proof | `ir.xy:475-482`, `lower_index.xy:59-60`; wire `ir_place_json.xy:32-36` |
| `SliceIndex` (no proof wire) | `ir_slice.xy:31`, `ir_slice_json.xy:24-31` |
| Program / function records | `ir.xy:114-132` |
| Validator | `validate.xy:57-447` (does not re-prove facts) |
| Protocol version | `ir.xy:148-156`, `toolchain.toml:15-20` |
| Request envelope | `ir_json.xy:400-435` (`target` is a triple string only) |

## Stage 3 — Optimizer (20 steps, `optimize.xy:213-272`)

1. `optimize_block` fold — `optimize.xy:215-224`, facts `optimize_fold.xy:5-8`
2. `fold_constants` — `:225`, `optimize_const.xy`
3. `fold_vec_get_options` — `:227`, `optimize_option.xy`
4. `elide_redundant_vec_bounds` — `:228`, `optimize_induction_vec.xy`
5. `specialize_constant_remainders` — `:229`, `optimize_modulus.xy`
6. `merge_blocks` — `:230`, `optimize_merge.xy`
7. `remove_unreachable` — `:232`
8. `propagate_copies` — `:234`, `optimize_copies.xy`
9. `elide_literal_bounds_checks` — `:236`, `optimize_bounds.xy`
10. `elide_repeated_vec_bounds` — `:237`, `optimize_vec_proof.xy`
11. `function_cfg_for` — `:239`, `optimize_hoist_cfg.xy:148-214` (flat dominator matrix)
12. `elide_induction_bounds_checks_with_cfg` — `:240`, `optimize_induction.xy`
13. `eliminate_common_subexpressions` — `:242`, `optimize_cse*.xy` (keys only `Unary|Binary|Cast|VecLen`)
14. (non-`size`) LICM + inner-loop memoization + second fold — `:244-258`, `optimize_hoist.xy`, `optimize_fold.xy`
15. `propagate_copies` again — `:264`
16. `fold_single_use_load_copies` — `:266`
17. `fold_constants` again — `:267`
18. `merge_blocks` again — `:268`
19. `remove_unreachable` again — `:269`
20. `prune_function` — `:270`

Dormant/backlog: `optimize_fold_agg.xy` (unimported; needs re-keying to
`FoldFacts`), `optimize_merge.xy:183-239` `merge_once` (never called),
pure-read CSE specified in ADR-0101 but not implemented.

Proof facts (what can be cleared): literal index (`optimize_bounds.xy:86-99`),
canonical induction (`optimize_induction.xy:47-116`), repeated access
(`optimize_vec_proof.xy:124-189`), structural `<` guard
(`optimize_induction_vec.xy:36-122`), positive modulus
(`optimize_modulus.xy:169-197`). No interval/range analysis, no alignment,
trip-count or vector-width fact reaches the backend.

## Stage 4 — Wire / host

- `cli_run.xy:42-60` builds and writes the request, spawns the pinned host.
- `xylem-rust/crates/xylem-backend-host/src/lib.rs:41-57` selects backend; `:431-441` builds.
- `cli_run.xy:42-62` builds and writes the request (`:42-60`) and spawns the
  pinned host (`:62`).
- `xylem-backend-host/src/lib.rs:41-57` selects backend; `:431-441` builds.
  It revalidates canonical IR independently.
- `toolchain.toml:15-20`: protocol pins; `arithmetic:"proven"` accepted by
  decision but **not parsed** by the pinned host — do not emit.

## Stage 5 — LLVM backend (`xylem-rust/crates/xylem-llvm/src/`)

| Concern | Location |
|---|---|
| Toolchain / clang resolution | `toolchain.rs:15-19,45-71` |
| clang invocation (only `--target` is target-specific) | `emit.rs:82-103` |
| Optimization mapping `-O0/-O2/-Os` | `optimize.rs:14-19` |
| Scalar lowering | `lower.rs:610-637` (module header), `:745-752` (functions) |
| Full-value (production) lowering | `full_lower.rs`: `lower_program` at `:129`, `lower_function` at `:5996` |
| Helper attributes / program setup | `full_lower.rs:135-169` (inside `lower_program`) |
| Unboxed scalar slots / cells | `full_lower.rs` `fn cell` at `:733` (not `:303-335`, `:476-519` or `:5103-5108`, which are task-thunk, byte-at and vector-bounds code) |
| Native checked arithmetic | `full_lower.rs`: `llvm.*.with.overflow.i64` at `:1445`, `native_float_binary` at `:1527` |
| Raw intrinsics / strings / hash | `full_lower.rs` `lower_raw_intrinsic` at `:1294` |
| Vec element addressing (inttoptr + shl/add) | `full_lower.rs`: `shl`/`inttoptr` at `:669-681`, `:2391`, `:2975` |
| Native aggregate GEPs | `full_lower.rs`: `getelementptr` at `:434,519,1060,2395,2641,2693,2892` |
| Bounds guard / dual pass | `full_lower.rs`: `vector_bounds_plan` at `:5077`, `native_vec_target_plan` at `:5234` |
| Float path (boxed, helper) | `full_lower.rs`: boxed helper `xylem_rt_a_float` at `:1168`, `:3294` |
| Multiversioning / target features | **absent from backend source** (no matches in `crates/xylem-llvm`/`xylem-backend-host/src`; the terms occur only in docs) |
| PGO / ThinLTO | absent from the canonical backend source snapshot; only `-flto` at `emit.rs:92` (a worktree defines `-flto=thin` — re-check before relying) |

## Stage 6 — Machine code and measurement

Commands (record every output):

```sh
xylem build <file> --release --backend llvm --opt-level speed -o /tmp/t
xylem ir <file> --json > /tmp/t.ir.json
clang -S -emit-llvm -O2 /tmp/runtime.c -o /tmp/t.ll      # when inspecting runtime
objdump -d /tmp/t > /tmp/t.s
grep -c 'call' /tmp/t.s
XYLEM_MEMORY_STATS=1 /tmp/t
```

Interpretation checklist: allocator/refcount helper calls → representation;
per-element bounds branches → missing proof; indirect calls → missed
devirtualization; stack traffic → failed SROA; no vector registers → no
vectorization (check whether legal first); L1/L2/TLB costs → hardware, not
compiler. See `docs/investigation-handbook.md` in the benchmark laboratory.
