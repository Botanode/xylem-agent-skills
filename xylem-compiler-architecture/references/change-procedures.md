# Compiler change procedures

1. **Locate**: use `xylem-pipeline-inspector` to find the stage that produces
   the suspect IR/instruction; confirm with file:line.
2. **Reproduce**: minimal `.xy` program with deterministic checksum; record
   compiler/host hashes, flags, seed.
3. **Gates before change**: `check-ir-instruction-parity`, `check-conformance`,
   `cargo test -p xylem-compiler --test optimizer_equivalence`,
   `cargo test -p xylem-llvm --test llvm_backend`.
4. **Change**: smallest isolated edit; new IR kinds require ADR + host update;
   new intrinsics need registry/type-check/lowering/self-hosted mirrors.
5. **Tests**: IR canary or lit-style assertion plus runtime checksum; XFAIL
   first when appropriate; differential backend test where semantics touched.
6. **Verify**: all gates, then paired A/B under `--backend llvm --release`
   with ≥3 samples, exact identities and noise floor; add regression guard.
7. **Record**: evidence entry as PENDING_INDEPENDENT_VERIFICATION; only an
   independent verifier may mark it VALIDATED or tick a checklist box.

Do not modify conformance manifests, execution records or benchmarks owned by
other workflows; use separate skill-development records.
