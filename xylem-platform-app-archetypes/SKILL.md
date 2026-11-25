---
name: xylem-platform-app-archetypes
description: Create or review a Xylem platform example app for the web, server, desktop or mobile product family. Use when adding a Lotus consumer, designing a deterministic fixture and byte-exact expected-output report, or asking what a platform app may and may not do.
trigger:
  branches:
    - when: "creating a web/server/desktop/mobile platform example"
      read: "## Archetype shapes; ## Required file layout; ## Completion criteria"
    - when: "writing or reviewing fixtures and expected output"
      read: "## Fixture and expected-output contract; ## Determinism rules"
    - when: "asked about L2b contracts, injected ports or refusal codes"
      read: "## L2b contract and port consumption"
    - when: "asked to add sockets, windows, SDKs or benchmarks to an example"
      read: "## Determinism rules; ## Completion criteria"
  do_not_activate:
    - "compiler, runtime or backend changes (use xylem-compiler-architecture)"
    - "host adapter implementation (deferred behind L2b ports per D-005)"
source_of_truth: "docs/decisions/D-001..D-005 plus the app README; AGENTS.md owns policy"
evidence_status: "Claims copied from example READMEs stay PENDING_INDEPENDENT_VERIFICATION until reproduced"
---

# Xylem platform app archetypes

An archetype is the canonical, reproducible shape of one platform example. It is an L5 consumer proving that a versioned L2b Lotus contract works through a host-injected port — never a host adapter, native UI or performance demo.

**MUST** place every platform example at L5 (D-001 v2), consume only downward dependencies (L4a UI contract, L3 events, L2 capabilities), and obey the D-003 design/architecture/coding/verification rules. **MUST** treat `examples/lotus-*-consumer/README.md` as the worked reference and extend it; **MUST NOT** invent a parallel layout. Policy lives in `AGENTS.md`; this skill executes it and is not a second policy source.

## Archetype shapes

| Family | Directory | Ports consumed | Fixed deterministic stub | Explicitly out of scope |
|---|---|---|---|---|
| Web | `examples/lotus-web-consumer/` | storage | in-memory version table | Browser build, WASM, runtime target |
| Server | `examples/lotus-server-consumer/` | storage + transport | in-memory table + transport ack | Sockets, HTTP handlers, async I/O |
| Desktop | `examples/lotus-desktop-consumer/` | storage + clock | in-memory table + tick `1234` | Windows, GPU, real clock |
| Mobile | `examples/lotus-mobile-consumer/` | storage + RNG | in-memory table + draw `42` | SDKs, devices, touch, host randomness |

**DEFAULT TO** the storage-only web shape when starting a new family; add exactly one family-specific port. "Web", "server", "desktop" and "mobile" name the consuming product family, not an achieved runtime target.

## Required file layout

```text
<family>/
  README.md
  xylem.toml
  src/main.xy
  src/<family>.xy
  tests/<family>.xy
  fixtures/accepted.json
  fixtures/refused-unknown-major.json
  expected-output/report.txt
```

**MUST** include every listed file. **MUST NOT** add a status, briefing, dispatch or handover document (D-003 §5).

## Required README headings (in this order)

1. Purpose — layer, L2b contract and port, no host runtime import.
2. Required compiler version — pinned revision and artifact sha256 (currently 1.0.0 / `5ff0ba2a…` / `7082acd9…`).
3. Required language features — imports, effectful fn types, `Result`/`match`, declared effects.
4. Build instructions — export `BOOT`/`HOST`/`XYLEM_STDLIB_ROOT`; exact `check` command.
5. Run instructions — exact `run` and `test` commands.
6. Example input — fixture files and in-memory table keys.
7. Expected output — byte-exact report and refusal codes.
8. Known limitations — stubs, no OS/SDK/network/clock, costs `PENDING_VERIFICATION`.
9. Status — exact commands, exit codes, verifier and honest status label.

**DEFAULT TO** `PENDING_INDEPENDENT_VERIFICATION` in the Status section until another agent reproduces the run.

## Fixture and expected-output contract

**MUST** ship `examples/lotus-web-consumer/fixtures/accepted.json` and `examples/lotus-web-consumer/fixtures/refused-unknown-major.json` and map keys `supported`, `requested-accepted`, `requested-unknown-major` in the in-memory table; **MUST** refuse unknown keys with `UMS-REF-0048` rather than default. **MUST** negotiate accepted `lotus.plugin/v1` and refuse `lotus.plugin/v9` with `UMS-REF-0009` in every family. **MUST** require `expected-output/report.txt` to match stdout byte-for-byte (`diff -u` clean); the contract and fixture are the single source of truth, so **MUST NOT** rewrite expected output to follow a changed program without a recorded contract change.

## Determinism rules

**MUST** receive every contract value through an injected effectful function value (`fn(&String) -> … with [...]`) carrying a canonical `contract_id`; **MUST** copy a function-valued struct field to a local before calling it (direct `port.field(...)` is `E3019` on the pinned compiler). **MUST** keep all fixtures deterministic with the fixed stubs above and effect rows inherited from the injected fn type, not from real resources. **MUST NOT** open sockets, start HTTP handlers, create windows, use a GPU, read a real clock/RNG, import an OS SDK, import a Rust Lotus runtime, add a Cargo dependency or touch a protected path. **MUST NOT** claim performance numbers; **MUST** label every cost `PENDING_VERIFICATION`.

## L2b contract and port consumption

**MUST** consume only the versioned ports `lotus.storage/v1`, `lotus.clock/v1`, `lotus.rng/v1` and `lotus.transport/v1` (`lotus/ports/*.xy`), each an injected effectful function value. L2b owns contracts and ports; host adapters are injected by L3/L7 (D-005). **MUST** verify all four ports with deterministic stubs in `lotus/tests/p1_ports.xy` and keep the example limited to its declared subset.

## Completion criteria

- `check <family>/src/main.xy` exits 0 with the pinned compiler hash recorded.
- `run <family>` exits 0 and stdout is byte-exact against `expected-output/report.txt`.
- `test <family>` exits 0; the nine README headings are present with honest status labels.
- Diff contains no protected path, pin change, Cargo dependency or CI/deploy file.
- A second agent reproduces the commands; otherwise all claims remain `PENDING_INDEPENDENT_VERIFICATION`.

## References

- https://12factor.net/dev-prod-parity — keep development and production environments alike; deterministic fixtures over divergent backing services.
- https://12factor.net/config — config in the environment, not embedded in the app; motivates injected ports.
- `docs/decisions/D-001-platform-layering.md`, `docs/decisions/D-003-platform-app-conformance.md`, `docs/decisions/D-005-lotus-port-strategy.md`.
- `examples/lotus-{web,server,desktop,mobile}-consumer/README.md`; `lotus/ports/{storage,clock,rng,transport}.xy`; `lotus/tests/p1_ports.xy`.
- `ecosystem-readiness/work_logs/phase-04-platform-design.md:116-129` — four-family byte-exact evidence.
