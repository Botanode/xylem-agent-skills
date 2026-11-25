---
name: xylem-app-implementation
description: Write Xylem application source under strict delivery method - smallest coherent end-to-end change, one canonical implementation, pinned-compiler idioms, explicit effects and Result/refusals, incremental checks, deterministic output and an evidence-bearing completion record with the exact check command and output.
---

# Xylem app implementation

This skill owns the **implementation slice of app delivery**. Syntax belongs to `xylem-language` (`.agents/skills/xylem-language/SKILL.md:15-44,77-86`); source conventions to `xylem-platform-code-style` (`:17-120`); file placement to `xylem-platform-module-layout` (`:34-115`); the pinned test protocol to `xylem-platform-testing` (`:18-49`); ownership and handover to `xylem-agent-workflow` (`:23-73`). Requirements come from `xylem-app-design`; facts from `xylem-app-research`. Policy lives in `AGENTS.md:57-74`; this skill executes it.

## Change shape (MUST)

**MUST** land the smallest coherent end-to-end unit first — one contract, one injected port and one accept/reject fixture pair — before adding a second family or feature. **MUST** have exactly one canonical implementation of each behavior and **MUST** extend an existing module or API instead of creating a parallel one. **MUST NOT** add a second parser, refusal vocabulary, compatibility predicate, UI model or adapter; **MUST NOT** edit protected L0/L1 paths, toolchain pins, Cargo dependencies or CI files (`.agents/skills/xylem-platform-orientation/SKILL.md:77-85`; D-005:28-38; D-004:46-55).

## Pinned-compiler idioms (MUST)

**MUST** use the pinned bootstrap artifact (version 1.0.0, source `5ff0ba2a…`, sha256 `7082acd9…`, `toolchain.toml:2-7`) and backend host pin (`:9-13`), recording the artifact identity with every check. **MUST** check the `xylem.toml` edition and construct status before writing syntax (`.agents/skills/xylem-language/SKILL.md:77-86`). On that pin: declare exact effect rows; copy a function-valued field to a local before calling (direct `port.field(...)` is `E3019`); bind Vecs with an explicit type; take `&String` for reads and use `concat_ref` for borrowed inputs; prefer exhaustive expression-form `match` (`.agents/skills/xylem-platform-code-style/SKILL.md:34-86`). **MUST NOT** invent syntax, emit an unapproved host intrinsic, or "work around" a rejected construct.

## Effects, refusal and determinism (MUST)

**MUST** declare every effectful function's row capability-first with `allocation` last, and **MUST** propagate an injected function's row unchanged. **MUST** return `Result<T, Refusal>` from every fallible boundary with a canonical registered code and all envelope fields (`.agents/skills/xylem-platform-api-design/SKILL.md:22-33`). **MUST** produce byte-identical stdout for identical fixtures: no real clock, RNG, socket, GPU or host randomness; deterministic SHA-256-derived correlation ids where a refusal envelope is used (`refusal.xy:34-52`). **MUST NOT** default an unknown major, use a trap or panic for validation, or remove checked arithmetic and bounds to win a check (`.agents/skills/xylem-efficient-code/SKILL.md:76-79`).

## Incremental compile (MUST)

**MUST** run `xylem check <file> --json` after each coherent unit and record the exact command, exit code and diagnostics before making the next edit. **MUST** fix diagnostics from pinned source rather than changing the pin; **MUST NOT** batch unverified edits or report a check that was not executed. Use focused checks during implementation and record any skipped check with its reason; **MUST NOT** start full LLVM/Cranelift suites, competing benchmarks, builds or CI on a shared host (`AGENTS.md:156-162`). One agent's evidence is `PENDING_INDEPENDENT_VERIFICATION` until another agent reproduces it (`AGENTS.md:57-63`; `.agents/skills/xylem-agent-workflow/SKILL.md:49-59`).

## Comments and workarounds (MUST)

**MUST** write comments that state the contract, failure mode or rationale; **MUST NOT** restate code or leave commented-out code (`.agents/skills/xylem-platform-code-style/SKILL.md:88-95`). A defect in a protected subsystem **MUST** become an `XY-NNNN` handover with a verbatim reproducer, not a silent local workaround (`.agents/skills/xylem-agent-workflow/SKILL.md:33-35`).

## Completion record (MUST)

**MUST** end with a record containing: the exact build/check command and its **verbatim output** (stdout/stderr, exit code, artifact sha256, backend host); files changed; accept/reject fixtures and byte-exact output comparison; skipped checks with reasons; protected-path diff count (must be 0); status labels; and the independent verifier's identity or `PENDING_INDEPENDENT_VERIFICATION`. **MUST NOT** mark a milestone complete on an unexecuted command. Keep the three milestones distinct — implemented, proven correct, demonstrated improvement (`AGENTS.md:76-86`) — and state explicitly which one the record reaches; a passing `check` alone proves only the first.

## Done when

- The end-to-end unit checks with rc 0 under the pinned artifact, whose hash is recorded.
- Every fallible boundary returns a canonical `Result` with explicit effects; no fabricated API or silent workaround remains.
- Output is byte-exact against the checked-in expected report; negative fixtures still refuse.
- The completion record quotes the actual check command and output, with exit code and verifier status.

## References

- Web (fetched 2026-11-25): https://google.github.io/styleguide/ ; https://www.sei.cmu.edu/library/sei-cert-coding-standards-wiki ; https://www.ietf.org/rfc/rfc2119.txt ; https://llvm.org/docs/CommandGuide/FileCheck.html
- Local: `toolchain.toml:2-20` ; `AGENTS.md:57-74,76-86,156-162` ; `docs/decisions/D-005-lotus-port-strategy.md:28-38` ; `ecosystem-readiness/docs/decisions/D-004-product-surface.md:46-55` ; `.agents/skills/xylem-platform-orientation/SKILL.md:77-85` ; `.agents/skills/xylem-language/SKILL.md:15-44,77-86` ; `.agents/skills/xylem-platform-code-style/SKILL.md:17-120` ; `.agents/skills/xylem-platform-module-layout/SKILL.md:34-115` ; `.agents/skills/xylem-platform-api-design/SKILL.md:22-33` ; `.agents/skills/xylem-platform-testing/SKILL.md:18-49` ; `.agents/skills/xylem-agent-workflow/SKILL.md:33-73` ; `lotus/contracts/refusal.xy:34-52`.
