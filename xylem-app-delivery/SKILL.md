---
name: xylem-app-delivery
description: Top-level strict delivery method for high-quality Xylem applications: ordered gates, explicit exit criteria, a delivery ledger and a STOP condition. Use when taking an app from research through integration.
trigger:
  branches:
    - when: "starting or resuming a Xylem app task"
      read: "## Ordered gates; ## Delivery ledger"
    - when: "asked to skip, shortcut or certify a gate"
      read: "## Forbidden shortcuts; ## STOP condition"
source_of_truth: "AGENTS.md, docs/decisions/D-001..D-006 and ecosystem-readiness/work_logs/phase-04-platform-design.md:185-195"
evidence_status: "No gate is PASS on self-produced evidence; claims stay PENDING_INDEPENDENT_VERIFICATION"
---

# Xylem app delivery

A delivery is a sequence of gates; a gate is real only when its exit criterion
is met and its artifact exists. **MUST** route each gate to the smallest
applicable skill. **MUST NOT** skip gates, self-certify PASS, expand scope
speculatively, duplicate an Xylem layer, or label an unrun check as passed.
Repository policy lives in `AGENTS.md`; this skill is the method, not a second
authority.

## Ordered gates

Seven gates run in this order. Each row is exit criterion → required artifact.
The route names the six app skills in this family; specialist skills give depth.

| # | Gate | Exit criterion | Required artifact | Route |
|---|---|---|---|---|
| 1 | Research | Source-of-truth map exists: exact URLs and `file:line`, existing implementation inventory, capability/limitation status, no invented facts. | Research note with citation table. | `xylem-app-research`, `xylem-source-truth` |
| 2 | Design | Layer placement and downward-only deps fixed (D-001), plugin-boundary map (D-002), conformance contract accepted (D-003 §1), data ownership and out-of-scope list stated. | Design record; plugin-boundary map. | `xylem-app-design`, `xylem-platform-api-design`, `xylem-architecture-boundaries` |
| 3 | Implementation | Diff confined to owned paths; canonical app layout; no protected path, pin change, Cargo dependency or CI file; README contract complete (D-003 §5). | Code diff + app README. | `xylem-app-implementation`, `xylem-platform-module-layout`, `xylem-platform-code-style` |
| 4 | Build | Pinned compiler and backend recorded; exact commands, exit codes and artifact sha256 captured; unrun checks listed. | Build record. | `xylem-app-build` |
| 5 | Verification | Byte-exact fixtures, positive and negative cases, named independent verifier reproduced the pinned protocol; status is not PENDING. | Evidence table + verification report. | `xylem-app-verification`, `xylem-evidence-and-claims` |
| 6 | Review | Evidence-supported review; every finding dispositioned as verified defect, hypothesis or measurement need; no speculative performance claim. | Review ledger. | `xylem-code-review`, `xylem-platform-review` |
| 7 | Integration | A004 pre-merge checklist passed; merge `--no-ff`; recorded local head equals remote head; push authorised; no CI/deploy trigger added. | Completion record with integration status. | `xylem-agent-workflow`, `xylem-review-and-integration` |

MUST complete a gate's artifact before opening the next gate. DEFAULT TO the
smallest skill set per gate via `.agents/skills/SKILL-CATALOG.md`; never load
every skill at once or mark a later gate complete early.

## Forbidden shortcuts (MUST NOT)

- MUST NOT skip a gate or reorder gates to make a deadline; a missing artifact
  means the gate did not happen.
- MUST NOT self-certify PASS: one agent's evidence is
  `PENDING_INDEPENDENT_VERIFICATION` until another agent reproduces it
  (`AGENTS.md:57-63`).
- MUST NOT add speculative scope, features outside the work order, or a second
  Xylem layer: no duplicate UI model, capability/plugin system, CLI/LSP,
  distribution layer or Lotus runtime (`docs/decisions/D-001-platform-layering.md:136-141`;
  `docs/decisions/D-002-plugin-centric-platform.md:9-12`;
  `docs/decisions/D-005-lotus-port-strategy.md:188-203`).
- MUST NOT label an unrun check as passed, quote a partial pass as PASS, or
  invent a performance number; no benchmark, CI or push from this campaign
  (`docs/decisions/D-003-platform-app-conformance.md:24-29`; `AGENTS.md:66-74`).
- MUST NOT add status, briefing, dispatch, handover or duplicate work-log
  documents beyond the documented surfaces; a protected-area defect uses the
  `XY-NNNN` handover form (`xylem-agent-workflow:33-35`), not a new document
  class (`ecosystem-readiness/AGENTS.md`; D-003 §5).

## STOP condition

MUST STOP the delivery at the first gate whose exit criterion fails, whose
artifact is missing, whose protected path changed, or whose verifier reports a
mismatch. On STOP: record the failing command, exit code, artifact hash and gate;
file a handover for L0/L1 faults; do not continue or work around. Resume only
after re-running the gate from its artifact. Research/evidence still needs
reproduction but no performance test (`AGENTS.md:74`).

## Delivery ledger (MUST)

MUST keep one ledger row per gate:
`gate | route skill | exit criterion | artifact path | status | evidence ref | verifier | STOP?`.
Status uses VERIFIED / MEASURED / INFERRED / HYPOTHESIS / PLANNED / UNKNOWN or
`PENDING_INDEPENDENT_VERIFICATION`. A gate with no artifact is `NOT RUN`, never
PASS. MUST include an explicit STOP field recording whether the condition fired
and, if so, the handover id. The ledger travels with the completion record.

## Done when

- [ ] All seven gates have a ledger row with artifact path, evidence and status.
- [ ] Each gate was routed to its named app skill and specialist skill set.
- [ ] Build record and evidence table exist and cite pinned identities and hashes.
- [ ] No protected path, duplicate layer, speculative scope or unrun pass exists.
- [ ] An independent verifier signed gates 5-7; no claim remains PENDING.
- [ ] STOP condition was evaluated and recorded; integration head is recorded.

## References

- https://slsa.dev/spec/v1.0/requirements — consistent process and distributed provenance for released artifacts.
- https://semver.org/spec/v2.0.0.html — released versions are immutable; changes ship as new versions.
- https://csrc.nist.gov/pubs/sp/800/218/final — SSDF release-integrity and verification practices.
- https://docs.github.com/en/get-started/using-github/github-flow — review, merge and delete branch discipline.
- Local: `AGENTS.md:37-63,66-96,156-162`; `docs/decisions/D-001-platform-layering.md:136-147`; `docs/decisions/D-002-plugin-centric-platform.md:9-12`; `docs/decisions/D-003-platform-app-conformance.md:9-29,58-64`; `docs/decisions/D-004-product-surface.md:41-55`; `docs/decisions/D-005-lotus-port-strategy.md:188-203`; `docs/decisions/D-006-in-house-agent-skills.md:18-37`; `ecosystem-readiness/work_logs/phase-04-platform-design.md:185-195`.
