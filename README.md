# Xylem agent skills — canonical library

Version 1.1 — 2026-11-25. This repository is the **single source of truth** for
in-house Xylem agent skills. The copies under `xylem-<repo>/.agents/skills/` are
installed artifacts; regenerate them from here after changes.

## Contents

- 112 skills in six domains: engineering governance, language/compiler
  correctness, native representation/performance, backend/runtime/toolchain,
  verification/security, benchmark evidence, plus platform ecosystem and
  application delivery.
- `SKILL-CATALOG.md` — the complete list of skill IDs and purposes.
- `INDEX.md` — coverage matrix and maintenance rules for the compiler/quality
  skills.
- `validate.py` — validates every skill, unique IDs, frontmatter, structure and
  catalog coverage.
- `install.py` — copies skills into a target repository's `.agents/skills/`
  without overwriting differing files.
- `REGRESSION-GATES.md` — suggested executable checks; not a second CI system.
- `EVALUATION.md`, `MAINTENANCE.md` — validation and maintenance procedures.

## Install into a repository

From a clone of this repository:

```bash
python3 validate.py
python3 install.py --project /absolute/path/to/xylem-repo --dry-run
python3 install.py --project /absolute/path/to/xylem-repo
```

The installer targets `<project>/.agents/skills/` and preserves an existing
`AGENTS.md`. Merge the routing table from the target repository's `AGENTS.md`
rather than replacing its local policy. Global installation is supported with
`--global-skills`, but project-local installation is preferred.

## Application delivery chain

The strict delivery method is:

```text
research → design → implementation → build → verification → review → integration
```

Enter through `xylem-app-delivery`; it routes to `xylem-app-research`,
`xylem-app-design`, `xylem-app-implementation`, `xylem-app-build` and
`xylem-app-verification`, plus the existing specialist skills for review,
evidence and agent workflow. Every gate has an exit artifact and a STOP
condition. No gate may be skipped and no unrun check may be reported as passed.

## Rules

- Skills guide work; repository `AGENTS.md` and verification rules are
  authoritative.
- Use primary sources and label claims. Do not copy implementation code from
  other projects.
- Never load every skill at once; load the smallest applicable set.
- Run `python3 validate.py` before publishing changes. At creation it reports
  `Validated 112 skill files; 0 errors`.

## Verification at publication

- `python3 validate.py` → `Validated 112 skill files; 0 errors`.
- Installed and validated in `xylem-lang`, `xylem-rust` and `xylem-platform`
  integration branches.

All skill behaviour claims remain `PENDING_INDEPENDENT_VERIFICATION` until a
fresh agent reproduces the relevant work; skills are guidance, not enforcement.
