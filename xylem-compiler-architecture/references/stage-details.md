# Extended stage details

Canonical IR instruction inventory: `IrInstrKind` at `compiler/src/ir.xy:4-60`
(variants occupy `:5-59`; enumerate them from source — do not cache a literal
count, which has drifted). `IrInstr` fields at `:75-92`; `checked` meaningful on array `Index` and
`VecIndex` only. Program/function records `:114-132`.

Optimizer 20 steps (`optimize.xy:213-272`): block fold, const fold, vec option
fold, induction bounds, constant remainder, merge, unreachable, copies, literal
bounds, repeated vec bounds, CFG, induction bounds CFG, CSE, LICM+memo+refold,
copies, single-use load folds, const fold, merge, unreachable, prune. Timing
slots at `:294-308`. `optimize_program` at `:279-311` skips all for none/0.

Backend lowering in Rust: `xylem-llvm/src/lib.rs:203-215` selects scalar vs
full path; `full_lower.rs` owns managed cells, fast paths, native aggregates;
`lower.rs` scalar path. `emit.rs:82-103` invokes clang with `-O0/-O2/-Os`,
`-flto`, `--target`. Protocol pins `toolchain.toml:15-20` (`:19-20`); the
`arithmetic:"proven"` ban comment is at `:16-18`.

Frontend hot scans (compiler throughput blocker): `typecheck_if.xy:11-17`
(whole-function scan per if), `safety.xy:409-413+` (256-bucket binding scan),
`typecheck_expr.xy:51-135`,
`optimize_cse.xy:6-38` (O(B²) ordering), `optimize_hoist_cfg.xy:147-158`
(dense dominator matrix), `lexer.xy:295` (source copy), quadratic `concat` in
`ir_json.xy`. Self-build measured ~45× compile time for 10× source (COMP-002).
