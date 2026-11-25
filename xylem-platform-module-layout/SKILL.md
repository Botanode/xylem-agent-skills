---
name: xylem-platform-module-layout
description: Create and review the canonical folder/file layout for Xylem platform libraries, Lotus kernel modules and example applications. Use when adding a module, splitting a file, naming a test, placing fixtures or expected output, writing an app README, or deciding whether code belongs in schemas/, contracts/, ports/ or modules/.
disable-model-invocation: true
---

# Xylem platform module layout

Use **one canonical layout**. It adapts Cargo's package-layout convention
(https://doc.rust-lang.org/cargo/guide/project-layout.html) to Xylem source and
to the checked-in Lotus structure (`lotus/README.md:12-33`). Deterministic
discovery and a single pin manifest are hard requirements: a fresh reader MUST
enumerate every module, contract and fixture without a network call or an
ordering guess.

## Canonical tree

```text
<repo-root>/
  README.md                  # one README; nine required sections
  toolchain.toml             # the ONLY pin manifest
  src/                       # Xylem modules, snake_case; main.xy for apps
  contracts/                 # L2b: versioned identities + pure validation
  ports/                     # L2b: versioned port interfaces + injected fn types
  modules/                   # L2a/L5: pure helper modules, no I/O
  schemas/<contract>/v1.schema.json
  fixtures/<contract>/*.json
  tests/<subject>.xy
  expected-output/report.txt
  tools/                     # deterministic stdlib-only validators
  examples/<product>/        # example apps; each carries its own README (L6)
```

## One manifest, deterministic discovery

- **Keep** exactly one pin manifest at the repository root (`toolchain.toml:2-20`).
  A product or example MUST NOT carry a second manifest or pin; it cites the
  root pin instead (`examples/lotus-web-consumer/README.md:12-18`).
- **Enumerate** files through sorted, explicit paths. The validator MUST compare
  each schema's `$id` and `title` to its filename, require paired accept/reject
  fixtures, and exit non-zero on any mismatch (`lotus/README.md:14-28,64-83`).
- **Resolve** discovery locally: `--schemas`, `--root` and `--catalog` are the
  only overrides (`lotus/README.md:73-74`). MUST NOT download a validator or
  import a third-party package (`lotus/README.md:76-83`).
- **Exception:** an app README may pin the compiler for documentation only; it
  does not add a manifest.

## Directory responsibilities — one kind per directory

- **`schemas/`** holds JSON Schema 2020-12 documents named `v<major>.schema.json`,
  one directory per contract identity, with `$id`/`title` equal to the exact
  identity (`lotus/README.md:14-21`; contract table `:34-49`).
- **`contracts/`** holds Xylem source for identity, refusal vocabulary, version
  negotiation, manifest/capability validation and pure graph/workflow/audit/
  evidence rules. It owns contracts and ports, not infrastructure
  (`lotus/contracts/core.xy:1-9`; `docs/decisions/D-005-lotus-port-strategy.md:188-196`).
  MUST NOT contain host I/O or a concrete adapter.
- **`ports/`** holds versioned interface declarations and injected effectful
  function aliases only — no implementation and no host intrinsic
  (`lotus/ports/storage.xy:1-20`; `lotus/README.md:129-144`).
- **`modules/`** holds derived helpers and SDK facades that are neither a
  contract identity nor a port (`lotus/modules/{catalog,engine,ops,runtime,sdk,supply_chain}.xy`).
  Product-internal layers use `<product>.A2..A7`, never global layer numbers
  (`docs/decisions/D-005-lotus-port-strategy.md:179-186`).

## When to split a module

Split on responsibility or layer boundary, never on line count alone. A second
contract identity, a second effect-row family, or a new host dependency warrants
a new file; identity, refusal and version stay separate files because each owns
a distinct identity (`lotus/README.md:36-49`). MUST NOT put an L2b contract and
an L3 adapter in one file. **Exception:** a small private helper stays with its
caller until a second caller exists.

## Test and output naming

- Name test files `tests/<subject>.xy` in `snake_case`, after the owning module
  or phase id: `lotus/tests/p1_ports.xy`, `lotus/tests/l2_manifest.xy`, `examples/lotus-web-consumer/src/consumer.xy`, `examples/lotus-server-consumer/src/server.xy`,
  `examples/lotus-desktop-consumer/src/desktop.xy`, `examples/lotus-mobile-consumer/src/mobile.xy` (`lotus/tests/`;
  `examples/lotus-web-consumer/README.md:44-50`). One file per subject.
- Pair each contract with accept/reject fixtures (`lotus/README.md:22-24`) and a
  byte-exact `expected-output/report.txt` compared with `diff -u`
  (`examples/lotus-web-consumer/README.md:57-61`).

## README and status

An app README MUST contain Purpose, Required compiler version (source revision
and artifact sha256), Required language features, Build instructions, Run
instructions, Example input, Expected output, Known limitations and Status
(`examples/lotus-web-consumer/README.md:3-83`;
  `docs/decisions/D-003-platform-app-conformance.md:27-29`). MUST NOT add
  status, handover, briefing, dispatch or scoreboard documents
  (`docs/decisions/D-003-platform-app-conformance.md:60-62`; workspace
  `AGENTS.md` documentation policy). Mark a check `VERIFIED` only after an
  independent reproduction; otherwise `PENDING_INDEPENDENT_VERIFICATION`
  (`examples/lotus-web-consumer/README.md:73-83`).

## Procedure

1. Name the product's layer and map it to one directory kind.
2. Create snake_case files; confirm no second manifest exists.
3. Wire the validator for `$id`/`title`, fixture pairing and sorted discovery.
4. Add one test file per subject and a byte-exact expected output.
5. Write the nine-section README with an honest status and no performance claim.

*Done when* discovery is deterministic, one manifest exists, each directory
holds only its assigned kind, the README has all nine sections, and every
claimed check names the pinned artifact identity with an independent verifier
recorded.

## References

- https://doc.rust-lang.org/cargo/guide/project-layout.html — `src/`, `tests/`, `examples/`, `benches/` and snake_case module convention.
- https://adr.github.io/ — one decision record per architectural choice, with rationale and consequences.
- `lotus/README.md:12-33,34-49,64-83,129-148`; `examples/lotus-web-consumer/README.md:3-83`; `examples/lotus-server-consumer/README.md:13-18,44-50`; `docs/decisions/D-003-platform-app-conformance.md:24-29,60-62`; `docs/decisions/D-005-lotus-port-strategy.md:161-203`; `docs/tooling/cross-target-capabilities.md:68-93`; `toolchain.toml:2-20`.
