# Ten verified source patterns

1. Match `map_get` as Option: `tests/perf/reproducers/map16_lookup.xy:12-13`.
2. `map_insert` returns bool: `conformance/cases/map-i64-fast-path.xy:75-80`.
3. In-place mutation via `map_get_mut`: `conformance/cases/map-mutation.xy:23-25`.
4. No borrow across insert/remove/clear (E3102): `tests/perf/README.md:760-763`.
5. Direct indexing `*view[index]` over `vec_get`: `tests/perf/reproducers/vec_sum_bounds.xy:9-14`
   (the 387,019 vs 698,661 ns figures belong to `probe/vec_access.xy` modes 1/2,
   perf README :316-324).
6. Annotate Vec type (`vec_sum_bounds.xy:3`); the loop at `vec_sum_bounds.xy:12`
   still calls `vec_len` inside the condition, so this file does not demonstrate
   hoisting. Perf README :321, :326 and the add-only caveat at :329-331.
7. djb2 shape: `tests/perf/reproducers/djb2_bytes.xy:4-12` (XFAIL on
   `string_len_ref`); `byte_length(value)` is still called in the loop condition,
   so this file does not demonstrate hoisting.
8. Use intrinsic byte_length, not legacy probe: `tests/perf/probe/byte_length.xy:5-11,17-37`; conformance `string-byte-length-utf8.xy`.
9. Iterate via `map_entries`: `docs/language/contract.md:1694-1697`.
10. Explicit while loop instead of `std/iter` adapters on hot paths: `stdlib/src/std/iter.xy:2-18` copies/reverses.

Each pattern's cost and evidence is in `cost-map.md`. Do not apply a pattern
outside its measured context; re-verify with the current compiler.
