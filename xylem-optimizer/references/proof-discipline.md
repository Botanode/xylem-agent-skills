# Efficient, true, proven — verification discipline (source-backed)

This reference is the evidence standard behind the three gates. No source file
in this workspace has been modified by this research.

## Layers of assurance (what each tool actually proves)

| Layer | Question | Mechanism | Assurance |
|---|---|---|---|
| Well-formedness | Is IR structurally legal? | LLVM `verify`, `opt -verify-each`, rustc `-Z validate-mir` | Structural only, **not** semantics |
| Semantics preservation | Did *this* transformation preserve meaning? | Alive2 bounded refinement, translation validation, Creusot/Why3 | Machine-checked per execution, bounded or contract-relative |
| End-to-end behaviour | Do configurations agree? | Csmith, EMI, Rustlantis, differential tests | Empirical bug finding, no proof |
| Runtime UB | Did an execution violate assumptions? | Miri, UBSan/ASan/MSan, Valgrind | Dynamic, path-specific |
| Efficiency | Is output better and compiler cheaper? | `instructions:u` (rustc-perf), llvm-mca/uops.info, CSiBE, Callgrind | Measured with noise control |
| Institution | Repeated on every change? | lit/FileCheck, `mir-opt` blessed MIR, compiletest UI, bots | Process |

Sources: LLVM verifier https://llvm.org/docs/Passes.html#verify-module-verifier ;
`opt -verify-each` https://llvm.org/docs/CommandGuide/opt.html ;
`-Z validate-mir` https://doc.rust-lang.org/nightly/unstable-book/compiler-flags/validate-mir.html ;
Alive2 https://users.cs.utah.edu/~regehr/alive2-pldi21.pdf ; Csmith https://cs.utah.edu/~regehr/papers/pldi11-preprint.pdf ;
Rustlantis https://research.ralfj.de/papers/2024-oopsla-rustlantis.pdf ;
Miri https://github.com/rust-lang/miri ; rustc-perf https://github.com/rust-lang/rustc-perf ;
llvm-mca https://llvm.org/docs/CommandGuide/llvm-mca.html ; uops.info https://uops.info/ ;
CSiBE https://szeged.github.io/csibe/ ; LLVM testing https://llvm.org/docs/TestingGuide.html.

## Why full proof is impractical here

- CompCert proves 15 passes in Rocq/Coq but states generated code reaches only
  ~90% of GCC -O1 on ARM64 and lacks aggressive loop optimizations
  (https://compcert.org/man/manual001.html).
- Rustlantis: *"it is not feasible to undertake such an endeavor for each
  language… we are quite far from being able to actually prove the correctness
  of the fastest production-grade compilers"* (OOPSLA 2024).
- Necula 2000: translation validation costs about one compiler pass to build
  but slows compilation ~4×, with ~10% worst-case false-alarm rates
  (https://people.eecs.berkeley.edu/~necula/Papers/tv_pldi00.pdf).
- Alive2: designed for zero false alarms; *"bounded"* (loops unrolled), supports
  54 of 258 platform-independent intrinsics, no interprocedural transforms
  (https://github.com/AliveToolkit/alive2). The SMT solver is in the trusted
  base (24 Z3 bugs in Alive2's bug list).

Therefore: prove the small stable kernel; validate the large fast-moving
pipeline; never call a heuristic or an LLM prediction a proof.

## Noise floors (pre-register before measuring)

rustc-perf/`instructions:u` thread
(https://internals.rust-lang.org/t/what-is-perf-rust-lang-org-measuring-and-why-is-instructions-u-the-default/9815):
no-change instruction counts typically ±0.2%, worst outliers +1.3%/−1.1%;
wall-time outliers −8.9%/+9.7%. Use instruction counts as primary, wall time as
sanity. LLVM benchmarking setup (governor=performance, ASLR off, SMT off,
`perf stat -r 10`) can reach <0.1% variation but low noise is necessary, not
sufficient (Mytkowicz et al., ASPLOS 2009).

## Milestone contract

1. **Implemented** — change compiles; IR verifier clean; minimal regression
   test (possibly XFAIL/known-bug) and minimized reproducer committed.
2. **Proven/checked** — refinement validated for the pattern with an explicit
   bound (Alive2), or differential + UB-free oracle shows no mismatch; trusted
   base and unsupported features documented; minimized counterexample attached
   if a check fails.
3. **Demonstrated improvement** — `instructions:u` beyond noise floor plus wall
   time sanity, llvm-mca/uops.info where instruction mix changed, code size and
   compile time within budget, exact toolchain identities recorded.

If 2 fails: do not ship. If 2 holds but 3 unproven: ship behind an off-by-default
flag with a tracking issue. A checklist box is never the unit of completion.

## Test hygiene (LLVM/rustc practice)

- Minimal pass pipeline in RUN lines (`-passes=instcombine`, not `-O3`);
  FileCheck `CHECK-NEXT`/`CHECK-NOT`/`CHECK-LABEL`, named values, no gratuitous
  `undef`; `--bless` outputs reviewed by a human.
- Pin a single MIR/IR pass with `test-mir-pass:`-style directives so unrelated
  pass changes do not break the test.
- Land baseline expectations (XFAIL/known-bug) before the fix; remove the TODO
  after; attach a regression test to every bug report.
- Deduplicate failures (ICSE 2016: 877 tests for one bug; Alive2 `jdupes
  --print-unique`) — count corrected bugs, not failing cases.
