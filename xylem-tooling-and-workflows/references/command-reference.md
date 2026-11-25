# Verified command reference (source locations)

CLI surface (xylem-rust): `crates/xylem-cli/src/main.rs` — command dispatch
`:108-146`, usage text `:169-213`, `build` flags `:2910-3010`, `--target`
`:2990-2996`. Xylem-written CLI: `xylem-lang/compiler/src/driver.xy:42`
(usage), `:247-329` (dispatch); it rejects Rust-only commands (`eval`, `repl`,
`debug`, `coverage`, `profile`, `resources`, `replay`, `web`).

Driver surface (xylem-lang): `compiler/src/cli.xy` and `cli_*.xy`; build request
construction in `compiler/src/cli_run.xy:42-60`, target parsing in `driver.xy:45,72-75,161-167`.

## Flag semantics verified in source

- `--release` sets `"profile":"release"` in the request (`cli_run.xy`).
- `--opt-level speed` maps to LLVM `-O2` (`crates/xylem-llvm/src/optimize.rs:14-19`).
- `--backend llvm` selects the production backend; absent backend defaults to
  Cranelift for compatibility (`xylem-backend-host/src/lib.rs:43-49`).
- `--target` is a triple string in the request envelope (`ir_json.xy:400-435`).
  Cross-target executables are rejected (`crates/xylem-llvm/src/lib.rs:265-273`).
- `--json` emits machine-readable diagnostics/report where supported.

## Toolchain pins

- `xylem-lang/toolchain.toml`: compiler `7082acd9…`, backend host `2e2d75fb…`;
  IR `xylem-bootstrap-ir/1`, ABI `xylem-native/16`. Protocol comment forbids
  emitting `arithmetic:"proven"` until the host pin changes.
- `xylem-rust/llvm.toml`: LLVM 21.1.8 pinned, minimum 21.1, driver `clang`,
  override `XYLEM_CLANG`; host executables and host/cross objects supported.
- `xylem-rust/rust-toolchain.toml`: **channel `stable`**, components rustfmt
  and clippy. Do not assume nightly; `opt`/`llvm-dis` are also absent here.

## Known limitations

- `scripts/check.sh` can stop at the interpreter-only `diagnostic-r6006` case
  (self-hosted `run` lacks `--max-steps`); record it, do not call it a pass.
- `perf_event_paranoid=4` on this host blocks hardware counters; use allocation
  counters, instruction counts from instrumentation, and `objdump`.
- `opt` and `llvm-dis` are not installed here; LLVM IR verification must be
  recorded as unrun if those tools are unavailable.
- Stage-2/3 gates are opt-in and take tens of minutes (`check-selfhost.sh`).
