# Maintaining the Xylem skills library

## When to update

- New/changed syntax, types, operators, effects, generics, imports.
- New compiler stage, IR field, pass, intrinsic, backend or ABI change.
- New stdlib API or changed allocation behavior.
- Fixed compiler defect that made a source-level workaround unnecessary.
- New measured performance evidence or regression.
- Changed CLI flags, environment variables, toolchain pins or gate commands.

## Procedure

1. Identify the claim in `SKILL.md` or a `references/*.md` file that changed.
2. Verify against the current implementation with file:line and a test; run the
   example if it is marked VERIFIED.
3. Update the evidence label: VERIFIED / MEASURED / INFERRED / HYPOTHESIS /
   PLANNED / UNKNOWN. Do not upgrade a label without reproduction.
4. If a performance recommendation depended on a compiler limitation that was
   fixed, downgrade or remove the workaround and record why.
5. Re-run structural validation (frontmatter, links, file paths, examples).
6. Record the change in `docs/development/AGENT_SKILLS_VALIDATION.md`.
6. Record the change in `xylem-lang/docs/development/AGENT_SKILLS_VALIDATION.md`.

## Automation to keep cheap

Run the offline structural guard before concluding a maintenance pass:

    python3 scripts/check-skills-maintenance.py
    python3 scripts/check-skills-maintenance.py --self-test

The guard resolves the step 6 validation path, checks that every local skill
directory containing a `SKILL.md` is listed in `INDEX.md`, validates each
`SKILL.md` frontmatter, and resolves the repo-relative paths cited below.
`--self-test` injects each of those defects into a temporary tree and requires
the guard to name it, so the check cannot silently rot. It is deterministic,
offline and needs no compiler; a failure is a review bar, not a build gate.

- `grep -rn` for skill-referenced file paths to detect stale paths.
- Compile every example marked VERIFIED with the current compiler.
- Check every `SKILL.md` has valid YAML frontmatter with `name` and `description`.
- Confirm `INDEX.md` lists every skill directory that contains a `SKILL.md`.

Do not build an expensive maintenance system; the value is in keeping claims
honest, not in automating prose.

## Cross-repository notes

The backend skill lives in `xylem-rust/.agents/skills/`. When backend behavior
changes (especially LLVM lowering, ABI, target features, runtime allocation),
update both that skill and the `xylem-lang` skills that describe source-level
costs (`xylem-hot-paths-and-abi`, `xylem-efficient-code`,
`xylem-performance-analysis`). Keep the cross-references in `INDEX.md` current.
