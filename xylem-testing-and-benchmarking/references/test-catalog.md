# Test gate catalogue

- `check-conformance.xy` — language behavior corpus; known interpreter-only
  `diagnostic-r6006` limitation in self-hosted runs (`--max-steps` unsupported).
- `check-ir-instruction-parity.xy` — all declared self-host IR forms constructible;
  gates new IR kinds (`xylem-lang/compiler/src/ir.xy:4-60`).
- `check-perf-reproducers.xy` — 8 minimal reproducers; currently 6 clean and 2
  expected failures (XFAIL) with IR canaries.
- `check-perf-checklist.xy` — evidence-adjacency integrity; checked items need
  `Evidence: path#section; host: …; date: …`. The implementer never ticks boxes;
  only an independent verifier may.
- `optimizer_equivalence.rs` — 24 deterministic generated programs, pre/post
  optimization interpreter equality.
- `llvm_backend.rs` — interpreter oracle; a bug shared with Cranelift cannot pass.
- `scalar_lowering.rs` — finiteness trap and scalar lowering contracts.

Known blockers: `map_remove` nondeterminism; 49/86 C↔Rust checksum equivalence;
`perf_event_paranoid=4` blocks counters; `opt`/`llvm-dis` absent.
