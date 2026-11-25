---
name: xylem-platform-review
description: Review a Xylem platform/ecosystem change against the v2 layering contract, port ownership, refusal codes, fixtures, doc gates, protected paths and verification evidence. Use when reviewing a platform design doc or Lotus contract/change; produce a severity-ranked findings table.
trigger:
  branches:
    - "task/ecosystem/*"
    - "task-lotus-*"
  signals:
    - "a platform design doc, contract, port or fixture change"
    - "a request to review before a platform gate or merge"
source_of_truth: "ecosystem-readiness/DESIGN/PERFORMANCE_GUARDRAILS.md (R1-R8 v2, A004) and docs/decisions/D-001-platform-layering.md v2"
---

# Xylem platform review

MUST review platform changes on structure and evidence, not on plausibility. MUST NOT accept a "done" or PASS claim without an independent verifier (`.agents/skills/INDEX.md:47`; `AGENTS.md:37-43`). DEFAULT TO `PENDING_VERIFICATION` for unaudited claims. For compiler/runtime changes, hand off to `xylem-code-review` (`.agents/skills/INDEX.md:25`); do not duplicate its IR/backend review here.

## Checklist (MUST mark PASS / FAIL / N_A with evidence)

- **Layer placement & downward deps (R1/R3):** MUST verify `L3 ↛ L4a`, `L4b` implements the `L4a` port with no sibling-adapter dependency, `L5` consumes `L4a` not `L4b`, `L6` uses no `L3/L1/L0`, and no runtime layer depends on `L7`; MUST list source direction separately from upward subscription flow (`PERFORMANCE_GUARDRAILS.md:34-36,165-171`). v1 `L3→L4` inversions MUST be rejected (`:74`).
- **Port ownership & API version (R2):** MUST name each consumed port with owner layer and exact version identity; MUST NOT mirror an adapter-defined type as the policy contract or expose unpublished L0/L1 internals (`:35,168-169`). MUST verify versioned identities such as `lotus.plugin/v1`, `lotus.storage/v1` (`lotus/tools/validate_lotus.py:22-35`; `lotus/tests/p1_ports.xy:60-63`).
- **Refusal codes & typed diagnostics (R6):** MUST verify malformed/unsupported input returns `UMS-REF-0048` and unknown major `UMS-REF-0009`, each in the closed known-code list; MUST NOT fabricate support or default an unknown version (`lotus/tests/l1_core_refusal.xy:29-33`; `lotus/tests/l1_core_version.xy:51-61`; `lotus/tests/l6_application_full.xy:95-97,141-225`).
- **Fixtures & verification evidence:** MUST verify each contract has paired accept/reject fixtures and a matching schema, and that the validator, its unit suite, per-test `check`/`test`, project-level `xylem test lotus` and deterministic catalog all pass (`lotus/tools/test_validate_lotus.py:190-273`; `ecosystem-readiness/tools/verify_lotus_contract_phase.sh:28-58`). MUST record pinned artifact hash, host identity and an independent verifier's identity and result before any PASS.
- **Doc gates:** MUST confirm `README.md` remains the single entry point, decisions live in `docs/decisions/`, and no handover/status/briefing/wave/dispatch/scoreboard or duplicate work-log doc was added (`ecosystem-readiness/AGENTS.md`). MUST confirm G0-G3 gates are recorded and campaign docs contain no performance number or origin claim (`PERFORMANCE_GUARDRAILS.md:205-215`).
- **Protected paths:** MUST verify no edit to L0/L1, IR/ABI version, `toolchain.toml`, runtime helpers, the protected benchmark harness or pinned artifacts; MUST file an interface request or defect handover instead (`AGENTS.md:14-20,109-115`; `PERFORMANCE_GUARDRAILS.md:41,193-203`).
- **No Rust runtime import / no duplication:** MUST keep platform code importing only `std/*`, versioned contracts and ports (`lotus/tests/p1_ports.xy:4-10`); MUST NOT import the native Rust runtime or internal ABI, and MUST NOT duplicate the Xylem toolchain, UI/CLI or distribution — consume them through versioned ports, with L7 as a delivery/developer plane (`PERFORMANCE_GUARDRAILS.md:18-19,44-58`).
- **Status honesty:** MUST label findings VERIFIED / MEASURED / INFERRED / HYPOTHESIS / PLANNED / UNKNOWN; MUST NOT advertise a future capability as production-ready (`.agents/skills/INDEX.md:48`; `PERFORMANCE_GUARDRAILS.md:190-191`).

## Output format (MUST use)

| Finding | Severity | Evidence (`file:line` / artifact) | Layer | Recommendation |
|---|---|---|---|---|

MUST rank severity as blocker / major / minor / nit and give a positive recommendation for each row. MUST end with: what is verified, what is hypothesis, what needs independent measurement, and which layer or protected subsystem owns each remaining item (`xylem-code-review` counterpart: `.agents/skills/xylem-code-review/SKILL.md:46-53`). MUST NOT report a speculative performance concern as a confirmed defect.

## Completion criteria (checkable)

- [ ] Every checklist item has PASS / FAIL / N_A plus `file:line` or artifact evidence.
- [ ] Findings table present with severity, evidence, layer and recommendation columns.
- [ ] Any protected-path finding is an interface request, with no protected file edited.
- [ ] Verification evidence includes pinned artifact hash, host identity and an independent verifier's identity/result.
- [ ] Compiler/runtime findings are handed to `xylem-code-review`; none are re-analysed here.

## References

- Local: `ecosystem-readiness/DESIGN/PERFORMANCE_GUARDRAILS.md:12-41,161-215`; `ecosystem-readiness/tools/verify_lotus_contract_phase.sh:9-58`; `lotus/tests/l1_core_refusal.xy:29-33`; `lotus/tests/l1_core_version.xy:51-61`; `lotus/tests/l6_application_full.xy:95-225`; `lotus/tests/p1_ports.xy:4-63`; `lotus/tools/validate_lotus.py:22-35`; `lotus/tools/test_validate_lotus.py:190-273`; `.agents/skills/xylem-code-review/SKILL.md:25-57`; `AGENTS.md:14-43,109-115`.
- Web: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html (source dependencies point inward); https://learn.microsoft.com/en-us/previous-versions/msp-n-p/ff650258(v=pandp.10) (layered application); https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/hexagonal-architecture.html (ports/adapters); https://martinfowler.com/articles/practical-test-pyramid.html .
