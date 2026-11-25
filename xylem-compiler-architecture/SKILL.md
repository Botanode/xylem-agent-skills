---
name: xylem-compiler-architecture
description: Navigate and safely modify the Xylem compiler — stage order, frontend, IR, optimizer, lowering, backend selection, runtime integration, diagnostics and tests. Use when locating the stage responsible for a behavior, adding a pass or intrinsic, fixing a lowering/backend bug, or investigating a compiler crash.
---

# Compiler architecture

Two implementations: the Xylem-written compiler (`xylem-lang/compiler/src/*.xy`)
is authoritative for semantics; the Rust compiler (`xylem-rust/crates/`) is the
independent implementation and shared backend host. LLVM is the release
backend, Cranelift development-only. Do not introduce a second IR/backend.

## Stage map (file:line anchors; PENDING_INDEPENDENT_VERIFICATION)

Anchors were re-derived from the current tree but not independently verified;
re-check each path and line before relying on it.

| Stage | Location |
|---|---|
| CLI/driver | `compiler/src/cli*.xy`, `driver.xy:250-335` (`run()`); Rust `xylem-cli/src/main.rs:108-146` |
| Lexer/parser | `lexer*.xy`, `parser*.xy`, `parser_expr.xy:7-53` (op table) |
| Names/types/effects/ownership | `resolver*.xy`, `typecheck*.xy`, `effects*.xy`, `ownership.xy`, `safety.xy:388-413` (struct-field type + bucket scan at `:409-413+`) |
| Canonical IR | `ir.xy:4-132` (see `IrInstrKind` at `:4-60` — enumerate variants from source, do not cache a literal; one `checked` bool in `IrInstr` at `:75-92`); wire `ir_json.xy:27-158,400-435` |
| Validation | `validate.xy:57-447`, `validate_*.xy` |
| Optimizer | `optimize.xy:213-272` (20 steps), `optimize_*.xy`; dormant `optimize_fold_agg.xy` |
| Lowering | `lower*.xy` (75 in `compiler/src`, 33 seed modules); Rust `crates/xylem-compiler/src/lowering.rs` |
| Backend | Rust `xylem-llvm/src/` (release), `xylem-native/src/cranelift_full.rs` (dev) |
| Runtime | Rust `xylem-rust/crates/xylem-native/src/cranelift_runtime.c`: AValue/cells/refcount/traps |
| Request/host | `cli_run.xy:42-60` → `xylem-backend-host/src/lib.rs:41-57,431-441` |
| Diagnostics | `compiler/src/diag*.xy`; Rust `xylem-diagnostics/src/lib.rs:14-110` |

## Dependency direction (xylem-rust)

source/diagnostics → lexer/ast/parser → resolver/types/effects/ownership →
ir/validation/passes → compiler/codegen/native → toolchain/cli → backend-host.
Lower layers never import orchestration/presentation layers.

## Protocol constraints

- `xylem-bootstrap-ir/1` and `xylem-native/16` are pinned in the `[protocol]`
  section at `toolchain.toml:15-20` (`:19-20`); the ban on emitting
  `arithmetic:"proven"` until the host parser changes is at `:16-18`.
  `toolchain.toml:22-25` is the unrelated `[revisions]` hash block.
- `scripts/check-ir-instruction-parity.xy:135-215` is a post-hoc set-consistency
  check: declared vs constructed at `:166-184`, Rust oracle at `:185-213`
  (opt-in `--oracle`). It does not block a kind added consistently to both
  enums and one construction site; new IR kinds need coordinated self-host and
  host changes.
- ADRs in `docs/decisions/README.md` govern semantic changes. ADR-0099…0103
  are canonical-IR / optimizer / proof decisions (ids are not in numeric file
  order), **not backend decisions**; ADR-0103 covers `VecIndex.checked:false`.

## Safe workflows

- **Add a pass**: insert into `optimize.xy:213-272` at the correct phase; respect
  fact invalidation; update timing slots `:294-308`; add an IR canary.
- **Add an intrinsic**: register in `crates/xylem-types/src/lib.rs:41-175`,
  type-check in `crates/xylem-types/src/checker/intrinsics.rs:116-141,146-307`
  (`__key_hash`, `check_vector_intrinsic`), lower in
  `crates/xylem-compiler/src/lowering.rs:2667-2749`, mirror in self-hosted
  `prelude_host.xy:6-43`, `lower_prelude.xy:32-82`.
- **Fix lowering/backend**: use `xylem-pipeline-inspector` to locate the stage,
  reproduce with a minimal program, add differential test in
  `xylem-llvm/tests/llvm_backend.rs` or `scalar_lowering.rs`.
- **Add runtime operation**: implement in
  `xylem-rust/crates/xylem-native/src/cranelift_runtime.c` with trap semantics,
  declare in helper table, validate with allocation counters.
- **Compiler crash**: minimize; `xylem check --json`; `XYLEM_OPT_BISECT_LIMIT=N`
  to bisect passes (Rust host `xylem-compiler/src/lib.rs:150-168`, not the
  self-hosted compiler); `xylem ir --json`; check IR parity gate.
- **Wrong output**: interpreter vs `--backend llvm --release` differential;
  `optimizer_equivalence.rs`; `llvm_backend.rs` oracle.

## References

- `references/stage-details.md` — extended stage map and owner files.
- `references/change-procedures.md` — step-by-step procedures.
