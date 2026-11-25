---
name: xylem-tooling-and-workflows
description: Use the verified Xylem build, run, test, benchmark and inspection commands. Use when compiling or running Xylem programs, selecting a backend or optimization level, inspecting IR or assembly, reading diagnostics, working with the standard library, reproducing compiler bugs, or when unsure which toolchain command or environment variable applies.
---

# Xylem tooling and workflows

All commands below were verified in this workspace. LLVM is the release backend;
Cranelift is development-only. Never report Cranelift timings as release results.

## Environment

```sh
export XYLEM_BOOTSTRAP=/path/to/xylem          # pinned compiler (toolchain.toml)
export XYLEM_BACKEND_HOST=/path/to/xylem-backend-host
export XYLEM_STDLIB_ROOT=$PWD/stdlib/src       # required for stdlib programs
export XYLEM_CLANG=/usr/bin/clang              # LLVM backend driver (llvm.toml)
```

`XYLEM_MEMORY_STATS=1` and `XYLEM_RUNTIME_COUNTERS=1` make the runtime print
allocation/counter data. Read values from stderr, not from the program.

## Verified commands

| Task | Command |
|---|---|
| Parse/check | `xylem check <file\|project> [--json]` |
| Run (interpreter) | `xylem run <file> [--json] [--max-steps N]` |
| Run native | `xylem run <file> --native` |
| Canonical IR | `xylem ir <file\|project> [--json]` |
| Effects | `xylem effects <file> [--json] [--deny-unchecked-intrinsics]` |
| Resources | `xylem resources <file> [--json]` |
| Native release build | `xylem build <file> -o <out> --release --backend llvm --opt-level speed` |
| Object / library | `xylem build ... --emit-object\|--emit-staticlib\|--emit-sharedlib [-L dir] [-l lib]` |
| Cross target (objects) | add `--target <triple>`; cross executables are rejected by LLVM |
| Profile runtime helpers | `xylem profile <file> -o <path>` |
| Tests | `xylem test [path] [--json] [--native] [--max-steps N]` |
| Lint / format | `xylem lint [<path>] [--json]`, `xylem fmt [<path>] [--check] [--json]` |
| Pass inventory | `xylem passes [--json]` |
| Doc test / migrate / LSP | `xylem doc [--test]`, `xylem migrate`, `xylem lsp` |

Release build flags are `--release`, `--backend llvm`, `--opt-level speed`.
`--opt-level` accepts `none|speed|size`. `--backend` accepts `auto|cranelift|llvm`;
`auto` resolves to Cranelift, so always pass `llvm` explicitly for release work.

## Repository gates

From `xylem-lang` root (see `scripts/check.sh`):

```sh
./scripts/run-xy.sh scripts/check-selfhost-modules.xy
./scripts/run-xy.sh scripts/check-semantic-decisions.xy
./scripts/run-xy.sh scripts/check-ir-instruction-parity.xy
./scripts/run-xy.sh scripts/check-stdlib-digest.xy
./scripts/run-xy.sh scripts/check-conformance.xy
./scripts/run-xy.sh scripts/check-perf-checklist.xy
./scripts/run-xy.sh scripts/check-perf-reproducers.xy
```

From `xylem-rust` root:

```sh
cargo test --workspace
cargo test -p xylem-compiler --test optimizer_equivalence
cargo test -p xylem-llvm --test llvm_backend
```

## Inspecting generated code

```sh
xylem ir <file> --json > /tmp/program.ir.json      # canonical IR
xylem build <file> --release --backend llvm -o /tmp/prog
objdump -d /tmp/prog > /tmp/prog.s                 # machine code
grep -c 'call' /tmp/prog.s                         # helper-call census
XYLEM_MEMORY_STATS=1 /tmp/prog                     # allocation counts
```

If `opt`/`llvm-dis` are unavailable on the host, record that rather than
claiming LLVM IR verification. Hardware counters may be blocked
(`perf_event_paranoid=4`); use instruction counts and assembly instead.

## Reproduction checklist

Record: compiler SHA-256, backend-host SHA-256, LLVM/clang version, target
triple, exact flags, seed, input size, samples, and the command that produced
each artifact. See `xylem-benchmarks/research/methodology.md`.

## References

- `references/command-reference.md` — full CLI flag inventory with source locations.
- `references/environment.md` — environment variables and toolchain pins.
