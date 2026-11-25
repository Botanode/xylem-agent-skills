---
name: xylem-language
description: Write valid Xylem source using the implemented grammar, semantics and edition rules. Use when writing or reading Xylem programs, choosing syntax for a construct, diagnosing a language error, or when unsure whether a feature exists in frozen 1.0 or the development editions.
---

# Xylem language

Xylem has **two surfaces** (`docs/language/contract.md:19-20,110-134`):
frozen **edition 2026** (normative 1.0, deliberately rejects many features) and
development editions **2027/2028** (FFI, `&dyn`, advanced generics, concurrency,
capabilities). Check `xylem.toml` before using a feature. A construct accepted
in one edition may be a stable rejection in another (e.g. `extern "C"` → `E3027`
in 2026, accepted in 2027).

## Top rules — read before writing anything

1. **Operators**: `+ - * / % == != < <= > >= && || ! as & &mut * ?`.
   **No `^`, no `<<`/`>>`, no compound assignment** (`parser_expr.xy:22-53`,
   `contract.md:227-231`). Use arithmetic/stdlib helpers.
2. **Arithmetic is checked**: overflow/div-by-zero/non-finite float traps
   (`R6001/R6002`). Never assume wrapping. `%` on float is `E3005`.
3. **Literals have no type suffix**: `1i64` is invalid. Type comes from context;
   default int is `i32`, float `f64`. Use `1 as i64` for wider fields
   (`contract.md:202-209`, `tests/perf/reproducers/README.md:85-89`).
4. **Effects are declared**: `fn f() -> i32 effects [allocation, process]`;
   missing row `E4001`, unknown `E4002`, duplicate `E4003`. `print` is the sole
   documented exception (`contract.md:922-987`).
5. **Newlines separate statements**; tail expression before `}` has no
   separator (`contract.md:167-172,269-276`).
6. **Enums**: unit `Status.Ready` and positional `Status.Full(42)` only;
   brace payload `E3020`. `match` must be exhaustive (`E3010`); guards don't
   count (`contract.md:303-312,670-714`).
7. **No lifetime elision**: returning a reference requires an explicit `'a`
   (`&'a T`), `E3104` otherwise; `&mut` is not copy; borrow of immutable binding
   `E3107` (`contract.md:856-903`).
8. **`main`**: exactly one, nullary, returns `i32` or `Unit` (`E2008`);
   exit status is `result & 0xff` (`contract.md:502-506,1013-1020`).
9. **Ownership**: copy iff all fields/elements copy; `String`, `&mut T`,
   `Vec<T>`, `Map`, `Set` are not. Partial move → whole use is `E3101`,
   runtime-indexed reuse traps `R6005`; drops run in reverse declaration order
   but NOT on trap unwind (`contract.md:421-434,846-854,905-918`).
10. **Vec/Map/Set are prelude**, not `std/collections`; `vec_new()` with type
    annotation, `Vec.new()` rejected `E2001`. Bare `dyn T` rejected; `&dyn T`
    and `Box<dyn T>` implemented in dev editions.

## Verified example shapes (adapted from the repository)

```xylem
// conformance/cases/effects.xy:1-6
fn work() -> i32 effects [filesystem] { return 0 }
fn main() -> i32 effects [filesystem] { print(work()) }

// examples/core.xy:1-44 — const, struct, for, array
const LIMIT: i32 = 3
struct Counter { value: i32 }
fn main() -> i32 {
    let mut counter = Counter { value: 0 }
    for i in 0..LIMIT { counter.value = counter.value + i }
    let values = [1, 2, 3]
    print(len(values))
    return 0
}

// conformance/cases/generics.xy:1-15
struct Box<T> { value: T }
fn identity<T>(value: T) -> T { return value }
// let boxed: Box<i32> = Box { value: 7 }

// conformance/cases/closure-value.xy:2-4 — closure params REQUIRE types
let offset = 2
let add = |value: i32| value + offset
```

Full feature catalogue with syntax, status, evidence line and test:
`references/capability-matrix.md`. Source examples: `examples/`.

## Procedure for any Xylem task

1. Check `xylem.toml` edition and the capability matrix status of each construct.
2. Write the smallest valid program using verified syntax.
3. Validate with `xylem check <file> --json`; fix diagnostics (never invent
   syntax to make an unsupported feature "work").
4. Run with `xylem run` and, for release-relevant code, build with
   `--backend llvm --release --opt-level speed`.
5. If a feature is rejected, confirm the smallest reproducer and record it as
   UNKNOWN/PLANNED with the diagnostic code; do not fabricate a workaround.

## References

- `references/capability-matrix.md` — 40-feature status table with evidence.
- `references/diagnostics.md` — diagnostic/trap catalogue and common mistakes.
- `references/editions.md` — frozen 1.0 vs development line.
