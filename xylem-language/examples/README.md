# Validated Xylem examples

These programs are copied from the benchmark laboratory where they were built
and executed with the local compiler (xylem-rust `target/release/xylem`,
`--backend llvm --release --opt-level speed`, 2026-11-22). They use a `CASE`
selector constant (edit `const CASE` to choose a case) and print a checksum.
Re-validate against your compiler revision before relying on them.

Additional authoritative examples live in `xylem-lang/conformance/cases/`,
`xylem-lang/examples/`, `tests/perf/reproducers/` and `tests/torture/cases/`.
