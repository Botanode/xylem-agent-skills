---
name: xylem-modular-design
description: Design opinionated Xylem module boundaries: one responsibility per module, inward/downward dependencies, no cycles, stable versioned seams, no duplicated implementations, explicit ownership and testability. Use when splitting a module, drawing a dependency diagram, or reviewing a boundary before implementation.
---

# Xylem modular design

This skill owns the **boundary layer** of platform and app work. It sequences existing depth skills instead of restating them: folder/file naming and split mechanics go to `xylem-platform-module-layout` (`.agents/skills/xylem-platform-module-layout/SKILL.md:16-83`); identity, negotiation and refusal vocabulary go to `xylem-platform-api-design` (`:10-48`); duplicated-subsystem detection goes to `xylem-architecture-boundaries` (`:12-24`); hot-path structure goes to `xylem-platform-performance-guardrails`; ADR mechanics go to `xylem-app-design` (`:26-32`). These are structural rules, not performance claims (D-004:46-55).

## One responsibility, one owner (MUST)

**MUST** give every module one responsibility in one sentence, the state it owns, the contract it exposes, and at least one named consumer. **MUST** name an owner for each module and each seam. **DEFAULT TO** small focused modules over large files, splitting on responsibility or layer boundary, never on line count alone (`xylem-platform-module-layout/SKILL.md:66-74`). **MUST NOT** create a module whose only purpose is to exist for a future caller: a "utility", "helpers", "common" or "types" grab-bag with no identifiable consumer is refused at design review. Cohesion is the test — "the additional adapter code that makes the architecture pluggable is justified only if ... several input sources and output destinations ... Otherwise, the adapter becomes another additional layer to maintain" (AWS hexagonal). A small private helper stays with its caller until a second caller exists.

## Dependency direction (MUST)

**MUST** draw a dependency diagram in the design record: nodes are modules, edges are source dependencies, and each edge is labelled with the owning layer (L0-L7, or product-local `<product>.A2..A7` where applicable) and the versioned identity of the seam it crosses (D-001:28-70; D-005:161-186). **MUST** make every edge point inward/downward toward stable policy: "source code dependencies can only point inwards ... nothing in an inner circle can know anything at all about something in an outer circle" (Clean Architecture, The Dependency Rule). Runtime events may travel the other way only through subscriptions established by the upper layer; lower layers store no upper-layer state (D-001:85-94; D-002:46-65). **MUST NOT** allow a cycle, a sibling-adapter dependency, a sideways call or an upward source dependency; a lower-layer interface gap becomes an interface request or defect handover, never a local edit to protected L0/L1 (D-001:48-49,130-134). A module that cannot be split without a cycle is recursion-locked: restructure the mutual recursion into an explicit loop before splitting, rather than raising a ceiling or duplicating the helper (`docs/decisions/README.md`, ADR-0087).

## Stable seams (MUST)

**MUST** give every crossing a versioned identity (`family/vN` built by `contract_id`, parsed only by `parse_contract_id`) and a closed refusal code drawn from the registered set; defer depth to `xylem-platform-api-design` (`:10-48`). **MUST** treat a new incompatible shape as a new major with deprecation, not an in-place edit (SemVer 2.0.0: "MAJOR version when you make incompatible API changes"; Microsoft REST API Guidelines §12). **DEFAULT TO** additive change inside a major so existing fixtures stay byte-identical (Guidelines §6.1 ignore rule). **MUST NOT** mirror a port in the adapter or create a second interface grammar, capability system or compatibility predicate (D-001:72-83; D-005:188-196).

## No duplicated implementation (MUST)

**MUST** implement each rule once, in its owning module, and have every consumer call that one implementation (`xylem-architecture-boundaries/SKILL.md:14-24`). **MUST NOT** copy an identity parser, refusal vocabulary, version check, UI model, plugin registry, capability catalog or adapter into a second package (D-003:18-23; D-005:192-193). Duplicate code is not a boundary; it is two implementations that can drift. If a shared helper needs a third consumer, promote it to an owned module with its own contract and test, not a copy.

## Testability and the boundary test (MUST)

**MUST** make each module testable without its upper layers: inject ports as effectful function values and test with deterministic fakes (`xylem-platform-ports/SKILL.md:30-34`). **MUST** include a **boundary test** in the design record: a focused fixture that crosses each declared seam, asserts the versioned accept case and a negative refusal case, and runs with the pinned compiler and no upper-layer code (D-003:24-26; `xylem-platform-testing/SKILL.md:26-32`). **MUST** record which checks actually ran; unexecuted checks stay `PENDING_INDEPENDENT_VERIFICATION` (workspace `AGENTS.md:57-63`). **MUST NOT** claim a performance number from a structural boundary change.

## Done when

- [ ] Every module states one responsibility, owner, exposed contract and named consumer; no utility module without a consumer.
- [ ] A labelled dependency diagram exists; all edges point inward/downward; no cycle, sideways or upward edge.
- [ ] Every seam has a `family/vN` identity, registered refusal codes and an additive-only evolution note.
- [ ] One canonical implementation per rule; no mirrored port or duplicated system.
- [ ] A boundary test with a positive and a negative fixture crosses each seam and names the check that ran.

## References

- Web (fetched 2026-11-25): https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html ; https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/hexagonal-architecture.html ; https://semver.org/spec/v2.0.0.html ; https://github.com/microsoft/api-guidelines/blob/master/Guidelines.md .
- Local: `docs/decisions/D-001-platform-layering.md:28-83,85-105,130-141` ; `docs/decisions/D-002-plugin-centric-platform.md:46-65` ; `docs/decisions/D-003-platform-app-conformance.md:14-29` ; `ecosystem-readiness/docs/decisions/D-004-product-surface.md:46-55` ; `docs/decisions/D-005-lotus-port-strategy.md:161-203` ; `docs/decisions/README.md` (ADR-0087) ; `.agents/skills/xylem-platform-module-layout/SKILL.md:16-83` ; `.agents/skills/xylem-platform-api-design/SKILL.md:10-48` ; `.agents/skills/xylem-architecture-boundaries/SKILL.md:12-24` ; `.agents/skills/xylem-platform-ports/SKILL.md:30-34` ; `.agents/skills/xylem-platform-testing/SKILL.md:26-32` ; `lotus/README.md:12-33`. D-00x paths are relative to the `version_2` root; other paths are worktree-relative.
