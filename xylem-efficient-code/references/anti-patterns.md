# Xylem performance anti-patterns (source-observed mechanisms)

Each entry states the mechanism and owner. All are PENDING_INDEPENDENT_VERIFICATION.
Timings are Cranelift/dev diagnostics or dev-host Callgrind instruction shares;
LLVM release parity is unmeasured. Numbers cite their source record.

1. **Boxed temporary in a hot loop** — managed temp gets an `AValue` cell;
   inline `cell_get_fast`/`cell_set_fast` avoid a call only for direct/empty
   slots. Owner: representation (`xylem-llvm/src/repr.rs`); the fast paths are
   Cranelift/dev (`xylem-native/src/cranelift_full.rs:5710-5785`, `analyse_temps`
   at `:1004`) while LLVM release still emits helper calls
   (`full_lower.rs:303-336`). Evidence: Callgrind IR instruction-share census
   `a_cell_set` 5.55% in map-flat
   (`docs/development/performance-execution-record.md:1353-1356`,
   `checklist-slice-2026-11-22`, `--read-inline-info=yes`).
2. **`vec_get`+Option in traversal** — leaves `variant`, bounds branch,
   borrow/load per element (387,019 vs 698,661 ns/4096 pass,
   `tests/perf/README.md:316-326`, mode 1/2 of `probe/vec_access.xy`). Owner:
   source can avoid (direct index); compiler should scalarize wrapper.
3. **`vec_len` in loop condition** — repeated call/instruction; 308,594 vs
   199,219 ns/pass (`tests/perf/README.md:321,326`). The add-only mode is not a
   usable floor (Rust folds it; `:329-331`). Owner: source hoist / compiler LICM.
4. **Map lookup in a loop without caching** — ~3 allocations/lookup, hash/index
   boxing (`tests/perf/README.md:782-790`, compiler `cd5d4415...`, host
   `ff7b7018...`; 3.15→0.03 uses the unlanded patch
   `docs/development/patches/llvm-raw-key-hash.patch`). Owner: runtime/backend
   raw-key-hash patch; source can reduce lookups.
5. **`map_remove` on repeated reinsert** — historically nondeterministic
   checksums from generic values-handle recycling (pre-revert shape,
   `findings/001.md:5,15`); the current Rust host prelude uses the owned-`MapEntry`
   form at `loader.rs:544-553` (`remove_entry_at`). BLOCKED at program level
   (`AGENTS.md:44-49`, `SYNTHESIS.md:29` V01); no speedup claim.
6. **String concat in a loop** — prefix recopy; `string-ops` ~9× C
   (`cost-map.md:5-12`, `tests/perf/README.md:332-339`). Owner: stdlib
   builder/compiler.
7. **`byte_length` per byte in hash/compare** — `djb2_bytes` XFAIL on
   `string_len_ref` in ASCII fast path. Owner: stdlib/lowering; hoist in source.
8. **`std/iter` adapter chains in hot loops** — `reverse`/`map` drain into new
   Vecs (`iter.xy:2-18`). Owner: source; write explicit while loop.
9. **Aggregate copies across function boundary** — non-scalar crosses call →
   `Repr::Managed`, runtime cell. Owner: ABI/compiler; keep helpers scalar-only.
10. **Shared mutable containers** — COW `a_unshare` shallow-clones children
    under lock (`cranelift_runtime.c:1935-2038`, function at `:1935`). Owner:
    runtime/ownership model.
11. **Path-reference field borrows** — `a_ref_append_segment` path nodes
    (8.95% in the same Callgrind IR instruction-share census,
    `performance-execution-record.md:1354`). Owner: backend direct-slot lowering.
12. **Checked arithmetic trap paths in hot loop** — guards are semantic;
    keep them on the cold path and use range proofs, never delete checks.
13. **Named-payload enum pattern mismatch** — brace variants E3020; use
    positional variants to avoid rejected code, not for performance.
14. **Frozen-edition feature use** — `extern "C"`, `Vec.new()`, macros, bare
    `dyn` are rejections in 2026; check `xylem.toml` before assuming support.

Do not avoid useful high-level features universally; the long-term goal is for
the compiler to handle them efficiently. Record compiler-level fixes instead of
normalizing overhead as an unavoidable language property.
