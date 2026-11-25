---
name: xylem-standard-library-development
description: Add and maintain Xylem standard-library modules with correct API contracts, allocation behavior, prelude integration and tests. Use when implementing a stdlib function, changing strings/collections/hash helpers, or checking how stdlib code is lowered to intrinsics.
---

# Standard library development

`stdlib/src/std/*.xy` is the canonical source; the compiler embeds a checksummed
snapshot (`scripts/generate-stdlib-embed.xy --check`, `check-stdlib-digest.xy`).
The compiler **prelude** (`compiler/src/prelude*.xy` in xylem-lang;
`crates/xylem-compiler/src/loader.rs` in xylem-rust) is separate and owns
Vec/Map/Set. Their Map layouts currently differ (four vs five vectors) — any
collection change must be mirrored and validated in both.

## API conventions (verified)

- String helpers are thin wrappers over host intrinsics (`strings.xy:1-41`,
  `:139-155`); byte algorithms are source-level (`strings.xy:45-135,166-332,335-501`).
- Intrinsics must be registered in `xylem-rust/crates/xylem-types/src/lib.rs:41-175`,
  typed in `checker/intrinsics.rs:143-179`, lowered in `compiler/src/lowering.rs:2659-2745`,
  and mirrored in self-hosted `prelude_host.xy:6-43`.
- Mark `effects [allocation]` for allocating helpers; keep pure string/byte
  helpers effect-free so LICM can hoist them (`crates/xylem-effects/src/lib.rs:104-157`).
- Return `Option`/`Result` where failure is documented; `?` works for fixed
  error shapes (`contract.md:745-755`).
- Do not assume allocation-free behavior: `concat`, `push_str`, `split`, `join`,
  `repeat`, `sha256_text` all allocate (`strings.xy`, `hash.xy:25-44`).

## Workflow

1. Specify semantics and edition; check capability matrix.
2. Implement in the owning stdlib module with documented effects.
3. Add conformance cases + torture/probe coverage; verify checksums.
4. Check intrinsic registration and both lowering paths if an intrinsic is used.
5. Run `check-stdlib-digest`, `generate-stdlib-embed.xy --check`, conformance,
   `cargo test --workspace`.
6. For performance-sensitive additions, add a paired A/B benchmark under LLVM
   release with exact identities; record allocation counts.
7. Update `docs/decisions/README.md` only for semantic/API decisions, not prose.

## References

- `../../xylem-collections-and-strings/references/api-inventory.md` — current APIs.
- `../../xylem-compiler-architecture/SKILL.md` — intrinsic registration path.
