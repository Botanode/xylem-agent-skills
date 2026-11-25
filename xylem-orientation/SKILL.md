---
name: xylem-orientation
description: Explain what Xylem is, why it exists, its design objectives, repository responsibilities, compiler/runtime/backend architecture, current capabilities and limitations, and where authoritative information lives. Use on first contact with the project, when asked to explain Xylem, or before working in an unfamiliar part of the codebase.
---

# Xylem orientation

Read this before making claims about Xylem. Xylem is an evolving native
systems language; do not describe it as Rust, C, Zig or Go with different syntax.

## What Xylem is

Xylem is a native compiled language whose authoritative specification and
Xylem-written compiler live in `xylem-lang`. It aims to become competitive with
mature optimizing compilers (Rust, C, C++) in generated-code performance while
preserving specified safety, trap, ownership and diagnostic guarantees. The
ambition is documented in `docs/development/PERFORMANCE.md`; the language
contract is `docs/language/contract.md` and `docs/language/grammar.ebnf`.

## Repository responsibilities

| Repository | Owns |
|---|---|
| `xylem-lang` | Language specification, Xylem-written compiler (`compiler/src/*.xy`), canonical stdlib, conformance corpus, perf registries, toolchain pins |
| `xylem-rust` | Independent Rust compiler, shared native backend/runtime, LLVM (release) and Cranelift (development) codegen, host validation |
| `xylem-platform` | UI/graphics/platform adapters only; no compiler semantics |

Do not add a compiler frontend, IR or backend to `xylem-platform`. Do not create
a second IR or backend in either compiler repository.

## Compiler and runtime model

- The Xylem compiler is itself written in Xylem; Stage 0 is the pinned Rust
  compiler. It emits canonical `xylem-bootstrap-ir/1` requests to an external
  backend host (`xylem-native/16`).
- Bootstrap: Rust compiler builds the Xylem compiler (Stage 1); Stage 1 emits
  IR for the host; self-host stages reproduce artifacts. See
  `docs/bootstrap/self_hosting.md`, `compiler/stage2-bootstrap.json` and
  `compiler/stage3-bootstrap.json`.
- The Rust implementation in `xylem-rust` is an independent compiler and the
  shared backend host; it is not a hidden semantic fallback.
- **LLVM is the release and production backend** (`--backend llvm --release`).
  Cranelift is development-only and its timings are not release results.
- The runtime uses a boxed `AValue` representation with manual reference
  counting; scalar paths promote values into machine words where possible.
  This is the dominant performance mechanism (see `xylem-performance-analysis`).

## Current capabilities and limits (verify before relying on them)

- Implemented: checked arithmetic with traps, effects clauses, ownership/drop,
  structs, enums, Vec/Map/string stdlib, generics, interfaces, modules/imports,
  interpreter and native backends, LSP/diagnostics/tooling.
- No `^` bitwise operator and no `<<` shift operator; arithmetic traps on
  overflow. See `xylem-language` skill for verified syntax.
- Concurrency status is reported inconsistently: this skill records the native
  backend as unsupported and tasks as FUTURE, while the canonical feature
  matrix (`xylem-language/references/capability-matrix.md:40`) records native
  tasks as IMPLEMENTED (dev, deterministic). Both are
  PENDING_INDEPENDENT_VERIFICATION; confirm against the backend before relying
  on either. Do not assume threads/channels/ECS exist in a release build.
- Multiple backends differ: a construct working on one may fail on another.
  Always label claims with the backend and compiler revision.
- Self-host compilation is slow (historical diagnostic `~45×` compile time for
  10× source, COMP-002, `docs/development/PERFORMANCE.md:238-240`;
  PENDING_INDEPENDENT_VERIFICATION); this is an active optimization target, not
  a language property.

## Evidence and labels

Use VERIFIED (implementation + test), MEASURED, INFERRED, HYPOTHESIS, PLANNED,
UNKNOWN. The source-of-truth hierarchy is in `SKILLS_IMPLEMENTATION_INVENTORY.md`.
When docs and implementation conflict, record both; do not silently pick the
elegant interpretation.

## Where to go next

- Writing code: `xylem-language`, `xylem-types-and-memory`, `xylem-efficient-code`.
- Compiler work: `xylem-compiler-architecture`, `xylem-compiler-optimization`,
  `xylem-pipeline-inspector`, `xylem-native-codegen` (xylem-rust).
- Performance: `xylem-performance-analysis`, `xylem-hot-paths-and-abi`,
  `xylem-collections-and-strings`.
- Environment: `xylem-tooling-and-workflows`.

## References

- `../xylem-language/references/capability-matrix.md` — canonical feature status
  (maintained from verified evidence). The repository layout is summarised in
  the "Repository responsibilities" table above; there is no separate
  repository-map file in this skill.
