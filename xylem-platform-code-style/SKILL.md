---
name: xylem-platform-code-style
description: Apply Xylem platform source conventions for naming, effect rows, errors and ownership. Use when writing or reviewing .xy files in lotus/, stdlib/src/std/, examples/ or product modules, or when a convention question is not a language-syntax or performance question; defer syntax to xylem-language and measured cost to xylem-efficient-code.
disable-model-invocation: true
---

# Xylem platform source style

This file is the **single source of truth** for platform source conventions.
Syntax validity belongs to `.agents/skills/xylem-language/SKILL.md:15-44`;
measured runtime cost belongs to `.agents/skills/xylem-efficient-code/SKILL.md:34-85`.
Point to those skills instead of duplicating their rules
(`.agents/skills/INDEX.md:12,14`). Casing and conversion names follow the
Rust API Guidelines (https://rust-lang.github.io/api-guidelines/naming.html,
C-CASE / C-CONV / C-GETTER).

## Naming — DEFAULT TO role-revealing case

- **Modules and files** MUST be `snake_case`: `core.xy`, `lotus/tests/p1_ports.xy`,
  `lotus-web-consumer/`. Types, structs, enums and function-value aliases MUST
  be `UpperCamelCase`: `ContractId`, `StoragePort`, `Refusal`, `StorageRead`,
  `NowMillis` (`lotus/ports/storage.xy:13-20`; `lotus/README.md:135-140`).
- **Functions and methods** MUST be `snake_case` with a verb prefix —
  `parse_contract_id`, `port_read`, `validate_target` — and boolean predicates
  MUST start with `is_` or `has_` (`lotus/contracts/core.xy:27,57`;
  `lotus/contracts/manifest.xy:288`).
- **Constants** MUST be `SCREAMING_SNAKE_CASE` (`LIMIT`) per
  `.agents/skills/xylem-language/SKILL.md:53-55`.
- **Refusal codes** MUST be canonical `UMS-REF-*` values, never local numeric
  codes (`lotus/contracts/core.xy:41-46`).
- **Exception:** preserve upstream serialized identities verbatim — snake_case
  JSON fields and `lotus.<name>/vN` ids (`lotus/README.md:61-62`).

## Effect rows — one canonical order

- **Declare** `effects [...]` on every effectful function; pure functions omit
  the row (`.agents/skills/xylem-language/SKILL.md:25-27`, errors `E4001`–`E4003`).
- **Order** rows capability-first, `allocation` last: `filesystem`, `network`,
  `process`, `external`, `time`, `random`, `stream`, then `allocation`. Verified
  shapes: `effects [network, allocation]` (`stdlib/src/std/networking.xy:65`;
  `lotus/README.md:140`) and `effects [filesystem, allocation]`
  (`stdlib/src/std/filesystem.xy:41`).
- **Propagate** the exact row of an injected function value into the caller's
  row (`examples/lotus-web-consumer/README.md:23-28`;
  `examples/lotus-server-consumer/README.md:24-28`). MUST NOT add or drop rows
  to make a signature fit.
- **Exception:** `allocation` alone for pure string/Vec builders
  (`lotus/contracts/core.xy:17-19`).

## Errors and refusals

- **Return** `Result<T, Refusal>` from every fallible kernel boundary
  (`lotus/contracts/manifest.xy:108,222,265-270`). Construct errors only through
  `refusal(code, message, contract)` (`lotus/contracts/core.xy:41-46`).
- **Refuse** unknown contract majors, malformed ids, ambiguous providers and
  unsupported targets explicitly (`docs/decisions/D-005-lotus-port-strategy.md:194-196`;
  `lotus/contracts/core.xy:118-140`). MUST NOT substitute a default or implicit
  upgrade.
- **Use** `Result.Ok(())` for validation success and early `Result.Err(...)`
  returns (`lotus/contracts/manifest.xy:158-171`; `lotus/contracts/core.xy:75-89`).
- **Exception:** `HostError` is correct only for L2a stdlib host calls
  (`stdlib/src/std/networking.xy:22`), never for kernel validation.

## Ownership and strings — pinned-compiler idioms

All rules here are verified under bootstrap artifact sha256 `7082acd9…`
(`toolchain.toml:5-7`).

- **Borrow text**: take `&String` for read-only parameters and compare by
  reference (`same(left: &String, right: &String)`,
  `lotus/contracts/manifest.xy:33`; `lotus/contracts/graph.xy:38`). MUST NOT take
  `String` by value when only reading.
- **Return owned strings with `concat_ref`** when inputs are borrowed
  (`contract_id`, `lotus/contracts/core.xy:17-19`; `manifest.xy:126,311`).
  Reserve `concat` for combining already-owned values or literals
  (`manifest.xy:128`).
- **Bind Vecs with an explicit type**: `let mut resolved: Vec<String> =
  vec_new()` (`lotus/contracts/manifest.xy:324`; `stdlib/src/std/strings.xy:157`).
  `Vec.new()` is rejected (`xylem-language/SKILL.md:42-44`).
- **Prefer expression-form `match` arms** that produce the value directly, then
  check the bound result (`lotus/contracts/core.xy:95-102`), over mutable
  accumulators. Every `match` MUST be exhaustive (`E3010`,
  `xylem-language/SKILL.md:31-32`).
- **Copy function-valued fields to a local before calling**:
  `let reader = port.read; return reader(key)` (`lotus/ports/storage.xy:45-48`;
  `lotus/README.md:142-144`). `port.field(...)` is rejected as `E3019`.

## Comments — why, not what

MUST state the contract, the failure mode or the rationale; MUST NOT restate the
code or leave commented-out code. Verified shape:
`lotus/ports/storage.xy:1-9` explains the E3019 workaround, and
`lotus/contracts/core.xy:71-74` explains the 128-byte boundary. Keep lines under
100 characters and end files with a newline (`W7001`–`W7004`,
`docs/decisions/D-003-platform-app-conformance.md:33-35`).

## Forbidden patterns

MUST NOT call a function-valued field directly; build contract ids from raw
literals instead of `contract_id`; default an unknown major or malformed id;
use traps or panics for validation; or remove checked arithmetic and bounds to
win a benchmark (`.agents/skills/xylem-efficient-code/SKILL.md:76-79`).

## Procedure

1. Name the file's layer and apply the naming table.
2. Set the canonical effect-row order and propagate injected rows.
3. Route fallible paths through `Result<_, Refusal>` with canonical codes.
4. Apply the string/ownership idioms and run `xylem check` on the pinned toolchain.
5. Check comments explain why and the style gates pass.

*Done when* check passes under sha256 `7082acd9…`, every fallible boundary
returns a canonical `Result`, effect rows are ordered, no forbidden pattern
remains, and syntax/performance depth is delegated by path.

## References

- https://rust-lang.github.io/api-guidelines/naming.html — C-CASE, C-CONV, C-GETTER, C-WORD-ORDER.
- https://google.github.io/styleguide/ — consistent style lowers review cost.
- `.agents/skills/xylem-language/SKILL.md:15-44`; `.agents/skills/xylem-efficient-code/SKILL.md:34-85`; `.agents/skills/INDEX.md:12,14`; `lotus/contracts/core.xy:17-19,41-46,75-140`; `lotus/contracts/manifest.xy:23-33,108-171,222-270,324`; `lotus/contracts/graph.xy:38`; `lotus/ports/storage.xy:1-20,45-53`; `lotus/README.md:61-62,135-144`; `stdlib/src/std/networking.xy:22,65`; `stdlib/src/std/filesystem.xy:41`; `stdlib/src/std/strings.xy:157`; `examples/lotus-web-consumer/README.md:23-28`; `docs/decisions/D-003-platform-app-conformance.md:21-23,33-35`; `toolchain.toml:5-7`.
