# Collection and string API inventory (verified source)

- `stdlib/src/std/collections.xy:2,6,17` — only `sum3/max3/contains3`; no Vec/Map/Set.
- Prelude Vec: `xylem-rust/crates/xylem-compiler/src/loader.rs:221-260` (vec_new/len/push/pop/get/get_mut/remove).
- Prelude Map: `loader.rs:265-516` (new, buckets, index rebuild, find, insert, get/get_mut, contains, remove, clear). Five parallel vectors `keys/values/hashes/links/buckets` at `:208-214`.
- Prelude Set: `loader.rs:532-613` (new/len/is_empty, linear find at `:546-568`, contains/insert/remove/entries/clear).
- Self-hosted mirror: `xylem-lang/compiler/src/prelude_unit.xy:24-39` uses FOUR vectors (`entries: Vec<MapEntry<K,V>>`, hashes, links, buckets) — NOT byte-identical to loader.rs. Any Map fix must be mirrored in both.
- Strings: `stdlib/src/std/strings.xy` — 40 public functions; intrinsics at `:1-41` and `:139-155`, source algorithms at `:45-135,166-332,335-483,485-501` (`pad_start`/`pad_end` included).
- Strings: `stdlib/src/std/strings.xy` — 40 public functions (verify with
  `grep -c '^pub fn ' stdlib/src/std/strings.xy`); intrinsics at `:1-41` and
  `:139-155`, source algorithms at `:45-135,166-332,335-483,485-494` (the range
  must include `pad_end` at `:494`).
- Hash: `stdlib/src/std/hash.xy:25,36` — `sha256` intrinsic + `sha256_text`; hex encoding uses repeated concat.
- Intrinsic registry: `crates/xylem-types/src/lib.rs:41-175`; `__vec_*` lowering `xylem-compiler/src/lowering.rs:2659-2703`; self-hosted prelude indices `compiler/src/prelude_host.xy:6-22`.
- Contract: `docs/language/contract.md:3364-3370` (collections are prelude), `:1694-1713` (map_entries; NOTE `:1708-1713` is stale — it claims O(n) scan, but loader.rs has bucketed lookup per ADR-0016).
