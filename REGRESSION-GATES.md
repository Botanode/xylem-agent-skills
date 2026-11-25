# Proposed Xylem regression gates

Skills are instructions; these are suggested executable checks to implement or reuse in the existing test infrastructure. Do not introduce a second CI system merely to implement this matrix. Commands and thresholds must be sourced from actual repositories and approved measurement protocols.

| Gate | Evidence required | Failure response |
|---|---|---|
| Source/spec consistency | Current revision and normative behavior, no contradictory unchecked assumptions | Resolve semantic conflict before affected implementation |
| IR validity | Verifier on changed IR and invalid-IR negative tests | Reject malformed transformation |
| Native representation | IR/disassembly/helper inventory for representative typed paths | Investigate accidental boxing or fallback; preserve intended dynamic paths |
| ABI and layout | Cross-call, cross-module and runtime contract tests on supported targets | Reject mismatched tool or layout |
| Backend equivalence | Oracle outputs at supported optimization levels/backends | Minimize first divergent stage |
| Memory safety | Ownership tests, unsafe invariant review, applicable sanitizers | Fix or block affected scope |
| Toolchain identity | Actual executable paths, versions, hashes and source compatibility | Refuse stale/mismatched runs |
| Fixture completeness | Real driver functions, malformed-input tests and shared fixture verification | Fix consumer path; never fake output |
| Benchmark admission | Per-case oracle, protocol, build/run success and raw data | Keep case visible but exclude from valid metrics |
| Host execution | Authorization, isolation, lock, timeouts, cancellation and cleanup | Refuse safely; continue independent work |
| Performance regressions | Comparable authorized data and predeclared evaluation policy | Investigate noise/real regression, review tradeoff |
| Integrated readiness | Consumer-level acceptance evidence on integrated revisions | Reopen incomplete tasks; no self-certified readiness |

## Claim record template

```text
Task / claim ID:
Scope and acceptance criteria:
Source and tool revisions / hashes:
Implementation changes:
Verification command(s), flags, inputs:
Observed result(s) and artifact paths:
Not run / limitations:
Status (use authoritative campaign vocabulary):
Independent reviewer and evidence, if applicable:
Next action / external blocker:
```
