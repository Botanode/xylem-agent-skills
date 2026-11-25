# Minimization and regression procedure

1. Freeze a failing artifact set: source, flags, compiler/host hashes, output.
2. Shrink the program by removing statements/functions while re-running the
   exact oracle after each step. For UB-free/differential work, re-check
   validity during reduction (CsmithEdge lesson).
3. Reduce inputs (size, distribution) to the smallest failing case.
4. Determine whether the failure survives with `--opt-level none`; if not, it
   is an optimizer/codegen issue.
5. For wrong output: compare interpreter vs LLVM; use
   `xylem-rust/crates/xylem-llvm/tests/llvm_backend.rs` as the oracle pattern.
6. Land a regression test first (XFAIL/known-bug is acceptable), then the fix;
   remove the TODO after the fix lands.
7. Record identities and reproduction commands in the execution record; never
   claim a fix without an independent verifier reproducing it.
