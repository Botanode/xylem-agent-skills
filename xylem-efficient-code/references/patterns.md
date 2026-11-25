# Efficient Xylem source patterns

Labels: MEASURED (experiment recorded), VERIFIED (source/instruction evidence),
INFERRED (reasoning from compiler structure), HYPOTHESIS (unmeasured).

## P01 — Direct vector indexing (MEASURED)
Inefficient: `if let Option.Some(x) = vec_get(&v, i) { total += *x }` in a loop.
Preferred: `let view: &Vec<i64> = &v; while i < vec_len(view) { total = (total + *view[i]) % M; i += 1 }` (combine with P02 for the hoisted form)
Evidence: 698,661 vs 387,019 ns/4096 pass (tests/perf/README.md:323-324; modes 1–2). Reproducer: `tests/perf/reproducers/vec_sum_bounds.xy:9-14`.
Equivalence: same values and OOB behavior; direct indexing still traps R6004.

## P02 — Hoist vector length (MEASURED)
Move `vec_len` out of the loop condition. In-loop measured 308,594 vs 199,219 ns/pass scalar floor (tests/perf/README.md:321-326; modes 4 and 6). Compiler LICM exists but is blocked by mutable reborrows in some shapes.

## P03 — Cache map lookups (MEASURED)
Each `map_get` allocates ~3 integer nodes and costs ~11-19 µs in diagnostics. If the same key is needed twice, bind the result once. Do not hold the borrow across mutation (E3102).

## P04 — In-place aggregate mutation (VERIFIED)
Use `map_get_mut` with `*cell = value` (`conformance/cases/map-mutation.xy:23-25`) instead of remove+insert; map_remove is blocked by an ownership bug.

## P05 — Avoid `map_remove` (VERIFIED blocker)
Repeated remove/reinsert is nondeterministic (execution record §18.1). Use a fresh table or rebuild if semantics allow; record the limitation.

## P06 — Hoist byte_length (MEASURED/VERIFIED)
The authoritative seed `byte_length` is a `string_len_ref` + byte-scan loop (`stdlib/src/std/strings.xy:386-394`), not a one-field-read intrinsic; the single-intrinsic form exists only in the Rust-hosted stdlib copy. Calling it per byte still costs, so hoist. `djb2_bytes` XFAILs on `string_len_ref` in the ASCII fast path (`tests/perf/reproducers/cases.txt:27`).

## P07 — Avoid concat in loops (MEASURED)
`string-ops` 193,298 vs C 21,186 ns/op (tests/perf/README.md:303); prefix recopy. Accumulate pieces or preallocate where the API allows.

## P08 — Avoid std/iter adapters on hot paths (VERIFIED)
`reverse` drains via `vec_pop` into a new Vec; `map` drains again (`stdlib/src/std/iter.xy:2-18`). Write an explicit while loop.

## P09 — Scalar-only kernels (MEASURED)
Keep hot data in `i32/i64`; `u64/usize` and floats go through the full-value/boxed path. `int-arithmetic` reached 114% of Rust after direct lowering; scalar floor 0.951× Rust with checks retained.

## P10 — Bound arithmetic to avoid trap paths (VERIFIED)
Overflow traps R6002. Modulo reduction keeps intermediates in range; the cold trap path must remain for out-of-range inputs.

## P11 — Small leaf helpers (MEASURED)
speed build inline vs size build call: 58,000 vs 957,000 ns for inline-leaf (tests/perf/README.md:266-267). Avoid `--opt-level size` in release.

## P12 — Annotate Vec types (VERIFIED)
`vec_new()` needs an expected type (`let mut v: Vec<i64> = vec_new()`); `Vec.new()` rejected E2001.

## P13 — Struct field literals need typed values (VERIFIED)
`Pair { left: 20 as i64, right: 22 as i64 }` (`tests/perf/reproducers/shared_struct_calls.xy:11-16`); unsuffixed 20 defaults i32 and may mismatch.

## P14 — Effects rows are mandatory (VERIFIED)
`effects [allocation]` for vec users, `[process, external]` for I/O; missing row E4001. Declare the narrowest correct row.

## P15 — Match exhaustively (VERIFIED)
`match` requires all variants or `_` (E3010); guards do not count. Use `_` deliberately so behavior is explicit.

## P16 — Avoid borrow across mutation (VERIFIED)
`E3102` for holding `map_get`/`map_get_mut` borrow across insert/remove/clear; structure code to end the borrow first.

## P17 — Slices over references for traversal (VERIFIED)
`&[T]` is copy, `&mut [T]` is not (`contract.md:395-404`); use shared slices for read-only hot traversal.

## P18 — SHA/text hashing avoid per-byte Vec construction (VERIFIED)
`sha256_text` builds a Vec<i32> byte-by-byte and hex builds via concat (`hash.xy:25-44,11-16`); prefer hashing an existing buffer when semantics allow.

## P19 — Map insertion returns bool (VERIFIED)
`true` = added, `false` = replaced (`map-i64-fast-path.xy:75-80`); use it to avoid a second lookup when branch behavior permits.

## P20 — Measure before complicating code (HYPOTHESIS guard)
Many source-level "optimizations" (manual unrolling, bit tricks) have no Xylem measurement. Treat them as hypotheses; run paired A/B under the LLVM release backend before adopting.

Repository references: xylem-lang/tests/perf/README.md, results/compiler-{ast,intern}.md,
xylem-rust/docs/performance-parity.md, docs/development/performance-execution-record.md.
All patterns PENDING_INDEPENDENT_VERIFICATION until reproduced by another agent.
