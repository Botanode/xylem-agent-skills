---
name: xylem-agent-workflow
description: Operate as an in-house Xylem agent — isolated worktree and branch, ownership verification, protected areas, pinned compiler, focused verification, A004 integration gate, merge ordering, push policy, defect handover and evidence-bearing final reports. Use when dispatched to a task/ecosystem work order or when writing a completion record.
trigger:
  branches:
    - when: "starting a dispatched task or creating a worktree"
      read: "## Worktrees and branches; ## Ownership verification"
    - when: "running verification or claiming a result"
      read: "## Pinned compiler and focused verification; ## Independent verification; ## Final-report evidence"
    - when: "integrating, merging or pushing a task branch"
      read: "## A004 integration gate; ## Push policy"
    - when: "a fixture exposes a defect in a protected subsystem"
      read: "## Protected areas and defect handover"
  do_not_activate:
    - "CI, deploy or full benchmark campaigns (explicitly out of scope)"
    - "protected compiler edits (file a handover instead)"
source_of_truth: "AGENTS.md and ecosystem-readiness governance files; work orders define scope"
evidence_status: "All one-agent claims are PENDING_INDEPENDENT_VERIFICATION"
---

# Xylem agent workflow

Work happens in an isolated, owned branch and becomes real only after independent verification and A004 integration. **MUST** follow the verification rule in `AGENTS.md`; this skill executes policy and is not a second authority.

## Worktrees and branches

**MUST** start from `integration/ecosystem-readiness` in a linked worktree on `task/ecosystem/<slug>` (`git worktree add -b task/ecosystem/<slug> <path> integration/ecosystem-readiness`), using a short descriptive branch name (https://docs.github.com/en/get-started/using-github/github-flow; https://git-scm.com/docs/git-worktree). **MUST** keep the worktree clean, remove it with `git worktree remove` when done, and **MUST NOT** commit to production `main` or merge task branches into one another.

## Ownership verification

**MUST** read `ecosystem-readiness/OWNERSHIP_REGISTRY.yaml` before any shared-file edit: if a file is not in that agent's `allowed_write_paths`, do not modify it. **MUST** have a reviewed work order (`WORK_ORDERS/<agent-id>.yaml`, copied from `TEMPLATE.yaml`) before status moves off `unassigned`. **MUST** list exact owned files and verify the diff against `allowed_write_paths`; **MUST NOT** expand scope by editing a neighbouring file.

## Protected areas and defect handover

**MUST** leave protected dependencies to the compiler campaign: native representation/primitive lowering, integer machine ops, canonical IR, native ABI/layout, containers, ownership/borrowing/RC/COW, LLVM and optimizer passes, runtime architecture, benchmark harness/certification and bootstrap. **MUST** record any defect exposed by an independent fixture as `DEFECT_HANDOVERS/XY-NNNN.yaml` from `TEMPLATE.yaml`: exact compiler revision/artifact hash, invocation, minimal reproducer the receiver can run verbatim, unambiguous expected vs observed behaviour, normative `specification_reference`, `suspected_subsystem` with confidence, `discovered_by` and status. **MUST NOT** fix protected source or add a silent tooling workaround.

## Pinned compiler and focused verification

**MUST** use the pinned bootstrap compiler (currently 1.0.0, revision `5ff0ba2a…`, sha256 `7082acd9…`, from `xylem-lang/toolchain.toml`) and record its artifact identity plus the backend host. **MUST** run only focused checks during implementation — pinned `check`/`test`, Python validators, one targeted test — and **MUST** record any skipped check with its reason (shared host, missing artifact, heavy dependency). **MUST NOT** run full LLVM/Cranelift suites, workspace-wide tests, fuzz campaigns or competing benchmarks on a shared host in this campaign.

## A004 integration gate

**MUST** pass the A004 pre-merge checklist (`work_logs/archive/INTEGRATION.md`): diff limited to `allowed_write_paths`; no protected path; no change to `toolchain.toml`, `Cargo.toml`/`Cargo.lock` pins or compatibility constants; completion record states exactly which checks ran; change extends an existing file/API rather than duplicating it. **MUST** merge with `git merge --no-ff` into the integration branch, resolve conflicts in favour of the stable interface contract, and update `ecosystem-readiness/work_logs/archive/phase-02-integration-status.md`/`OWNERSHIP_REGISTRY.yaml`. **MUST** order disjoint branches first (E052, F064, G074, H077; then I091/I100; then C024/D035) and merge B016 (LSP) last because later LSP work stacks on it.

## Push policy

**MUST** leave local head equal to remote head and record the pushed hash before claiming integration; **MUST** have the integration owner authorize the push. **MUST NOT** add CI/deploy triggers, modify workflow files or publish performance claims from this campaign.

## Independent verification

**MUST** label one's own evidence `PENDING_INDEPENDENT_VERIFICATION`. **MUST** require a second agent to reproduce the artifact or measurement and record its identity and result before a box is ticked or a gain is called validated. **MUST NOT** cite a status tag or "done" claim as valid until that reproduction exists (research/evidence work still needs reproduction but no performance test).

## Work orders and completion records

**MUST** fill the work-order fields `agent_id`, `squad`, `repository`, `starting_revision`, `branch`, `objective`, `owned_files`, `allowed_write_paths`, `protected_areas`, `existing_implementation`, `required_changes`, `required_tests`, `required_verification`, `dependencies`, `acceptance_criteria`, `integration_owner`. **MUST** write a completion record with `baseline_revision`, `candidate_revision`, `files_modified`, `implemented_functionality`, `existing_infrastructure_reused`, `tests_written`, `tests_executed`, `verification_results`, `known_limitations`, `protected_areas_modified`, `compiler_interface_requests` and `integration_status`. **MUST** mark unverified items `IMPLEMENTED / PENDING_VERIFICATION` rather than claiming a pass; **DEFAULT TO** that label whenever a check was skipped or not independently reproduced.

## Final-report evidence

**MUST** include in the final report: exact commands with exit codes, pinned compiler/artifact hashes, fixture/checksum results, protected-path diff count, files changed, and verifier identity or `PENDING_INDEPENDENT_VERIFICATION`. **MUST NOT** report an unexecuted check as a pass.

## Completion criteria

- Worktree/branch match the work order; diff is inside `allowed_write_paths`; protected-path count is 0.
- Only focused checks ran; skipped checks are explained; identities and exit codes are recorded.
- Any defect in a protected area has a `XY-NNNN` handover, not a local fix.
- A004 gate passed and merge ordering was respected; local head equals remote head at a recorded hash.
- Every claimed result has evidence and an independent verifier, or is explicitly pending.

## References

- https://docs.github.com/en/get-started/using-github/github-flow — branch, review, merge, delete.
- https://git-scm.com/docs/git-worktree — linked worktrees, `add`/`remove`, per-worktree `HEAD`.
- `AGENTS.md` (verification rule); `ecosystem-readiness/OWNERSHIP_REGISTRY.yaml:1-29`; `WORK_ORDERS/{README.md,TEMPLATE.yaml}`; `DEFECT_HANDOVERS/{README.md,TEMPLATE.yaml}`; `work_logs/archive/INTEGRATION.md`; `work_logs/phase-04-platform-design.md:60-98`; `xylem-lang/toolchain.toml`.
