# Environment variables (verified)

Read from the compiler/runtime source, not guessed:

| Variable | Purpose | Where read |
|---|---|---|
| `XYLEM_BOOTSTRAP` | pinned compiler binary | driver, stage harnesses, benchmark lab |
| `XYLEM_BACKEND_HOST` | canonical-IR backend host | driver, stage harnesses |
| `XYLEM_STDLIB_ROOT` | path to canonical stdlib sources | compiler driver / loader |
| `XYLEM_CLANG` | LLVM driver override | `crates/xylem-llvm/src/toolchain.rs:19,43-71` |
| `XYLEM_MEMORY_STATS=1` | print allocation/peak-live stats | native runtime |
| `XYLEM_RUNTIME_COUNTERS=1` | LLVM runtime helper counters | LLVM runtime path |
| `XYLEM_STAGE_BUDGET_MS` | per-stage wall-clock budget (default 30,000) | `xylem-rust/crates/xylem-compiler/src/lib.rs:47-49`, `compiler/src/stage_budget.xy:7-13` |
| `XYLEM_OPT_BISECT_LIMIT=N` | run only first N optimizer passes to isolate a miscompile | `xylem-compiler/src/lib.rs:150-168` → `PassSelection::first(N)` |
| `XYLEM_REPLAY_MODE/FILE`, `XYLEM_CAPABILITY_ROOT` | replay record/run and scoped I/O | `xylem-cli/src/main.rs:1724-1729`, `xylem-codegen/src/lib.rs:1388+` |
| `XYLEM_KEEP_DEBUG_ARTIFACTS=1` | retain temporary native build artifacts | `xylem-native/src/lib.rs:3655` |
| `XYLEM_ZIG`, `XYLEM_QEMU_AARCH64`, `XYLEM_AARCH64_SYSROOT` | cross-link/execution hooks | `xylem-native/src/lib.rs:288`, `tests/cross_target_execution.rs:123-126` |
| Gate switches | `XYLEM_PARITY_GATE`, `XYLEM_PARITY_REQUIRE_PINNED`, `XYLEM_CACHE_DIFFERENTIAL`, `XYLEM_PERF_REPRODUCERS`, `XYLEM_PERF_EQUIVALENCE`, `XYLEM_SELFHOST`, `XYLEM_SELFHOST_BIN_DIR` | `xylem-lang/scripts/check.sh:28-72` |
| Stage gate switch | `SELFHOST_STAGE_GATE` | `xylem-lang/scripts/check-selfhost.sh:16,30,96`, `xylem-lang/scripts/check-phase17-exit.xy:272,795` |
| `XYLEM_ALLOCATION_TRACE` | trace allocation events | native runtime |
| `XYLEM_FORCE_VARIANT` | (future) CPU variant override — not implemented | none |

Do not use `XYLEM_FORCE_VARIANT` yet: no dispatch mechanism exists in the tree.
`XYLEM_STAGE_BUDGET_MS` in `scripts/check-selfhost.sh:81` has a separate
1,800,000 ms override for the heavy stage harness; the compiler default is
30,000 ms. The cited `scripts/compiler-oracle/pass_bisect.py` does not exist —
drive `XYLEM_OPT_BISECT_LIMIT` manually.
Do not assume a variable is read just because it appears in documentation —
verify with `grep -rn` in the current repository before relying on it.

## Running from the workspace

The three repositories are siblings under `/home/philip/Development/version_2`.
Set `XYLEM_STDLIB_ROOT` to the canonical stdlib of the *language* repository,
even when the compiler binary comes from `xylem-rust`.
