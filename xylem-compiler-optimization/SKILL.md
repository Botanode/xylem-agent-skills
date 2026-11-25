---
name: xylem-compiler-optimization
description: Propose and implement Xylem compiler optimizations with correctness proofs and measured evidence. Use when investigating a missing optimization (folding, CSE, inlining, LICM, bounds elimination, escape analysis, scalar replacement, devirtualization, vectorization), or when an IR/runtime cost must be fixed in the compiler rather than the application.
---

# Compiler optimization work

Policy lives in `AGENTS.md`. Three milestones: implemented → proven correct →
demonstrated improvement. No gain without an LLVM release before/after test and
an independent verifier.

## What exists and what is missing (statically audited; see citations)

- **Implemented**: block/constant folding (`optimize_fold.xy`, `optimize_const.xy`),
  vec-option folding, induction/literal/repeated bounds proofs
  (`optimize_bounds.xy:86-99`, `optimize_induction.xy:47-116`,
  `optimize_vec_proof.xy:124-189`), constant-remainder specialization
  (`optimize_modulus.xy`), fixpoint multi-block inlining (`optimize_inline.xy:30-44,423-431`),
  LICM + loop memoization (`optimize_hoist.xy`), CSE for
  `Unary|Binary|Cast|VecLen` only (`optimize_cse_table.xy:43-79`), dead pruning.
- **Missing/dormant**: aggregate read folding (`optimize_fold_agg.xy` unimported;
  insert at `optimize.xy:221,255`), pure-read/Index CSE (ADR-0101 claims it but
  code does not), `merge_once` (`optimize_merge.xy:183-239` never called),
  interval/range analysis, unrolling, strength reduction, vectorization, escape
  analysis, devirtualization, alias facts, cost model.
- **Protocol-blocked**: `arithmetic:"proven"` (`toolchain.toml:15-18`; the
  comment calls it "ADR-0100" in the draft sense — the final ADR-0100 in
  `docs/decisions/README.md:8596` is the inliner).
  `VecIndex.checked:false` is emitted (`compiler/src/ir_place_json.xy:32`,
  `compiler/src/optimize_vec_proof.xy:8`) but is reported as ignored by the
  pinned host (INFERRED; host-side consumption is external to this repository,
  see `docs/development/optimization-knowledge-base.md:167`).

## Workflow

1. Identify construct + semantics (capability matrix, contract, ADRs).
2. Reproduce inefficiency with minimal program + canonical IR dump.
3. Find earliest artifact (prelude → IR → optimizer → lowering → runtime).
4. Hypothesis with numeric acceptance/rejection thresholds and six evidence tags.
5. Correctness conditions: aliasing, mutation, side effects, overflow, finite
   floats, error behavior, lifetimes, memory ordering, determinism, both backends.
6. Implement smallest safe change; keep algorithm and representation separate.
7. Tests: focused IR canary + differential/equivalence + minimized reproducer.
8. Prove: verifier clean, proof-discipline reference satisfied, no new traps.
9. Benchmark paired A/B under LLVM release, ≥3 samples, exact identities, noise
   floor, code size and compile time within budget.
10. Record evidence as PENDING_INDEPENDENT_VERIFICATION; independent verifier
    decides VALIDATED and any checklist tick.

## Safeguards

- Never remove runtime operations solely because they look expensive; prove
  semantic necessity first (R6001/2/4/5, drop order, trap spans).
- Never generalize a pass from one test case; never sacrifice correctness for
  a benchmark; never generalize Cranelift results to release.
- Target-independent transformations need a cost model; none exists today, so
  target-specific tuning is HYPOTHESIS until measured.

## References

- `references/opportunities.md` — ranked opportunity map with file:line and status.
- `../../xylem-optimizer/references/proof-discipline.md` — evidence standard.
