---
name: xylem-code-review
description: Review Xylem application or compiler changes for correctness, maintainability and evidence-backed performance. Use when reviewing a Xylem program, a compiler/runtime change, a benchmark, or a performance claim; produce actionable findings that separate verified defects from hypotheses.
---

# Xylem code review

Review two axes independently: **correctness** and **performance**. A plausible
performance concern is a question, not a defect, until evidence exists.

## Application code checklist

- **Correctness**: verified syntax; supported features only; semantics of
  ownership/copies/drop; checked arithmetic and bounds; error paths; boundary
  inputs; backend consistency (LLVM release path).
- **Maintainability**: cohesive modules, clear names, no unnecessary
  complexity, appropriate abstractions, comments that explain *why*.
- **Performance**: unnecessary allocations or copies; repeated conversions;
  runtime helper calls in hot loops; repeated string construction; map access
  patterns; bounds checks; indirect calls; data locality; avoidable temporaries.
- For every performance finding, state: workload condition, mechanism, evidence
  (IR/assembly/counters), and whether the fix belongs in source, stdlib, runtime
  or compiler. Label as VERIFIED / INFERRED / HYPOTHESIS.

## Compiler/runtime change checklist

- Correct compilation stage; respects dependency direction.
- Semantic invariants: aliasing, mutation, side effects, overflow, float traps,
  error behavior, object lifetimes, memory ordering, determinism, backend parity.
- Protocol: `xylem-bootstrap-ir/1` and `xylem-native/16` unchanged unless an ADR
  and coordinated host update exist; toolchain pins untouched.
- Regression coverage: minimal test (XFAIL first), differential/equivalence
  tests, affected backends, generated-code quality.
- Evidence: verifier clean, proof/validation artifact where applicable, paired
  A/B measurement with exact identities, noise floor respected.
- Disposition: implemented / proven correct / demonstrated improvement; never
  call a box "done" without an independent verifier.

## Benchmark review

Reject comparisons with: different algorithms, unequal optimization levels,
mismatched outputs/checksums, Xylem debug vs Rust release, removed work,
single noisy samples, or missing compiler/host identities. A benchmark with only
49/86 equivalent cases cannot support a language-wide ranking.

## Output format

| Finding | Severity | Evidence | Layer | Recommendation | Confidence |
|---|---|---|---|---|---|

End with: what is verified, what is hypothesis, what needs measurement, and
which compiler subsystem owns each remaining problem. Do not report speculative
performance concerns as confirmed defects.

## References

- `references/review-checklist.md` — detailed evidence requirements.
