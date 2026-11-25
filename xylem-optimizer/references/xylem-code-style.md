# Writing professional Xylem code (verified syntax and idioms)

These rules come from executing Xylem templates in this workspace and from the
language repository's own workloads (`tests/perf/workloads/xylem/compiler_ast.xy`,
`tests/perf/probe/scalar_floor.xy`, `compiler/src/*.xy`). They are observations,
not a language specification; confirm against `docs/language/contract.md` and
`docs/language/grammar.ebnf` before relying on a construct.

## Program shape

```
fn main() -> i32 effects [allocation, process, external] {
    let mut n: i64 = 4096
    ...
    print(checksum)
    return 0
}
```

- `main` must return `i32` or `Unit` (`E2008` otherwise).
- Declare `effects [allocation]` on any function calling `vec_new`/`vec_push`,
  and `[process, external]` for I/O and timing calls (`E4001`).
- No semicolons at statement ends; newline terminates a statement. `return`
  must be followed by an expression on the same line.

## Operators and arithmetic

- There is **no `^` bitwise operator** and **no `<<` shift operator** (`E1001`).
  Use arithmetic (`+`, `-`, `*`, `/`, `%`) and loops over bits if needed.
- Integer arithmetic is checked; overflow traps with `R6002`. Bound
  recurrences with `% 1000000007` (or an appropriate modulus) so each
  intermediate stays representable.
- Integer literals do not implicitly convert to the expected field/variable
  type in all positions; use `1 as i64`, `0 as usize` where inference fails.
- `% 2` replaces bit tests where parity is the goal.

## Values, references, ownership

- `let mut` is required for any binding passed as `&mut` (`E3107`).
- `Option.None` type inference can fail (`E3021`); use a typed binding or a
  sentinel where alternatives are unavailable.
- Pattern matching uses `if let Option.Some(x) = vec_get(&v, i) { ... }`;
  the binding may be an owned value, so dereference only references (`E3014`).
- Struct literals need fully typed fields; named fields must match declarations.
- Avoid taking addresses of temporaries that will be moved; the ownership
  checker reports `E5005` for use-after-move.

## Collections and strings

- `Vec<T>` API: `vec_new`, `vec_push(&mut v, x)`, `vec_len(&v)`,
  `vec_get(&v, index)` returning `Option<&T>`. Indices are `usize`.
- Prefer spans/indices into the original source over new strings;
  `text_between` allocates and should not appear in hot loops.
- String building by repeated `concat` is quadratic; use a buffer/piece list
  when many appends are needed.

## Style and review

- Name helper functions after the mechanism, not the benchmark.
- Keep functions short and single-purpose; the module gate enforces line and
  function budgets (`scripts/check-selfhost-modules.xy`).
- Preserve trap locations and diagnostic spans when moving or specializing code.
- Any optimization must include a runnable before/after test with matching
  checksums under `--backend llvm --release` and exact artifact identities.
