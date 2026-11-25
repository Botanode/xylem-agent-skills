---
name: xylem-efficient-code
description: Write and review performance-sensitive Xylem source for the compiler that exists today. Use when implementing hot loops, numeric kernels, collection-heavy or string-heavy code, or when investigating unexpected runtime overhead in a Xylem program. Distinguishes verified costs from optimization hypotheses.
---

# Efficient Xylem source code

Generic advice ("use efficient algorithms", "minimize allocations") is not
enough. This skill ties each recommendation to measured or source-verified
Xylem compiler behavior. LLVM is the release backend; Cranelift timings are
development-only. Every claim cites evidence; evidence labels follow
`INDEX.md:47`.

## Decision model (follow in order)

1. **Workload**: input size, frequency, latency/throughput, memory, distribution.
2. **Algorithm**: complexity and data structure first — no compiler flag fixes
   an O(n²) algorithm.
3. **Representation**: primitive vs dynamic, copies, allocation, lifetime.
4. **Lowering**: canonical IR, runtime calls, ABI crossings, optimization scope.
5. **Machine code**: instructions, loads/stores, branches, calls, vectorization.
6. **Root cause**: source / frontend / IR / optimizer / backend / ABI / runtime /
   memory manager / stdlib / benchmark method / hardware. Do not force a source
   workaround for a compiler defect — record it.
7. **Smallest justified change** — source workaround only when a compiler fix
   is not feasible; otherwise propose a compiler/runtime change.
8. **Verify correctness** — correctness gates first.
9. **Measure** — paired A/B with exact identities.
10. **Generalize** — update the pattern library only when evidence generalizes.

Kept in sync with `xylem-performance-analysis/SKILL.md:12-27` per
`MAINTENANCE.md:39`.

## Verified source rules

- **Scalar loops**: keep values in `i32/i64` scalars; `u64/usize` force the
  full-value path (`contract.md:2323-2326`). Bound arithmetic with `%` because
  overflow traps; the compiler cannot assume wrapping.
- **Function calls**: small leaf functions can inline (speed build measured
  16.5× faster than size build for `inline-leaf`, `tests/perf/README.md:255-274`,
  16.5× at :270-271); large aggregates cross a boxed full-value ABI — prefer
  scalars or references on hot paths.
- **Loops**: hoist `vec_len` (in-loop measurement 308,594 vs scalar floor
  199,219 ns/4096 pass); prefer direct indexing `*view[index]` over `vec_get`+
  match (387,019 vs 698,661); avoid temporaries that become `a_cell`s.
  (`tests/perf/README.md:321-326`)
- **Collections**: cache map lookups in locals; never hold a borrow across
  insert/remove; `map_remove` is BLOCKED (nondeterministic); Set has linear
  lookup. See `xylem-collections-and-strings`.
- **Strings**: hoist `byte_length`; avoid `concat` in loops (prefix recopy);
  `std/iter` adapters copy/reverse — write explicit `while` on hot paths.
- **Floats**: every op carries a finiteness guard; `f32` rounds after each op;
  no fast-math. Ordered reductions cannot vectorize legally today.

## Pattern library

`references/patterns.md` contains 20 annotated patterns (inefficient vs
preferred Xylem source, mechanism, equivalence requirements, evidence label).
`examples/` holds recorded, reproducible programs — re-validate against the
current compiler and record an independent verifier before treating them as
validated. A pattern marked HYPOTHESIS has no before/after measurement — do not
present it as a confirmed speedup.

## Procedure

1. Locate the hot construct with a benchmark or `xylem profile` helper census.
2. Check the capability matrix (`xylem-language`) for edition/backend support.
3. Compare with the pattern library; ensure semantic equivalence.
4. Validate both versions with `xylem check` and matching checksums.
5. Inspect IR/assembly with `xylem-pipeline-inspector` when the cause is unclear.
6. Measure with paired A/B under `--backend llvm --release`, ≥3 samples, exact
   identities; add a regression guard with slack.
7. If the cost is in lowering/runtime, record a compiler improvement instead of
   contorting the source.

## Anti-patterns

See `references/anti-patterns.md`. Do not normalize severe compiler overhead as
an unavoidable language feature; do not remove checks/traps to win a benchmark.

## References

- `references/patterns.md` — source-level pattern library.
- `references/anti-patterns.md` — verified expensive patterns and ownership.
- `references/compiler-behavior.md` — what the compiler does to source constructs.
