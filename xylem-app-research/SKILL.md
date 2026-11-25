---
name: xylem-app-research
description: Establish revision-pinned, citation-backed facts before designing or building a Xylem application. Use at the start of any app task to separate repository source truth from prior agent claims, build a mandatory claim/evidence table, and stop when acceptance-relevant facts are gathered.
---

# Xylem app research

This skill owns the **research slice of app delivery** only. It sequences and cites; it does not replace the repository-truth mechanics in `xylem-source-truth` (`.agents/skills/xylem-source-truth/SKILL.md:14-24`), the evidence-label policy in `.agents/skills/INDEX.md:70`, or the verification rule in `AGENTS.md:57-74`. Research produces a claim/evidence table, not code and not a design.

## Rank the sources (MUST)

1. **MUST** treat the checked-out tree at a recorded revision as primary: `toolchain.toml`, `docs/decisions/`, `lotus/`, `stdlib/`, `examples/`, conformance cases. A claim about what Xylem does is only VERIFIED when read there or executed with the pinned compiler.
2. **MUST** treat accepted decision records as primary for intent: D-001 layering, D-002 plugins, D-003 app conformance, D-004 product names, D-005 Lotus ports, D-006 skill policy. Where a decision and the tree disagree, the tree wins and the contradiction is recorded (workspace documentation policy).
3. **MUST** treat official primary external documents as secondary authority for method and vocabulary only — Cochrane Handbook for search/eligibility discipline, Nygard's original ADR, `adr.github.io`, Google API design guide, RFC 2119. **MUST NOT** treat a prior agent's completion record, README status tag, skill prose, blog summary or recall as primary.

## Pin the revision (MUST)

**MUST** record repository root, branch, full HEAD hash, dirty status, the pinned bootstrap source revision and artifact sha256 (`toolchain.toml:2-13`), the protocol identities (`toolchain.toml:15-20`), and the UTC access date for every external URL. **MUST** keep source revision and artifact hash distinct; **MUST NOT** say "verified against 1.0.0" without the hash. **MUST** cite every claim as `path:line` or exact URL; a claim with no citation is UNKNOWN, not VERIFIED.

## Label every claim (MUST)

- **VERIFIED** — observed directly in pinned source or in the output of an executed command.
- **INFERRED** — derived from two or more VERIFIED facts; name the derivation.
- **HYPOTHESIS** — plausible, untested; name the experiment that would settle it.
- **PLANNED** — stated intent in an accepted decision or work order, not current behavior.
- **UNKNOWN / PENDING_INDEPENDENT_VERIFICATION** — no acceptable source, or one agent's un-reproduced evidence (`INDEX.md:70`; `AGENTS.md:57-63`).

**MUST** keep the original label when a claim is copied forward; **MUST NOT** upgrade a label without new evidence.

## Claim/evidence table — mandatory artifact

**MUST** produce a table with exactly these columns:

| ID | Claim | Label | Evidence (`file:line` or URL) | Acceptance criterion served | Contradiction / action |
|----|-------|-------|-------------------------------|-----------------------------|------------------------|

**MUST** add one row for every fact an acceptance criterion depends on, one row for any prior agent claim checked and rejected or downgraded, and one row for every open question. **MUST** quote only the minimum signature or invariant needed; **MUST NOT** copy implementation code into the research record.

## Stop rule (DEFAULT TO saturation, not completeness)

**MUST** stop researching when each acceptance criterion has a VERIFIED or explicitly UNKNOWN row and every contradiction is either resolved against the hierarchy or escalated as an interface request. Cochrane's handbook defines a pre-specified question and eligibility criteria before searching and collates multiple reports of one study into a single primary report (`chapter-01`; `chapter-04`); the analogue here is: define acceptance-relevance first, then stop. **MUST NOT** keep searching to make the document longer, and **MUST NOT** begin design while a criterion has no evidence row.

## Procedure

1. Write the acceptance-relevant questions and eligibility rule for sources.
2. Pin revisions and hashes; open the decision records and applicable source files.
3. Extract claims with citations and labels into the table.
4. Check prior-agent claims against pinned source; downgrade or reject with a citation.
5. Apply the stop rule; list open questions as PLANNED/UNKNOWN with an owner.

## Done when

- Every table row has an ID, a label and a resolvable `file:line` or exact URL.
- Every acceptance criterion maps to at least one row; contradictions have a recorded resolution.
- Revisions, artifact sha256, backend protocol identities and access dates are recorded.
- No implementation code was copied and no source file was edited.
- Unreproduced or unsourced material is labelled UNKNOWN or PENDING_INDEPENDENT_VERIFICATION.

## References

- Web (fetched 2026-11-25): https://www.cochrane.org/authors/handbooks-and-manuals/handbook/current/chapter-01 ; https://www.cochrane.org/authors/handbooks-and-manuals/handbook/current/chapter-04
- Local: `.agents/skills/xylem-source-truth/SKILL.md:14-24`; `.agents/skills/INDEX.md:70`; `AGENTS.md:37-74`; `toolchain.toml:2-20`; `docs/decisions/D-001-platform-layering.md:1-147`; `docs/decisions/D-003-platform-app-conformance.md:14-29`; `docs/decisions/D-005-lotus-port-strategy.md:28-38,103-115`; `docs/decisions/D-006-in-house-agent-skills.md:18-30`. D-00x paths are relative to the `version_2` root; other paths are worktree-relative.
