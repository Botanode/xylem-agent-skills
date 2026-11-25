# Xylem capability matrix (verified from implementation + conformance)

Status: IMPLEMENTED / PARTIAL / PLANNED-EXCLUDED / UNKNOWN. Evidence is file:line
in `xylem-lang` unless noted. All entries PENDING_INDEPENDENT_VERIFICATION.

| Feature | Status | Evidence | Limitation / note |
|---|---|---|---|
| Bindings, mutability | IMPLEMENTED | grammar.ebnf:150-151; parser_expr.xy:85-92 | no destructuring let; immutable default |
| i8/i16/u8/u16/u32 | IMPLEMENTED (dev) | contract.md:792-795 | frozen 1.0 table omits them |
| i32/i64/u64/usize | IMPLEMENTED | contract.md:282-288 | i32 math is wide-then-range-checked; u64/usize use full-value path |
| f32/f64 | IMPLEMENTED (dev) | contract.md:191-209,831-842 | NaN/Inf are traps (R6002); no float `%` |
| bool, Unit | IMPLEMENTED | contract.md:288,290 | no numeric/bool conversion |
| char | IMPLEMENTED (dev) | contract.md:219-225 | rejected in frozen 1.0 |
| String | IMPLEMENTED | contract.md:211-217 | one-line literals; UTF-8, byte-oriented stdlib |
| Tuples | IMPLEMENTED (dev) | contract.md:383-393 | `(T)` is grouping, not a tuple |
| Arrays `[T;N]` | IMPLEMENTED | contract.md:370-381 | OOB traps R6004 |
| Growable Vec<T> | IMPLEMENTED (prelude, dev) | contract.md:1626-1676; prelude_unit.xy:28-38 | `Vec.new()` rejected E2001; no indexed assignment |
| Slices `&[T]` | IMPLEMENTED | contract.md:395-404 | no range slicing |
| Operators | IMPLEMENTED (bounded) | parser_expr.xy:22-53 | no ^, no shifts, no compound assign |
| Checked arithmetic/traps | IMPLEMENTED | contract.md:797-808,1027-1030 | R6001/R6002 mandatory |
| Functions/params/returns | IMPLEMENTED | grammar.ebnf:113-124 | main nullary i32/Unit (E2008) |
| if/else, while, for, loop, break/continue | IMPLEMENTED | contract.md:644-666 | for bounds evaluated once; labels required for outer loops |
| match + patterns | IMPLEMENTED | contract.md:671-714 | exhaustive required (E3010); guards don't count |
| Structs | IMPLEMENTED | contract.md:295-302 | recursion only via reference |
| Enums (unit/positional) | IMPLEMENTED | contract.md:303-312 | brace payload E3020 |
| Option/Result + `?` | IMPLEMENTED (prelude) | contract.md:583-589,745-755 | fixed error shape; no user Try trait |
| Generics | IMPLEMENTED | contract.md:314-332 | local inference; cap 1024 instantiations |
| Const generics | PARTIAL (dev) | contract.md:1565-1574 | const-generic impl rejected E3020 |
| Interfaces/traits | IMPLEMENTED | contract.md:334-361 | static dispatch; dyn in dev editions |
| Associated types/GATs | IMPLEMENTED (dev) | contract.md:1561-1565 | arity checked |
| Dynamic dispatch `&dyn`/`Box<dyn>` | IMPLEMENTED (dev) | contract.md:351-361; conformance/cases/dynamic-dispatch.xy:17-18 | bare `dyn T` rejected E1101 |
| Modules/imports/visibility | IMPLEMENTED | contract.md:570-581 | no wildcards; 4096-module cap |
| Type inference | IMPLEMENTED (local) | contract.md:202-209,321 | no global inference; ints default i32 |
| Effects [..] | IMPLEMENTED | contract.md:920-959,980-987 | 8 categories; print is exception |
| Ownership/moves | IMPLEMENTED | contract.md:421-434,846-854 | E3101; R6005 runtime |
| Borrows/lifetimes/NLL | IMPLEMENTED | contract.md:856-903 | no elision, explicit 'a |
| Drop | IMPLEMENTED | contract.md:905-918 | no drop on trap unwind |
| Raw pointers / unsafe | PARTIAL (dev) | contract.md:414-419,2106-2134 | requires unsafe effect; frozen rejects |
| extern "C" FFI | PARTIAL (dev) | contract.md:2119-2146 | i64/pointers/small structs only; E3027 in 2026 |
| Concurrency (async/scope/spawn/channels) | IMPLEMENTED (dev, deterministic) | contract.md:1965-2017 | no preemption; native backend limitation |
| const eval | IMPLEMENTED | contract.md:469-485 | no calls/if/match/refs in const |
| Result/? error handling | IMPLEMENTED | contract.md:745-755 | no unwinding |
| Capabilities (2028) | IMPLEMENTED (dev) | contract.md:2148-2176 | authority params, budgets |
| Macros | PLANNED-EXCLUDED | contract.md:2178-2216; E1101 rejection | design only |
| Exceptions/throw | PLANNED-EXCLUDED | scope.md:129; E1105 | deliberately excluded |
| Operator overloading | PLANNED-EXCLUDED | contract.md:611-614; E2005 | named methods only |
| Named-payload enum variants | PLANNED-EXCLUDED | contract.md:310-312; E3020 | positional only |
| Distributed/parallel runtime | NOT PLANNED | contract.md:2004-2017; scope.md:488 | deterministic scheduler only |

Conformance: `conformance/case-ids.txt:1-155` (155 ids; `coverage.md:60` says 154 — drift).
Explicit rejection cases: unsupported-const-generic-impl, unsupported-dyn-dispatch,
unsupported-edition, unsupported-exception, unsupported-ffi, unsupported-growable-collection,
unsupported-macro, unsupported-operator-overloading, unsupported-dependency-source,
undecorated-map-key (E3028).
