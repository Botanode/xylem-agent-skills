# Trap and diagnostic catalogue

Compiler diagnostics originate in `compiler/src/lexer*.xy` (E1xxx),
`parser*.xy` (E1xxx syntax), `resolver*.xy` (E2xxx), `typecheck*.xy`/`safety.xy`
(E3xxx), `effects*.xy` (E4xxx), `validate*.xy` (E5xxx). Verify the exact code
and span with `xylem check <file> --json` against the current compiler.

Runtime traps are specified in `xylem-lang/docs/language/contract.md` and ADRs
in `docs/decisions/README.md`: R6001 (division/remainder by zero), R6002
(integer overflow or non-finite float), R6003 (general trap), R6004 (index out
of bounds), R6005 (moved value), R6006 (step budget exhausted, interpreter
`--max-steps`; `conformance/manifest.json:1644-1660`, `compiler/src/cli_run_support.xy:101`),
R6007 (call-depth limit, 512 frames; `tests/torture/README.md:223`,
`conformance/manifest.json:1662-1677`). The backend implementation lives in the
native runtime (`xylem-rust/crates/xylem-native/src/cranelift_runtime.c`,
`lib.rs`) and the LLVM lowering in
`xylem-rust/crates/xylem-llvm/src/full_lower.rs`.

A trap's source span is observable. When specializing or moving operations,
preserve the trap site; otherwise the program is semantically wrong even if the
checksum matches.
