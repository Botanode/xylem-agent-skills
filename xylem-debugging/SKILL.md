---
name: xylem-debugging
description: Systematically debug Xylem programs and the Xylem compiler — syntax/type errors, unsupported features, compiler crashes, runtime traps, wrong output, backend inconsistencies, optimization-dependent failures, linking and performance anomalies. Use when something fails or behaves unexpectedly and the responsible stage is not yet known.
---

# Xylem debugging

Reproduce, minimize, then locate the stage, then change code. Randomly editing
the compiler is not debugging.

## Failure categories and first actions

| Symptom | First action |
|---|---|
| Syntax/lex error | `xylem check <file> --json`; read code/span; compare with grammar |
| Type/ownership error | check `docs/language/contract.md`; confirm with a minimal case |
| Unsupported feature | search compiler/src for the construct; record as UNKNOWN/PLANNED, do not invent a workaround |
| Compiler crash / ICE | minimize source; from the `xylem-rust` root run `cargo test -p xylem-compiler --test optimizer_equivalence`; check IR parity gate |
| Runtime trap R6001/2/3/4/5/6/7 | R6006 = step budget exhausted; R6007 = call-depth limit; identify the semantic guard, verify the input triggers it, check the trap location |
| Wrong output | compare interpreter vs LLVM; if they differ, backend/lowering bug; if both differ, check host, prelude mirror, oracle/checksum and harness before blaming frontend/IR |
| Optimization-dependent failure | run with `--opt-level none` vs `speed`; use `xylem-rust/crates/xylem-compiler/tests/optimizer_equivalence.rs` as oracle |
| Backend inconsistency | `xylem-rust/crates/xylem-llvm/tests/llvm_backend.rs` uses the interpreter as oracle; check both backends' output |
| Link failure | check backend host identity, target triple, `-L`/`-l`, C runtime |
| Performance anomaly | see `xylem-performance-analysis` skill |

## Workflow

1. **Reproduce** with exact compiler/host hashes, flags, seed and input.
2. **Minimize** the program while preserving the failure; re-check the failure
   after every reduction step (a reduction can change the bug).
3. **Classify**: language error, unsupported feature, or compiler defect.
4. **Locate the stage**: IR dump (`xylem ir <file> --json`) →
   `./scripts/run-xy.sh scripts/check-conformance.xy` →
   `./scripts/run-xy.sh scripts/check-ir-instruction-parity.xy` →
   `cargo test -p xylem-compiler --test optimizer_equivalence` (from the
   `xylem-rust` root) → `xylem-rust/crates/xylem-llvm/tests/llvm_backend.rs`.
5. **Inspect artifacts**: before/after IR, runtime helper census, assembly.
6. **Fix the smallest cause**; add a regression test (possibly XFAIL first).
7. **Verify** all affected gates and record identities.

## Common diagnostic codes (not exhaustive)

- E1001 lexical, E1003 non-finite float literal, E1004 unterminated comment,
  E1101 syntax, E2001 name resolution, E3001/3002 type/mutability, E3101
  moved value, E3107 mutable borrow of immutable binding, E4001 effects,
  E5001/5004 internal validation, E5005 use-after-move.
  ~90 `E####` codes are emitted from `compiler/src`; confirm the exact code and
  span with `xylem check <file> --json` (`references/trap-codes.md`).
- R6001 divide/rem by zero, R6002 arithmetic overflow / non-finite float,
  R6003 general trap, R6004 out of bounds, R6005 moved value at runtime,
  R6006 step-budget exhausted (`--max-steps` interpreter limit), R6007
  call-depth limit (512 frames). Manifest-backed at
  `conformance/manifest.json:1644-1677`; see `tests/torture/README.md:223`.

Traps are semantic guarantees: never remove one to make a test pass.

## Known pitfalls

- Interpreter-only traps (`diagnostic-r6006`, `diagnostic-r6007`) are handled by
  the conformance harness: `scripts/check-conformance.xy` passes `--max-steps`
  from the manifest (`scripts/check-conformance.xy:357-361`) and accepts
  `backend: "interpreter"` cases (`:372-375`). Do not count them as native
  parity.
- `map_remove` is nondeterministic on repeated remove/reinsert (execution record
  §18.1); do not use it as an oracle until fixed.
- `perf_event_paranoid=4` blocks counters; use assembly/allocation counters.

## References

- `references/trap-codes.md` — trap/diagnostic catalogue with source locations.
- `references/minimization.md` — minimization and regression procedure.
