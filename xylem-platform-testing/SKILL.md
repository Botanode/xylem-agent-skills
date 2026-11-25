---
name: xylem-platform-testing
description: Verify Lotus/Xylem platform contract changes with the pinned compiler; add byte-exact tests, negative fixtures, metamorphic checks and validator tests. Use when adding or changing a platform .xy test, schema/fixture or validator, or before claiming a platform gate is PASS.
trigger:
  branches:
    - "task/ecosystem/*"
    - "task-lotus-*"
  signals:
    - "new or changed lotus/tests/*.xy, lotus/schemas or lotus/fixtures"
    - "a PASS / verified / green claim about a platform contract"
source_of_truth: "ecosystem-readiness/tools/verify_lotus_contract_phase.sh and the pinned artifacts it names"
---

# Xylem platform testing

MUST treat the pinned artifact, not the source tree, as the compiler under test. MUST NOT claim PASS on evidence you produced yourself. DEFAULT TO byte-exact, negative-inclusive, independently re-run checks. For compiler internals, defer to `xylem-testing-and-benchmarking` (`.agents/skills/INDEX.md:23`); this skill owns only the platform verification protocol.

## Pinned-compiler protocol (MUST run in this order)

1. MUST export the exact identities in `ecosystem-readiness/tools/verify_lotus_contract_phase.sh:9-13` (`XYLEM_BOOTSTRAP`, `XYLEM_BACKEND_HOST`, `XYLEM_STDLIB_ROOT`) before any command. MUST record the artifact hash (`xylem.previous-7082acd9`) and host identity; MUST NOT substitute a locally built binary or an unpinned host.
2. MUST run `check` **then** `test` for every `lotus/tests/*.xy`, each requiring rc 0 (`ecosystem-readiness/tools/verify_lotus_contract_phase.sh:28-38`). MUST preserve the final stdout line verbatim as the expected output (e.g. `l1_core_contract checks passed`, `lotus/tests/l1_core_contract.xy:67`).
3. MUST run the project-level gate `<artifact> test lotus`; a missing `lotus/xylem.toml` is a FAIL, not a skip (`ecosystem-readiness/tools/verify_lotus_contract_phase.sh:40-46`).
4. MUST run the validator and its unit suite: `python3 lotus/tools/validate_lotus.py --fixtures lotus/fixtures` and `python3 lotus/tools/test_validate_lotus.py` (`ecosystem-readiness/tools/verify_lotus_contract_phase.sh:48-53`).
5. MUST emit `RESULT: PASS` only when `fail == 0`; otherwise MUST emit FAIL (`ecosystem-readiness/tools/verify_lotus_contract_phase.sh:58`). MUST NOT report a partial pass.

## Byte-exact output and negative fixtures

MUST assert status and stderr are byte-identical, not merely rc 0 (`ecosystem-readiness/DESIGN/PERFORMANCE_GUARDRAILS.md:109-111`; `xylem-rust/crates/xylem-bench/src/bin/compile-time.rs:8-9`). DEFAULT TO exact-string helpers: `same(actual, expected)` in `lotus/tests/l1_core_contract.xy:7-9`. MUST include a negative case for every accepted shape: malformed ids, unknown majors and bad versions map to the two registered codes `UMS-REF-0048` / `UMS-REF-0009` (`lotus/tests/l1_core_contract.xy:52-65`; `lotus/tests/l1_core_version.xy:51-61`; `lotus/tests/l6_application_full.xy:95-97,141-225`). MUST assert refusal codes are in the closed known-code list (`lotus/tests/l1_core_refusal.xy:29-33`). MUST prove validator non-vacuity: a mislabelled fixture and a wrong `$id` MUST be rejected (`lotus/tools/test_validate_lotus.py:229-253`), and `--catalog` MUST be deterministic and match the checked-in catalog (`:256-273`).

## Metamorphic transformations

MUST add a metamorphic relation where an exact oracle is unavailable: derive a follow-up case from a passing case and assert the invariant (Chen, Cheung & Yiu, `https://arxiv.org/abs/2002.12543`). DEFAULT TO round-trip and structural relations already present: `as_text(from_text(x)) == x` and unknown text yields `Option.None` (`lotus/tests/l2_capability.xy:24-42`); `parse_contract_id(contract_id(f, n))` round-trips (`lotus/tests/l1_core_contract.xy:29-50`); resolved capability order MUST be stable and duplicate providers MUST be refused (`lotus/tests/l6_application_full.xy:163-225`). MUST label each relation and the transformation that produces its follow-up case.

## Status labels, verifier and forbidden work

MUST label every claim VERIFIED / MEASURED / INFERRED / HYPOTHESIS / PLANNED / UNKNOWN, or `PENDING_INDEPENDENT_VERIFICATION` for unaudited evidence (`.agents/skills/INDEX.md:46-48`; `AGENTS.md:37-43`). MUST require an independent verifier to re-run the pinned protocol and record its own identity before any PASS or "done" claim; MUST NOT self-certify. MUST NOT run full LLVM/Cranelift benchmark suites, competing benchmarks, builds, CI or pushes on a shared host (`AGENTS.md:138-142`; `PERFORMANCE_GUARDRAILS.md:100-106`).

## Completion criteria (checkable)

- [ ] Pinned artifact hash and host identity recorded; protocol steps 1-5 each show rc 0.
- [ ] Every `.xy` test has a byte-exact expected line and at least one negative case with a registered refusal code.
- [ ] At least one named metamorphic relation with its transformation is documented and passing.
- [ ] Validator, validator unit suite and deterministic catalog all pass with zero violations.
- [ ] An independent verifier has re-run the protocol and recorded identity + result; status is not PENDING.

## References

- Local: `ecosystem-readiness/tools/verify_lotus_contract_phase.sh:9-13,28-58`; `ecosystem-readiness/DESIGN/PERFORMANCE_GUARDRAILS.md:108-131`; `lotus/tests/l1_core_contract.xy:7-67`; `lotus/tests/l1_core_version.xy:37-61`; `lotus/tests/l2_capability.xy:24-42`; `lotus/tests/l6_application_full.xy:95-225`; `lotus/tools/test_validate_lotus.py:190-273`; `AGENTS.md:37-54,138-142`.
- Web: https://arxiv.org/abs/2002.12543 (metamorphic testing, Chen et al.); https://martinfowler.com/articles/practical-test-pyramid.html (test pyramid, arrange-act-assert); https://llvm.org/docs/CommandGuide/FileCheck.html (byte-exact expected output, `--strict-whitespace`, `CHECK-NOT`); https://llvm.org/docs/TestSuiteGuide.html (reference outputs and hashes verify correctness).
