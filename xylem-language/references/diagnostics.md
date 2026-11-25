# Diagnostics and common mistakes

Codes are catalogued in `xylem-rust/crates/xylem-diagnostics/src/lib.rs:14-110`
(E1001–R6009, W7100); schema `xylem-diagnostic-v1` at `:11`. Verify exact code
and span with `xylem check <file> --json` against the current compiler.

| Code | Meaning | Common cause |
|---|---|---|
| E1001/E1003/E1004 | lexical / literal / unterminated comment | invalid character (e.g. `^`), non-finite literal |
| E1101/E1105 | syntax | unsupported feature; two statements on one line without `;` |
| E2001/E2007 | name resolution / module limit | `Vec.new()`; >4096 modules |
| E3001/E3002 | mutability / type | assign through shared ref; wrong operand type |
| E3010/E3011/E3012 | exhaustive match / struct fields | missing arm; missing/duplicate field |
| E3020/E3027/E3028 | unsupported construct / FFI / map key | brace variant; `extern "C"` in 2026; undecorated aggregate key |
| E3101/E3102/E3104/E3107/E3108 | move / borrow / lifetime | use after partial move; borrow across mutation; missing `'a`; `&mut` of immutable; borrow of temporary |
| E4001/E4002/E4003 | effects | missing effect row; unknown category; duplicate category |
| E5001/E5004/E5005 | internal validation | compiler bug; use after move in IR |
| R6001/R6002/R6004/R6005 | runtime traps | divide by zero; overflow/non-finite; OOB; moved value |

Rules: traps are semantic guarantees — never remove one to make a test pass.
Never treat a rejection in frozen 1.0 as a compiler bug; check `xylem.toml`
edition first. `scripts/check-diagnostic-order.xy` checks diagnostic ordering
(73/75 rejection envelopes vs Rust oracle at last record).
