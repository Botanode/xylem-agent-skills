---
name: xylem-app-verification
description: Prove a Xylem application works using positive and negative fixtures, byte-exact output, pinned-compiler execution and an independent verifier before any PASS claim.
trigger:
  branches:
    - when: "verifying or certifying an app result"
      read: "## Evidence table; ## Verifier and status"
    - when: "designing fixtures or expected output"
      read: "## Fixtures; ## Byte-exact output"
source_of_truth: "ecosystem-readiness/tools/verify_lotus_contract_phase.sh, the app's expected-output report and the pinned artifacts in toolchain.toml"
evidence_status: "All self-produced verification evidence is PENDING_INDEPENDENT_VERIFICATION"
---

# Xylem app verification

Verification proves behaviour, not that a build finished. **MUST** execute the
app under the pinned compiler and require an independent verifier before any
PASS, "works" or "done" claim. **MUST NOT** derive a performance or benchmark
claim from this campaign, and **MUST NOT** self-certify. This skill owns the
application verification protocol; it defers to the named specialists for
depth and executes, rather than restates, `AGENTS.md` policy.

## Fixtures (MUST)

MUST include at least one positive fixture and one negative fixture for every
accepted input shape. Every accepted contract major or capability MUST have a
matching refusal case with a registered code: unknown majors and malformed ids
map to `UMS-REF-0009` / `UMS-REF-0048`
(`ecosystem-readiness/tools/verify_lotus_contract_phase.sh` protocol as
specialised by `xylem-platform-testing:28`; `docs/decisions/D-005-lotus-port-strategy.md:194-196`).
MUST assert refusals are in the closed known-code list and MUST prove
non-vacuity where a validator is involved: a mislabelled fixture and a wrong
`$id` MUST be rejected and the `--catalog` output MUST be deterministic
(`xylem-platform-testing:28,42-44`). DEFAULT TO the deterministic in-memory
stubs of `xylem-platform-app-archetypes:29-36`; MUST NOT open sockets, read a
real clock/RNG or add host adapters to obtain a test signal. For test quality
rules defer to `xylem-test-design`.

## Byte-exact output (MUST)

MUST store expected stdout in `expected-output/report.txt` and require
`diff -u expected-output/report.txt actual.txt` to be clean; stdout, stderr and
status MUST be byte-identical, not merely "rc 0"
(`xylem-platform-app-archetypes:70`; `xylem-platform-testing:21,28`). MUST use
exact-string helpers such as `same(actual, expected)` in `lotus/tests/l1_core_contract.xy:7-9`
and byte-preserving comparison semantics (the `--strict-whitespace` principle
in https://llvm.org/docs/CommandGuide/FileCheck.html). MUST NOT regenerate
expected output to follow a changed program without a recorded contract change.
Where an exact oracle is unavailable, MUST add a metamorphic relation: derive a
follow-up case from a passing case and assert the invariant, labelling both the
relation and its transformation (Chen, Cheung & Yiu,
https://arxiv.org/abs/2002.12543; worked relations in
`xylem-platform-testing:30-33`). Reference outputs and hashes are the
correctness contract, as in https://llvm.org/docs/TestSuiteGuide.html.

## Consumer-level and pinned execution (MUST)

MUST verify through the app's real consumer path, not only module-level units:
run `check` then `test` on each `tests/*.xy`, the project gate `<artifact> test <app>`
and an actual `run` against the committed fixture
(`verify_lotus_contract_phase.sh:28-46`; `xylem-platform-testing:18-25`). MUST
emit `RESULT: PASS` only when `fail == 0`; otherwise FAIL, with no partial pass
(`verify_lotus_contract_phase.sh:58`). MUST use the same pinned bootstrap,
backend host and stdlib identities recorded by `xylem-app-build` and record the
backend used; MUST NOT verify with a different compiler or relabel a
development backend as LLVM (`AGENTS.md:25-33`). MUST keep timed samples,
benchmark suites and performance claims out of this campaign
(`AGENTS.md:66-74,156-162`; `docs/decisions/D-003-platform-app-conformance.md:24-29`).

## Evidence table and verifier (MUST)

MUST produce an evidence table with one row per check:
`command | exit code | stdout/stderr (verbatim or digest) | expected artifact | status`.
MUST label each status VERIFIED / MEASURED / INFERRED / HYPOTHESIS / PLANNED /
UNKNOWN, or `PENDING_INDEPENDENT_VERIFICATION` for unaudited evidence
(`.agents/skills/INDEX.md:64-71`). MUST name one independent verifier who
re-runs the pinned protocol and records its own identity, commands and result
before any PASS (`AGENTS.md:57-63`; `xylem-agent-workflow:49-51`). MUST keep
negative evidence and skipped checks visible; MUST NOT call unit tests
end-to-end verification or extrapolate one fixture to suite parity
(`xylem-evidence-and-claims`). Findings are dispositioned with
`xylem-code-review`; differential and metamorphic depth lives in
`xylem-differential-testing` and `xylem-property-and-fuzz-testing`.

## Done when

- [ ] Every positive shape has a negative fixture with a registered refusal code.
- [ ] Byte-exact diff is clean for stdout, stderr and status; no expected file was rewritten silently.
- [ ] At least one labelled metamorphic relation or exact oracle covers each un-oracled path.
- [ ] check, test, project gate and consumer run all exited 0 under the pinned compiler.
- [ ] Evidence table lists command, exit code, output and honest status for every check.
- [ ] A named independent verifier reproduced the protocol and recorded identity + result.
- [ ] No benchmark, timing or performance claim appears in the report.

## References

- https://llvm.org/docs/CommandGuide/FileCheck.html — strict-whitespace, byte-preserving expected-output comparison.
- https://llvm.org/docs/TestSuiteGuide.html — reference outputs and hashes as correctness contracts.
- https://arxiv.org/abs/2002.12543 — metamorphic relations and follow-up transformations.
- Local: `ecosystem-readiness/tools/verify_lotus_contract_phase.sh:8-58`; `AGENTS.md:25-33,57-74,156-162`; `docs/decisions/D-003-platform-app-conformance.md:24-29`; `docs/decisions/D-005-lotus-port-strategy.md:194-196`.

- Defer to: `xylem-platform-testing`, `xylem-test-design`, `xylem-evidence-and-claims`, `xylem-code-review`, `xylem-differential-testing`, `xylem-property-and-fuzz-testing`, `xylem-agent-workflow`.
