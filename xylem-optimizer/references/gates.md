# Verification gates for xylem-lang changes

Run from the repository root. `XYLEM_BOOTSTRAP` and `XYLEM_BACKEND_HOST` must
point at the pinned artifacts in `toolchain.toml`.

```sh
export XYLEM_BOOTSTRAP=target/pinned-toolchain/artifacts/xylem
export XYLEM_BACKEND_HOST=target/pinned-toolchain/artifacts/xylem-backend-host
./scripts/check.sh                      # full default gate set
```

Individual gates (from `scripts/check.sh`):

| Command | What it establishes |
|---|---|
| `./scripts/run-xy.sh scripts/check-selfhost-modules.xy` | module inventory, imports, line/function budgets |
| `./scripts/run-xy.sh scripts/check-seed-modules.xy` | seed module set intact |
| `./scripts/run-xy.sh scripts/check-semantic-decisions.xy` | ADR register consistency (103 records) |
| `./scripts/run-xy.sh scripts/check-limits-classification.xy` | non-claim labels |
| `./scripts/run-xy.sh scripts/check-spec-citations.xy` | spec/diagnostic citations |
| `./scripts/run-xy.sh scripts/check-markdown-links.xy` | relative links resolve |
| `./scripts/run-xy.sh scripts/check-doc-counts.xy` | published snapshot counts match tree |
| `./scripts/run-xy.sh scripts/check-perf-checklist.xy` | checked items have adjacent resolved Evidence lines |
| `./scripts/run-xy.sh scripts/check-ir-instruction-parity.xy` | all declared self-host IR forms constructible |
| `./scripts/run-xy.sh scripts/check-stdlib-digest.xy` | stdlib snapshot unchanged |
| `./scripts/run-xy.sh scripts/generate-stdlib-embed.xy --check` | embedded stdlib matches source |
| `./scripts/run-xy.sh scripts/check-feature-coverage.xy --check` | feature coverage table current |
| `./scripts/run-xy.sh scripts/check-conformance.xy` | conformance corpus |
| `./scripts/run-xy.sh scripts/check-parity.xy --self-test` | differential harness self-test |
| `./scripts/run-xy.sh scripts/check-perf-reproducers.xy` | 8 IR canaries; currently 6 clean, 2 expected failures |

Opt-in tiers: `SELFHOST_STAGE_GATE=all`, `check-cache-identity.xy`,
`check-stage-record-identity.xy`, `check-selfhost-stage2/3.xy` — expensive, run
at integration milestones.

Note: `check.sh` can stop early at the known interpreter-only
`diagnostic-r6006` (`--max-steps` unsupported by the self-hosted `run`). Record
that as a known limitation, not as a pass.

Cross-repo correctness gates (run in `xylem-rust`):

```sh
cargo test --workspace
cargo test -p xylem-compiler --test optimizer_equivalence
cargo test -p xylem-llvm --test llvm_backend
```

`optimizer_equivalence.rs` generates 24 deterministic programs, runs them
unoptimized and optimized through the interpreter, and requires identical
results. `llvm_backend.rs` uses the interpreter as an independent oracle so a
bug shared with Cranelift cannot pass.
