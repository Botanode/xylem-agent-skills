---
name: xylem-app-design
description: Design a high-quality Xylem application with measurable consumer-level acceptance criteria, L0-L7 placement, module and effect ownership, versioned contracts, refusal codes, fixtures and an ADR for durable tradeoffs. Use before writing implementation source or when reviewing another agent's design record.
---

# Xylem app design

This skill owns the **design slice of app delivery**. It sequences existing depth skills; it does not restate them. Use `xylem-app-research` first for the citation-backed facts this record relies on. Defer layer placement to `xylem-platform-orientation` (`.agents/skills/xylem-platform-orientation/SKILL.md:12-99`), ADR mechanics to `xylem-architecture-decision` (`:14-24`), version/refusal vocabulary to `xylem-platform-api-design` (`:10-48`), example shapes to `xylem-platform-app-archetypes` (`:23-93`) and file layout to `xylem-platform-module-layout` (`:34-115`).

## Acceptance criteria before structure (MUST)

**MUST** write measurable criteria first, each stating an observable artifact: exit status, byte-exact stdout, a named `UMS-REF-*` code, a fixture pair outcome, or a refused request. **MUST** include at least one **negative case** (unknown major → `UMS-REF-0009`, malformed id → `UMS-REF-0048`) and at least one **consumer-level criterion** phrased as what an external caller observes, not which internal function is called; contract-by-example testing is defined by Pact (`https://docs.pact.io/`). **MUST NOT** write a criterion that can pass without crossing the boundary it governs. **MUST** make each criterion checkable with the pinned compiler; **MUST NOT** include a performance or benchmark claim (D-003:24-26; D-005:199-200).

## Placement and boundaries (MUST)

**MUST** name the layer: an application is L6, a framework/service is L5, and neither owns L0/L1 (`docs/decisions/D-001-platform-layering.md:28-68`). **MUST** list every dependency edge and show it points downward; any upward or sideways call must be redirected through a port owned by the lower layer (`:72-93`). **MUST** include a plugin-boundary map with id, api_version, capabilities and lifecycle per D-002 (`:34-45,46-65`). **MUST** name product-internal layers `<product>.A2..A7` if Lotus-style layers are used (D-005:161-186). **MUST NOT** duplicate the L4a UI model, the L2 capability system, the plugin registry, or any adapter; **MUST NOT** reach into L3/L1/L0 or sibling adapter internals.

## Module, ownership and effect table (MUST)

For each module **MUST** state: state owned, exposed contract, effect row, injected ports and injector. Effect rows MUST be capability-first with `allocation` last (`.agents/skills/xylem-platform-code-style/SKILL.md:34-48`), and an injected function's row MUST be propagated unchanged. **MUST** express the design as one canonical implementation per behavior; **MUST NOT** hide global mutable state or add a second compatibility predicate. **MUST** plan validation, indexing and layout as one pass per state change with contiguous storage and borrowed views, not repeated whole-tree scans or boxed per-node values (D-001:103-105; `.agents/skills/xylem-platform-performance-guardrails/SKILL.md`). This is a structural rule for design review, not a measured performance claim: the design record states invariants and defers all cost evidence to the protected compiler campaign.

## Contracts, refusals and fixtures (MUST)

**MUST** give every boundary a `family/vN` identity built by `contract_id`, parsed only through `parse_contract_id`; **MUST** select refusal codes from the closed registered set and route fallible paths through `Result<T, Refusal>` (defer depth to `xylem-platform-api-design`). **MUST** specify an accept fixture, a reject fixture and a byte-exact expected-output report for each contract, with no default on unknown input (D-003:14-29; `xylem-platform-testing/SKILL.md:26-32`).

## Durable tradeoffs (MUST)

**MUST** write one ADR per architecturally significant tradeoff using Context / Decision / Status / Consequences (Nygard, `https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions`; `https://adr.github.io/`), with rejected alternatives, testable invariants, migration gate and rollback. Keep status `proposed` until accepted by authorized governance. **MUST NOT** leave a durable tradeoff recorded only in chat or prose outside an ADR. **MUST** reject speculative features that have no acceptance criterion.

## Design record — reviewable without the author (MUST)

**MUST** produce a single record containing, in order: acceptance criteria; layer and dependency matrix; plugin-boundary map; module/ownership/effect table; contract and refusal table; fixture list; ADR links; out-of-scope list; open questions with labels. **DEFAULT TO** `PENDING_INDEPENDENT_VERIFICATION` on every claim until a second agent reproduces it (`AGENTS.md:57-63`).

## Done when

- Each acceptance criterion is measurable, includes a negative or consumer case, and maps to a fixture.
- Layer, downward-only edges, plugin map and `<product>.A2..A7` namespace (if used) are explicit.
- Every module names its state, effects and port owner; every contract names its version and refusal codes.
- At least one ADR exists for each durable tradeoff, with alternatives and migration gate.
- No speculative feature, duplicated Xylem layer, or performance claim remains.

## References

- Web (fetched 2026-11-25): https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions ; https://adr.github.io/ ; https://docs.pact.io/ ; https://cloud.google.com/apis/design ; https://scrumguides.org/
- Local: `docs/decisions/D-001-platform-layering.md:28-93` ; `docs/decisions/D-002-plugin-centric-platform.md:9-65` ; `docs/decisions/D-003-platform-app-conformance.md:14-29` ; `docs/decisions/D-005-lotus-port-strategy.md:161-203` ; `docs/decisions/D-006-in-house-agent-skills.md:18-30` ; `.agents/skills/xylem-platform-orientation/SKILL.md:12-99` ; `.agents/skills/xylem-platform-api-design/SKILL.md:10-48` ; `.agents/skills/xylem-platform-app-archetypes/SKILL.md:23-93` ; `.agents/skills/xylem-platform-module-layout/SKILL.md:34-115` ; `.agents/skills/xylem-platform-testing/SKILL.md:26-32` ; `AGENTS.md:57-74`. D-00x paths are relative to the `version_2` root; other paths are worktree-relative.
