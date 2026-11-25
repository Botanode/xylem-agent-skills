# Ownership, borrows and drops (source-traced, not independently verified)

All claims are `PENDING_INDEPENDENT_VERIFICATION` until an independent verifier
reproduces them.

Source: `docs/language/contract.md:421-434,846-918` and ADRs in
`docs/decisions/README.md`: ADR-0006 (checked arithmetic), ADR-0007 (R6005),
ADR-0013 (ownership/reclamation), ADR-0042 (drop order), ADR-0031 (finite float),
ADR-0027 (bounds), ADR-0101/0103 (proof bits).

- Copy iff all fields/elements copy. `String`, `&mut T`, `Vec<T>`, `Map`, `Set`
  are not copy. `copy_value` bumps refcounts for heap values only
  (`cranelift_runtime.c:1924-1930`).
- Partial moves are precise; whole use of a partially moved value is E3101;
  runtime-indexed reuse traps R6005 (`a_cell_take`, RT:2148-2156).
- Borrows: no lifetime elision (E3104), `&mut` not copy (E3107), borrow of
  temporary E3108, borrow across mutation E3102. `&*handle` reborrows.
- Drop: reverse declaration order on scope exit/return/break/continue/`?`.
  A trap tears down active frames and releases their owned storage and refcounts;
  it does not execute user `Drop` hooks for unwound frames (contract.md:905-918,
  ADR-0042). A trap's source span is observable; never remove a check to improve
  performance.
- COW: mutating a shared container calls `a_unshare`, shallow-cloning children
  under the runtime lock (RT:1935) — a documented implementation cost.
- Compiler-facing: `analyse_temps` (`xylem-rust/crates/xylem-native/src/cranelift_full.rs:1004`)
  only promotes values whose address is not taken and which do not escape;
  `repr_plan` (`xylem-rust/crates/xylem-llvm/src/repr.rs:158-193`) demotes call
  arguments and return values to `Repr::Managed`; aggregate/store boundaries are
  left to per-temporary plans. Source can keep values local/scalar; it cannot
  request a different ABI.
