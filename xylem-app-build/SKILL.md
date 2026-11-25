---
name: xylem-app-build
description: Compile and build a Xylem application rigorously with a pinned compiler, bounded subprocesses and a hash-identified artifact. Use before claiming an app is built or when triaging a build failure.
trigger:
  branches:
    - when: "building or rebuilding a Xylem app"
      read: "## Pinned toolchain; ## Build record"
    - when: "a build fails"
      read: "## Failure triage"
source_of_truth: "toolchain.toml, ecosystem-readiness/tools/verify_lotus_contract_phase.sh and the app's own manifest and README"
evidence_status: "One-agent build records are PENDING_INDEPENDENT_VERIFICATION"
---

# Xylem app build

A build is not "it compiled"; it is a reproducible record tying one source
revision to one hash-identified artifact through one exact invocation.
**MUST** treat the pinned artifact, never a PATH binary or a fresh local build,
as the compiler. **MUST NOT** guess flags, reuse a stale output, or edit the
compiler to make an app build. This skill owns the application build slice; it
executes repository policy in `AGENTS.md` and is not a second authority.

## Pinned toolchain (MUST)

1. MUST read `toolchain.toml:2-13` and export the exact identities the project
   harness uses: `XYLEM_BOOTSTRAP` (artifact `xylem.previous-7082acd9`, sha256
   `7082acd9…`, source revision `5ff0ba2a…`), `XYLEM_BACKEND_HOST` (sha256
   `2e2d75fb…`, revision `7fe37434…`) and `XYLEM_STDLIB_ROOT`
   (`ecosystem-readiness/tools/verify_lotus_contract_phase.sh:8-13`). MUST
   record resolved absolute paths and `sha256sum` of both binaries *before*
   the first command. MUST NOT substitute a locally built binary, an unpinned
   host or an inherited environment variable.
2. MUST use the exact manifest and target from the app's own `xylem.toml` and
   `README.md` (entry `src/main.xy`, test directory, expected-output path).
   MUST use only canonical subcommands `check`, `test`, `run` and the project
   gate `<artifact> test <dir>` (`verify_lotus_contract_phase.sh:28-46`). For a
   release build MUST select `--backend llvm --release`: LLVM is the current
   release backend and Cranelift is development-only (`AGENTS.md:25-33`).
   MUST NOT invent flags, change pins, or relabel a Cranelift build as LLVM.
3. For identity, lockfiles, generated sources and environment constraints,
   defer to `xylem-toolchain-provenance` and `xylem-reproducible-builds`;
   this skill does not restate their procedure.

## Bounded invocation and capture (MUST)

MUST wrap every subprocess in an explicit timeout (the harness uses `timeout 90`
for `check`/`test` and `timeout 120` for the project gate:
`verify_lotus_contract_phase.sh:32,36,42`). MUST run one build at a time on a
quiet host. MUST NOT start full LLVM/Cranelift suites, fuzz campaigns,
competing builds, CI or pushes during an ordinary app build
(`AGENTS.md:156-162`; `xylem-platform-testing:36`). For reproducible output,
DEFAULT TO a clean, isolated output directory and a fixed `SOURCE_DATE_EPOCH`
derived from the source revision when the build embeds timestamps
(https://reproducible-builds.org/specs/source-date-epoch/). Resource limits and
process concurrency follow `xylem-resource-aware-builds`.

MUST capture verbatim for each command: full command line, exported
environment, working directory, stdout, stderr and exit code. MUST hash every
produced artifact (binary, bundle, report) with `sha256sum` and record its
path. MUST distinguish byte-for-byte reproducibility from semantic
equivalence: if a second build differs, label the cause `INFERRED` until
investigated, never `VERIFIED` (`xylem-reproducible-builds`). MUST NOT keep or
report an output from an earlier revision: delete stale artifacts before
building and fail if the artifact path already exists with an unexpected hash
(`xylem-toolchain-provenance`). DEFAULT TO a fresh output path per source
revision rather than overwriting in place.

## Failure triage (MUST)

MUST triage from the compiler diagnostic, not by changing the compiler:
classify syntax/parse errors, type and effect errors (for example `E3019` on
function-valued struct fields, `xylem-platform-app-archetypes:74`),
unsupported features and environment/dependency failures. MUST record the
minimal reproducer and exact stderr; use `xylem-debugging` and
`xylem-minimal-reproducer` for reduction. If the fault is in a protected L0/L1
subsystem, MUST record a `DEFECT_HANDOVERS/XY-NNNN.yaml` carrying the artifact
hash, verbatim invocation, expected versus observed behaviour, normative
reference and `suspected_subsystem` (`xylem-agent-workflow:33-35`), and stop
that line of work. MUST NOT patch compiler source, add a silent tooling
workaround, or mark a failed build as passed.

## Build record (MUST)

MUST emit a build record with one row per command:
`command | exit code | stdout/stderr digest | artifact path | artifact sha256`.
MUST list every check that was *not* run with its exact reason (shared host,
missing artifact, heavy dependency). MUST label the whole record
`PENDING_INDEPENDENT_VERIFICATION` until a second agent reproduces it
(`AGENTS.md:57-63`). A build record is an input to `xylem-app-verification`,
not a substitute for it.

## Done when

- [ ] Pinned bootstrap and backend paths, revisions and sha256 recorded; no PATH binary used.
- [ ] Exact manifest, target and canonical commands recorded; release build uses LLVM.
- [ ] Every subprocess was bounded and serial; no suite, fuzz, CI or push was started.
- [ ] All commands have verbatim output and exit codes; every artifact has a sha256.
- [ ] Unrun checks are listed with reasons; stale outputs removed.
- [ ] Failures are triaged with a reproducer and, for protected defects, a handover.
- [ ] Record is labelled PENDING until independently reproduced.

## References

- https://slsa.dev/spec/v1.0/requirements — consistent build process; provenance that identifies output by cryptographic digest.
- https://reproducible-builds.org/specs/source-date-epoch/ — fixed timestamp input for reproducible outputs.
- https://csrc.nist.gov/pubs/sp/800/218/final — NIST SSDF PS.2/PS.3 release integrity and integrity verification.
- Local: `toolchain.toml:2-13`; `ecosystem-readiness/tools/verify_lotus_contract_phase.sh:8-46,58`; `AGENTS.md:25-33,57-63,156-162`; `.agents/skills/SKILL-CATALOG.md:76-77,94`.
- Defer to: `xylem-toolchain-provenance`, `xylem-reproducible-builds`, `xylem-resource-aware-builds`, `xylem-debugging`, `xylem-minimal-reproducer`, `xylem-agent-workflow`.
