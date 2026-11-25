# ABI and helper-call map (source-traced, not independently verified)

All spans below are `PENDING_INDEPENDENT_VERIFICATION` until an independent
verifier reproduces them.

- Cranelift dev ABI (all I64, hidden runtime pointer first arg):
  `xylem-rust/crates/xylem-native/src/cranelift_full.rs:7043-7057`.
  LLVM release uses `ptr %runtime` then `i64 %argN`:
  `xylem-rust/crates/xylem-llvm/src/full_lower.rs:6294-6298`.
- Scalar-only calling convention: `cranelift_full.rs:1623-1679`, direct calls at
  `:3489-3524`.
- Box/unbox helpers: `xylem-rust/crates/xylem-native/src/cranelift_runtime.c:11255-11257`
  (floats as IEEE bits in i64).
- Cell fast paths: `xylem-rust/crates/xylem-native/src/cranelift_full.rs:5351-5420`;
  cells RT:2105-2134; trap R6005 RT:2177-2185.
- Tagged references: RT:1032-1065; owning path refs RT:3367-3374, 3422-3497.
- Native vectors: RT:884-891, 3665-3690; element address FL:1870-1880.
- Key hash raw path (experimental patch): `docs/development/patches/llvm-raw-key-hash.patch`.
- C export wrapper: `xylem-rust/crates/xylem-native/src/cranelift_full.rs:7202-7277`;
  entry `xylem_main` :7659-7667.
- Trap semantics: R6001/2 RT:11858-11937, R6002 float RT:11998-12033,
  R6004 RT:2462-2468 and index guard :12324-12331.
