# Authoritative measurement records (re-check before use)

- `xylem-lang/docs/development/PERFORMANCE.md` — canonical root-cause record.
- `performance-execution-record.md` §§17-21 — measured optimization gains and blockers.
- `EVIDENCE_LEDGER.md` — evidence entries, all PENDING_INDEPENDENT_VERIFICATION.
- `xylem-benchmarks/reports/EXECUTION_REPORT.md` and `reports/run-2026-11-22/` —
  86 C/Rust/Xylem cases, 49 matches, 12 torture cases, 6 compiler builds.
- `tests/perf/README.md` and `tests/perf/baselines/*.json` — historical suites
  with toolchain identities; check for staleness.
- `docs/development/AGGRESSIVE_AND_PROVEN_RESEARCH.md` — architecture and
  verification research with primary sources.

Never reuse a number without its compiler/host identity and sample protocol.
