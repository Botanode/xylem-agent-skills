---
name: xylem-testing-and-benchmarking
description: Add and run Xylem correctness tests, compiler regressions, differential checks and fair performance benchmarks. Use when writing a language test, a diagnostic test, a backend regression, a benchmark, comparing Xylem with Rust or C, verifying benchmark work is not optimized away, or recording reproducible methodology.
---

# Xylem testing and benchmarking

Correctness gates performance. A performance number from a build that fails a
correctness check is void. All speed claims require equivalent workloads,
matching checksums, exact toolchain identities and an independent verifier.

## Test layers and where they live

| Layer | Location | Add by |
|---|---|---|
| Conformance cases | `xylem-lang/conformance/cases/`, `manifest.json`, `case-ids.txt` | new `.xy` case + manifest entry + regenerate coverage |
| Compiler tests | `xylem-lang/compiler/tests/`, `tests/` | `.xy` test with expected stdout/diagnostic |
| Reproducers | `xylem-lang/tests/perf/reproducers/` | <30-line `.xy` with checksum and IR contract |
| Runtime/compiler unit | `xylem-rust/crates/*/tests/*.rs` (178 files) | Rust test in the owning crate |
| Optimizer equivalence | `crates/xylem-compiler/tests/optimizer_equivalence.rs` | generator-driven pre/post optimization equality |
| Backend differential | `crates/xylem-llvm/tests/llvm_backend.rs`, `scalar_lowering.rs` | interpreter as independent oracle |
| Benchmarks | `xylem-lang/tests/perf/` and workspace `xylem-benchmarks/` | registry entry + fixed seed + oracle |

## Commands

```sh
# correctness
./scripts/run-xy.sh scripts/check-conformance.xy
./scripts/run-xy.sh scripts/check-perf-reproducers.xy
cargo test --workspace
cargo test -p xylem-compiler --test optimizer_equivalence
cargo test -p xylem-llvm --test llvm_backend

# benchmark (release backend only)
xylem build <file> --release --backend llvm --opt-level speed -o /tmp/prog
XYLEM_MEMORY_STATS=1 /tmp/prog
```

## Adding a language test

1. Write the smallest `.xy` program with a deterministic `print(checksum)`.
2. Validate it compiles and runs under both `xylem run` and the LLVM release build.
3. For diagnostics, add the expected code/span to the conformance case and
   update `manifest.json`/`case-ids.txt`; regenerate `conformance/coverage.md`.
4. Run the conformance gate; record compiler/host identities.

## Adding a performance benchmark

1. Equivalent algorithm, input and checksum across Xylem/Rust/C.
2. Mode A (equivalent semantics) or Mode B (idiomatic) — label it.
3. Seed and input size fixed; setup excluded from timed region.
4. Anti-elision: checksum written once after the loop; empty-body control.
5. At least 3 samples, median reported, warmup recorded, exact hashes.
6. Validate checksums match before comparing timings. The lab currently has
   only 49/86 C↔Rust matches — the other 37 are void.

## Fair cross-language comparison

- Same optimization class: Xylem `--release --backend llvm`, Rust `-O3`,
  C `-O2`/`-O3` (report which).
- Same algorithm and output; document any semantic difference (checked
  arithmetic, finite floats, bounds, allocation scope, hash seed).
- Never compare Xylem debug with Rust release; never remove required work;
  never report a noisy single run as a speedup.
- Report distribution (median, min/max, CI), allocation counts and artifact
  identities. See `xylem-benchmarks/research/methodology.md`.

## Regression guards

Every performance change adds a guard encoding the current result with slack:
fixed-checksum workload, IR canary, or timing baseline at the harness's 10%
threshold. A guard failure means re-measure and investigate — not re-tick.

## References

- `references/test-catalog.md` — what each gate proves and known blockers.
- `references/benchmark-protocol.md` — measurement/threshold details.
