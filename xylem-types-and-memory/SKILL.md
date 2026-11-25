---
name: xylem-types-and-memory
description: Understand Xylem's actual type system, value representation, allocation, copy/move/drop behavior, ownership and runtime memory management. Use when reasoning about where values live, whether code copies or allocates, how references and drops work, or how data crosses a function boundary.
---

# Types and memory in Xylem

Xylem has no GC: reclamation is deterministic, ownership-driven, with reference
counting for shared heap values. A value's representation depends on its type,
whether its address is taken, and whether it crosses an ABI boundary. All
claims below are source-verified and PENDING_INDEPENDENT_VERIFICATION.

## The value model

- **Scalar fast path**: an unboxed integer/bool/char that never has its address
  taken is a machine word (`TempRep::Int` in Cranelift, `Repr::Scalar` in LLVM).
  Arithmetic is inline with overflow guards; boxing happens only at a cell or
  ABI boundary (`xylem_rt_scalar_int_box`, `cranelift_runtime.c:11255-11257`).
- **Boxed full-value path**: generic `Vec<T>`, `Map`, `String`, aggregates that
  escape become `AValue` heap objects. `struct AValue` is defined at
  `cranelift_runtime.c:904-947` with offsets locked by assertions at
  `cranelift_runtime.c:951-955`.
- **Temporary cells**: managed temporaries live in an `AValue*` cell. Cranelift
  uses a 64-cell inline frame arena (`cranelift_runtime.c:71-88`, cell arena at
  `:2090-2105`), avoiding one allocator call per temp. LLVM uses aligned
  `alloca` slots (`xylem-rust/crates/xylem-llvm/src/full_lower.rs:6308-6346`).
- **References**: non-owning refs are tagged direct slots (`cell | 1`, scalar
  slot `| 3`, `cranelift_runtime.c:1040-1065`); owning/path refs are heap
  `AValue(A_REF)` objects (`a_ref_append_segment`, `cranelift_runtime.c:3393`).
  Keep borrows local/shared to avoid path-node allocation.
- **Strings**: interned `AValue(A_STRING)` pool (`cranelift_runtime.c:2526`,
  cache `:2546-2560`);
  cache entries own one reference. `String` is length-aware UTF-8.
- **Drops**: `a_drop` → `a_free_value` recursively releases by tag
  (`cranelift_runtime.c:4371-4377,1691-1746`); drops run in reverse declaration
  order on normal scope exit/return/break/continue/`?`. A trap tears down active
  frames and releases their owned storage and refcounts; it does not execute user `Drop` hooks
  for unwound frames (`contract.md:905-918`;
  `cranelift_runtime.c:733-742,1777-1804,1827-1831`; ADR-0042).

## Copy, move, borrow (source rules)

- Copy iff every field/element is copy; `String`, `&mut T`, `Vec<T>`, `Map`,
  `Set` are not (`contract.md:421-434`). `copy_value` only bumps refcounts for
  heap values (`cranelift_runtime.c:1924-1930`).
- Partial moves are field/element precise; whole use of a partially moved
  aggregate is `E3101`; runtime-indexed reuse traps `R6005`
  (`contract.md:846-854,1033`, `a_cell_take` at `cranelift_runtime.c:2148-2156`).
- No lifetime elision: returning a reference requires `'a` (`E3104`);
  `&mut` of immutable binding `E3107`; borrow of temporary `E3108`.
- Mutation of a shared container triggers copy-on-write `a_unshare`, which can
  shallow-clone all children under a lock (`cranelift_runtime.c:1935`, `a_lock()` at `:1945`).

## What crosses the ABI

- **Cranelift (development)**: every generated function takes I64 parameters and
  at most one I64 result; the hidden runtime pointer is the first parameter
  (`xylem-rust/crates/xylem-native/src/cranelift_full.rs:7043-7057`).
- **LLVM (release)**: the hidden runtime pointer is `ptr %runtime` (not I64),
  followed by `i64 %argN`, returning `i64`/`void`
  (`xylem-rust/crates/xylem-llvm/src/full_lower.rs:6294-6298`). Do not generalize
  the all-I64 rule to LLVM.
- A non-scalar crossing a call/task/dynamic/return boundary is demoted to
  `Repr::Managed` by `repr_plan`, which demotes call arguments and return values
  only; aggregate and store boundaries are deliberately left to per-temporary
  plans (`xylem-rust/crates/xylem-llvm/src/repr.rs:158-193`).
- Keep hot helpers scalar-only and non-escaping to get the unboxed calling
  convention (`xylem-rust/crates/xylem-native/src/cranelift_full.rs:1620-1679`).

## Semantic vs implementation cost

- **Semantic** (cannot remove): checked arithmetic traps R6001/R6002, finite
  float trap, bounds R6004, moved-value R6005, call-depth R6007,
  task-cancel/authority R6003/R6008, capability budget R6009, and deterministic
  drop order (`contract.md:1029-1037`).
- **Implementation** (optimizer/runtime target): boxing at cell/ABI boundaries,
  refcount updates, shallow COW clones, path-node allocation, allocator
  bookkeeping, helper-call traffic. Record these as compiler work; do not
  present them to application authors as unavoidable.

## Evidence and counterexamples

Cranelift development diagnostic (not release performance, `AGENTS.md:8`;
`PENDING_INDEPENDENT_VERIFICATION`): helper census for `map-flat`
(`docs/development/performance-execution-record.md:1346-1363`) — `read_ref`
11.05%, `a_ref_append_segment` 8.95%, `xylem_rt_a_vec_index` 6.93%,
`a_free_value` ~10.7% (6.12% + 4.57% `.part.0`), `a_cell_set` 5.55%,
`a_allocate_uninit` ~9.5% (5.15% + 4.33% unlocked), `a_int_kind` 4.74%; these are
sums of Callgrind rows, not single measurements. Inline cell fast paths cut
`a_cell_set` from 10,479,268 to 4,380 and `a_cell_get` from 3,921,734 to 19
(`docs/development/_archive/native-runtime-profile.md.bak:631-637`, superseded).

## References

- `references/representation-map.md` — operation → representation → cost table.
- `references/ownership-rules.md` — copy/move/borrow/drop rules with ADRs.
