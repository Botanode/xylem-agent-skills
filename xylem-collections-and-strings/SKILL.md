---
name: xylem-collections-and-strings
description: Use Xylem's Vec, Map, Set and String APIs correctly and efficiently. Use when writing collection-heavy or string-heavy code, when a hot loop performs lookups/insertions/concatenation/scanning, or when choosing between direct indexing and prelude wrappers.
---

# Xylem collections and strings

`Vec`/`Map`/`Set` are **compiler prelude** facilities, not `std/collections`
(which only has `sum3`, `max3`, `contains3` for fixed `[i32;3]`). Strings are
`stdlib/src/std/strings.xy`, mostly thin wrappers over host intrinsics.
Every cost below is a diagnostic measurement or source observation — re-check
the current compiler before applying old advice.

## API essentials (source-observed; PENDING_INDEPENDENT_VERIFICATION)

- `vec_new()` needs an expected type: `let mut v: Vec<i64> = vec_new()`.
- `vec_get`/`vec_get_mut`/`vec_pop` return `Option`; in hot loops prefer direct
  indexing `*view[index]` with a `&Vec<T>` view (syntax example:
  `tests/perf/reproducers/vec_sum_bounds.xy:9-14`). Diagnostic (Cranelift dev),
  PENDING_INDEPENDENT_VERIFICATION: 387,019 vs 698,661 ns/4096-pass for
  `vec_get`+match. That number belongs to `tests/perf/probe/vec_access.xy`
  modes 1/2, not to the syntax example (perf README :316-324, figures at :323-324).
- `map_get` returns `Option<&V>`; `map_insert` returns `bool` (true=added,
  false=replaced); `map_get_mut` allows in-place `*cell = value`.
  (`conformance/cases/map-i64-fast-path.xy:11-14,75-80`; `map-mutation.xy:23-25`.)
- Never hold a `map_get`/`map_get_mut` borrow across `map_insert`/`map_remove`/
  `map_clear` — rejected with `E3102`.
- `map_entries` is the insertion-ordered view; do not rely on hash/bucket order.
  Aggregate keys require the struct/enum to declare `Equality` and `Hashing`
  (`E3028` otherwise). `Set` has a linear `set_find_index`, no bucket index.
- Strings: the authoritative source-level `byte_length` still scans bytes
  (`stdlib/src/std/strings.xy:386-394`); only the compiler-embedded copy forwards
  to the `string_byte_length` intrinsic
  (`xylem-rust/crates/xylem-stdlib/stdlib/std/strings.xy:391-393`). Confirm which
  copy the active compiler embeds before relying on a one-field-read cost. The
  "doubling + binary-search" shape is a legacy probe
  (`tests/perf/probe/byte_length.xy:17-37`), not the current stdlib body.
  `starts_with`/`index_of` are byte scans;
  `concat`/`push`/`join`/`repeat` copy the growing prefix; `graphemes` has no
  iterator type (only count/at/materialize).

## Hot-path rules (with evidence)

All figures below are diagnostic measurements or source observations and are
PENDING_INDEPENDENT_VERIFICATION; Cranelift/dev timings are not release results.

1. Compute `vec_len` once outside the loop; the probe measured 308,594 ns/pass
   with `vec_len` in the loop against 199,219 ns/pass for the add-only mode
   (perf README :321, :326). The source warns that the add-only mode is not a
   usable floor — Rust folds that loop to a closed form (perf README :329-331)
   — so treat the ratio as diagnostic, not a clean scalar floor.
2. Prefer direct indexing over `vec_get`+match in tight loops; the wrapper
   leaves `Option<&T>` variants + bounds branches in IR (AST report :111-132).
3. `map_get` allocates ~3 integer nodes per lookup (two from `__key_hash` +
   cast/modulo/index) — a compiler/runtime issue, not a source fix. The 3.15→0.03
   per-lookup result under LLVM uses an unlanded patch (`tests/perf/README.md:782-790`,
   compiler `cd5d4415...`, host `ff7b7018...`); use fewer lookups by caching
   results in locals when semantics allow.
4. `map_remove` — the repeated remove/reinsert probe is **deterministic on the
   working-tree runtime** (execution record §23.2,
   `docs/development/performance-execution-record.md:1688-1703`: `201837219` on
   five 2,000-iteration runs, `497806316` on five 10,000-iteration runs).
   §18.1 (`:1189-1217`) is the historic nondeterministic result, not the current
   one. The fix is still not release-certified and has no checked-in regression,
   so keep the program-level BLOCKED status (`AGENTS.md:44-49`) until that lands.
5. Hoist `byte_length` out of string loops; the `djb2_bytes` reproducer is
   XFAIL because the ASCII fast path still calls `string_len_ref`.
6. Avoid `concat` in loops; use a preallocated buffer/piece list where possible.
   `string-ops` is ~9× slower than C mainly because of prefix copying.
7. `std/iter` adapters copy/reverse (`reverse` drains into new Vec, `map` drains
   again); write an explicit `while` loop on hot paths.

## Decision rule

If a collection operation dominates, first check algorithm and lookup count,
then inspect IR/runtime calls with `xylem-pipeline-inspector`. If the cost is a
representation or helper call, it is a compiler/runtime improvement — record it;
do not silently rewrite the program into an unmaintainable form.

## References

- `references/api-inventory.md` — full API with source lines and status.
- `references/cost-map.md` — measured costs and mechanisms.
- `references/patterns.md` — 10 verified source patterns with examples.
