---
name: xylem-platform-documentation
description: Maintain Xylem platform documentation using the project's README/phase-log/decision-record surface, honest status and evidence labels, doc-gate snapshots and archive discipline. Use when writing a README, phase work log or decision record, updating a published count, or reconciling a doc claim with the tree.
trigger:
  branches:
    - when: "writing or reviewing a README, work log or decision record"
      read: "## The documentation surface; ## Decision records; ## Pointer wording"
    - when: "choosing a status tag or evidence label"
      read: "## Status tags and evidence labels"
    - when: "updating a published count or running doc gates"
      read: "## Documentation gates and snapshots"
    - when: "a doc claim disagrees with the code or with an archived phase"
      read: "## Authority and archiving; ## Completion criteria"
  do_not_activate:
    - "language/compiler fact claims (use xylem-language, xylem-compiler-architecture)"
    - "creating a new status, briefing, wave or dispatch document (forbidden)"
source_of_truth: "AGENTS.md documentation policy; code, tests and generated artifacts"
evidence_status: "Documentation records intent; it never overrides the tree"
---

# Xylem platform documentation

**MUST** treat code, tests and generated artifacts as the source of truth. Documentation records intent and history; it never overrides the tree. **MUST** keep this skill a pointer to the policy in `AGENTS.md`, not a restatement of it.

## Authority and archiving

When a doc claim and the tree disagree, **MUST** fix or archive the document and **MUST NOT** change code to match a stale document. **MUST** move a completed phase log from `work_logs/phase-NN-*.md` to `work_logs/archive/` and **MUST** preserve prior decisions in Git history rather than erasing them. **MUST NOT** use a documentation edit to paper over an unimplemented feature.

## The documentation surface (single source of truth)

**MUST** keep exactly three surfaces:

- `README.md` — the single entry point: what the project is, how to build and verify it, and where the authoritative code lives.
- `work_logs/phase-NN-*.md` — one log per phase; active phases stay in `work_logs/`, completed phases move to `work_logs/archive/`.
- `docs/decisions/` — accepted decision records, condensed to an index (`docs/decisions/README.md`) plus the decision text.

**MUST NOT** add handover, status, briefing, wave, dispatch, scoreboard or duplicate work-log documents; intent belongs in a phase log or a decision record. Docs-as-code practice — plain-text Markdown in Git, reviewed and gated like code — is the model (https://www.writethedocs.org/guide/docs-as-code/).

## Decision records

**MUST** write one decision per file with `Status`, `Date`, `Related`, rationale, alternatives, consequences and open questions, following ADR practice (https://adr.github.io/, https://adr.github.io/ad-practices/). **MUST** keep index rows to id, title, status and date only; the named file carries the decision text. **MUST** append dated amendments instead of silently rewriting accepted text — D-001 v2 and D-005 record amendments this way. **MUST** treat the accepted decision text plus the pinned tree as canonical over any summary in a log or README.

## Status tags and evidence labels

**MUST** tag every feature with one of the exact tags `IMPLEMENTED_AND_VERIFIED`, `IMPLEMENTED_BUT_LIMITED`, `EXPERIMENTAL`, `SPECIFIED_NOT_IMPLEMENTED`, `PLANNED`; **MUST NOT** advertise a future capability as production-ready. **MUST** label each claim `VERIFIED`, `MEASURED`, `INFERRED`, `HYPOTHESIS`, `PLANNED` or `UNKNOWN`, and **MUST** mark one's own unverified evidence `PENDING_INDEPENDENT_VERIFICATION` until another agent reproduces it. **DEFAULT TO** `IMPLEMENTED / PENDING_VERIFICATION` for executed-but-unreproduced work. **MUST** attach an exact command and artifact identity to any `VERIFIED` label; **MUST NOT** upgrade a label without reproduction.

## Documentation gates and snapshots

**MUST** run the five local doc gates with the pinned compiler before calling a doc change complete: `scripts/check-semantic-decisions.xy`, `scripts/check-limits-classification.xy`, `scripts/check-spec-citations.xy`, `scripts/check-markdown-links.xy`, `scripts/check-doc-counts.xy` (`.githooks/pre-commit`; `.github/workflows/docs-gates.yml` adds `scripts/check-perf-checklist.xy`). **MUST** update every published copy of a count or snapshot together — a count guarded in only one place is a recorded defect (`work_logs/archive/SPEC_DISAGREEMENTS.md`, item 7). **MUST** record gate output in the phase log; a gate failure is a review bar. **MUST NOT** trigger CI or deploy in this campaign: run the gates locally.

## Pointer wording

**MUST** cite a canonical file with an exact `path:line` anchor or an exact URL; **MUST** write "See `X`" and **MUST NOT** copy X's content into a second authoritative paragraph. **MUST** use relative Markdown links, name the single owning file per fact, and give evidence labels for status claims. **DEFAULT TO** one sentence of local context plus a pointer rather than a restatement, so a change to the owner does not leave two stale copies.

## Completion criteria

- Every changed file sits in `README.md`, `work_logs/` or `docs/decisions/`; no duplicate status surface exists.
- Each feature has a valid status tag; each claim has an evidence label; unverified claims say `PENDING_INDEPENDENT_VERIFICATION`.
- All five doc gates ran locally and their output is recorded; published counts agree in every location.
- The decision index contains id/title/status/date only; amendments are dated; archive moves are complete.
- A reader can trace each claim to a local `path:line` or primary-source URL, and to code/tests for facts.

## References

- https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions.html — one decision, its context and consequences.
- https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/introduction.html — accepted ADR practice.
- `README.md`; `ecosystem-readiness/AGENTS.md`; `xylem-platform/AGENTS.md`; `docs/decisions/README.md`; `docs/decisions/D-001..D-005`.
- `ecosystem-readiness/work_logs/` and `work_logs/archive/`; `.githooks/pre-commit`; `.github/workflows/docs-gates.yml`; `ecosystem-readiness/work_logs/archive/SPEC_DISAGREEMENTS.md:15`.
