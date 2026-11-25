---
name: xylem-optimizer
description: Xylem compiler changes in xylem-lang must be true, proven, efficient. Use when changing the frontend, IR, optimizer, lowering, prelude or stdlib; adding an optimization; investigating slow generated code or self-host build times; or advancing a performance checklist item. Requires LLVM release verification, an independent verifier and a runnable before/after test program.
---

# Xylem optimizer work

Policy lives in `AGENTS.md` at the repository root; this skill executes it.
The three gates are **true → proven → efficient**. Each gate starts `red` and
turns green only on an artifact with two identities: yours and an independent
verifier's. A checklist box is never the unit of completion.

## Repository orientation

- `compiler/src/` is the Xylem-written compiler (437 modules as of the
  2026-11-21 snapshot). Regenerate the count with
  `python3 scripts/check-skill-claims.py --counts` before relying on it.
  Pipeline: `driver.xy` → `pipeline.xy` → `optimize.xy`. `optimize.xy:213-311` is the
  per-function pass order — read it before adding a pass.
- `compiler/src/ir.xy` defines 55 instruction kinds and the canonical IR;
  `ir_json.xy`, `ir_array_json.xy`, `ir_place_json.xy` serialize
  `xylem-bootstrap-ir/1`. Protocol changes need an ADR and host update.
- `compiler/src/optimize_fold_agg.xy` exists but is unimported — check the ADR
  backlog before writing a new aggregate pass.
- `compiler/src/{name_index.xy,loader.xy}` contain existing hash/index patterns;
  prefer them over new linear scans.
- `stdlib/src/std/` and `compiler/src/prelude*.xy` define the collection and
  string operations that dominate hot workloads.
- `scripts/check-*.xy` are the correctness gates; see `references/gates.md`.
- Current blockers and source map: `references/blockers.md`,
  `references/source-map.md`.

## Writing professional Xylem code

Xylem is a checked, effect-tracked language — not Rust with different syntax.
Verified rules from executing the repository's own sources (details and examples
in `references/xylem-code-style.md`):

- `main` must return `i32` or `Unit`; declare effects on functions that allocate:
  `fn f(...) -> ... effects [allocation]`.
- No `^` bitwise operator and no `<<` shift operator; use arithmetic and `%`.
- Integer arithmetic is checked and traps (`R6002`) on overflow. Bound
  recurrences with `% 1000000007` (or an appropriate modulus).
- Integer literals in struct fields need type ascription (`1 as i64`) where
  inference cannot resolve them; `Option.None` inference may require a sentinel
  or an explicit type.
- Use `let mut` before `vec_push(&mut v, ...)`; immutable bindings cannot be
  mutably borrowed (`E3107`).
- Prefer spans/indices over allocating new strings; use `text_between` sparingly.
- Preserve trap locations and diagnostic spans when moving or specializing code.

## Steps (each ends on a checkable, exhaustive completion criterion)

1. **Own the change.** Before editing, write one ownership category
   (`REPO`/`HOST`/`JOINT`/`RESEARCH`), the governing `AGENTS.md` path, a record
   id, and the ledger path (`docs/development/EVIDENCE_LEDGER.md`).
   *Done when:* all four appear in the working notes before any code edit.

2. **Pin the contract and open the record.** Write the observable equivalence
   contract (checksums, traps, diagnostics, ownership/drop, determinism) and the
   independent oracle for each. Fill the 13-field hypothesis record with numeric
   acceptance and rejection thresholds; tag claims with the six tags from
   `docs/development/optimization-knowledge-base.md`.
   *Done when:* every affected semantic has an oracle whose expected value comes
   from the spec, a conformance case, or an external C/Rust reference — never
   from the new implementation.

3. **Find the earliest artifact.** Layer diagnosis: prelude → canonical IR →
   optimizer → lowering → runtime → backend. Check the dormant-pass backlog.
   *Done when:* an exact `file:line` insertion point is named and earlier layers
   are ruled out in the record.

4. **Fire the tracer bullet.** Make the smallest isolated change plus a runnable
   before/after test program using `--backend llvm --release`. Keep algorithm
   and representation changes in separate experiments.
   *Done when:* before and after artifacts exist as files with recorded compiler
   and host hashes; the record's result stays `unmeasured` until executed.

5. **Prove correctness** with `references/gates.md` (selfhost modules,
   conformance, IR parity, stdlib digest, perf reproducers, plus the cross-repo
   `optimizer_equivalence` and `llvm_backend` tests).
   *Done when:* every gate passes with zero checksum mismatches and versions
   recorded; a failure stops the work and is retained as a negative result.

6. **Demonstrate efficiency** with paired A/B on a quiet host, ≥3 samples,
   fixed checksums, 10% threshold with noise slack, and a C denominator where
   one exists. Add a regression guard encoding the current result with slack.
   *Done when:* before/after numbers and artifacts are in `reports/` and the
   guard is a fixed-checksum workload, IR canary, or timing baseline.

7. **Record and hand off.** Add a ledger entry as
   `PENDING_INDEPENDENT_VERIFICATION` with exact commands and artifact paths.
   Dispatch a fresh-context, read-only verifier.
   *Done when:* the ledger carries two distinct identities and the verifier's
   own reproduction output; only the verifier changes status to `VALIDATED`.

## References (load on demand)

- `references/gates.md` — exact commands and what each proves.
- `references/proof-discipline.md` — what each verification layer proves, noise floors, milestone contract.
- `references/blockers.md` — current correctness/equivalence/scalability blockers.
- `references/source-map.md` — where each class of change lives.
- `references/xylem-code-style.md` — verified syntax, idioms and anti-patterns.
