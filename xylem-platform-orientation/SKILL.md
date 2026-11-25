---
name: xylem-platform-orientation
description: Place a Xylem platform product in the L0–L7 stack and apply the dependency, port and version-identity rules. Use when naming or locating a product, checking a design record's layer placement, reading a Lotus contract or injected port, deciding whether a change belongs in the protected compiler, a host capability, the Lotus kernel, a UI adapter, a framework, an application or the delivery plane, or when a request would cross one of those boundaries.
---

# Xylem platform orientation

The tree is the source of truth; decisions record intent and never override code
(workspace `AGENTS.md` documentation policy). Hold one canonical layer map in
your head — every rule below derives from it.

## The stack — memorize this map

1. **L0 machine substrate** — native ABI `xylem-native/16`, canonical IR
   `xylem-bootstrap-ir/1`, codegen, execution engine. **PROTECTED**
   (`toolchain.toml:15-20`).
2. **L1 core value model** — values, ownership/RC/COW, numerics, strings,
   collections, traps, effects runtime. **PROTECTED**.
3. **L2a host capabilities** — Xylem-written `stdlib/src/std/**`: filesystem,
   process, networking, streams, env, time, JSON/format.
4. **L2b Lotus kernel** — versioned contracts plus pure algorithms and
   host-injected ports (`lotus/contracts/`, `lotus/ports/`, `lotus/modules/`).
5. **L3 platform substrate** — event loop, surface, input, timers, device,
   graphics: the Rust `xylem-platform/crates/*` adapters.
6. **L4a shared UI policy** — the single `xylem-ui` `UiDocument` contract and
   rendering port. There is no second UI model.
7. **L4b target UI adapters** — web DOM, GTK/AppKit/WinUI, iOS/Android,
   embedded `Canvas`.
8. **L5 frameworks/services** — `xylem-web-framework` and
   `xylem-<server-runtime>`.
9. **L6 applications** — business logic, fixtures, expected output, app tests;
   the four `examples/lotus-*-consumer/` apps live here.
10. **L7 delivery plane** — CLI, LSP, formatter, linter, packages, installer,
    docs. A plane, not a runtime tier (`docs/decisions/D-001-platform-layering.md:28-42`).

## Placement and dependency rules

- **Place** each product at the lowest layer that owns its policy; DEFAULT TO
  the layer defining the contract, not the layer rendering it.
- **Record** layer, downward-only dependencies, plugin-boundary map, data
  ownership and out-of-scope list in the design record before implementation
  (`docs/decisions/D-003-platform-app-conformance.md:14-17`).
- **Point** source dependencies downward only (matrix in
  `docs/decisions/D-001-platform-layering.md:58-68`). Runtime calls and data MAY
  flow upward through events/subscriptions established by the upper layer; a
  lower layer MUST NOT store references to upper-layer state (`:85-93`).
- **Own** each port in the layer owning the abstraction: L2 capability,
  L3 readiness/input/surface, L4a rendering
  (`docs/decisions/D-001-platform-layering.md:72-83`). Adapters implement the
  port and MUST NOT define or mirror it. Adapters never depend on sibling
  adapters (`:70`).
- **Keep** L7 out of runtime paths; no application business logic in L7
  (`docs/decisions/D-001-platform-layering.md:56`).

## Port and version identity rules

- **Canonicalize** every contract id as `family/vN` with `contract_id`
  (`lotus/contracts/core.xy:17-19`). `N` is a decimal major ≥ 1; strict parsing
  refuses malformed ids with `UMS-REF-0048` (`core.xy:41-46,118-140`) and an
  unknown major with `UMS-REF-0009` (`lotus/README.md:59-61`). MUST NOT default,
  guess or silently upgrade.
- **Pin** protocol identities `xylem-bootstrap-ir/1` and `xylem-native/16`
  (`toolchain.toml:19-20`). Change them only through a recorded ADR with all
  readers/writers updated, a verifier, migration tests and a staged rollout —
  never by editing one side.
- **Name** L2b ports with versioned ids `lotus.storage/v1`, `lotus.clock/v1`,
  `lotus.rng/v1`, `lotus.transport/v1` (`lotus/README.md:129-140`). The kernel
  owns the interface; the host injects an effectful function value; no host
  intrinsic is compiled into the kernel.
- **Namespace** product-internal Lotus layers as `<product>.A2..A7`
  (`docs/decisions/D-005-lotus-port-strategy.md:161-186`); do not reuse global
  layer numbers inside a product.
- **Reserve** names: `xylem-runtime` is the protected backend crate and
  `xylem-desktop` is the existing Rust L4b crate — neither may be repurposed
  (`ecosystem-readiness/docs/decisions/D-004-product-surface.md:18-19,34-44`).

## Out of scope for this campaign

MUST NOT edit L0/L1, toolchain pins, Cargo dependency pins, CI/deploy
triggers, the Lotus Rust runtime, or build a second UI, capability or plugin
system (`docs/decisions/D-005-lotus-port-strategy.md:28-38,188-203`). MUST NOT
claim performance numbers: certification stays with the protected compiler
campaign (`docs/tooling/cross-target-capabilities.md:95-105`). A cross-build
record is not support evidence; macOS, Windows, iOS and Android remain
`SPECIFIED_NOT_IMPLEMENTED` (`docs/tooling/cross-target-capabilities.md:61-66`).

## Procedure

1. Name the product and its layer from the map above.
2. Write its layer, downward dependencies, plugin boundary, data ownership and
   out-of-scope list.
3. Check every dependency edge against the matrix; redirect upward or sideways
   edges through a port owned by the lower layer.
4. Check every boundary carries a versioned identity and canonical refusal.
5. Check the README status tag is honest and contains no performance claim.

*Done when* a layer is named, every dependency points downward, every port has
an owner and version, every refusal is canonical, and out-of-scope items are
listed. Everything else is `PENDING_INDEPENDENT_VERIFICATION`, never "done".

## References

- https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html — dependency rule and inward-pointing source dependencies.
- https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/hexagonal-architecture.html — ports/adapters ownership.
- https://adr.github.io/ — record rationale, trade-offs and consequences, not just conclusions.
- `docs/decisions/D-001-platform-layering.md:28-93`; `docs/decisions/D-002-plugin-centric-platform.md:9-11,46-65`; `docs/decisions/D-003-platform-app-conformance.md:14-29`; `docs/decisions/D-005-lotus-port-strategy.md:161-203`; `ecosystem-readiness/docs/decisions/D-004-product-surface.md:13-19,32-44`; `docs/tooling/cross-target-capabilities.md:45-66,95-105`; `toolchain.toml:15-20`; `lotus/README.md:59-61,129-148`; `examples/lotus-web-consumer/README.md:5-10`. D-00x paths are relative to the `version_2` root; other paths are worktree-relative.
