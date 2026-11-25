---
name: xylem-extension-points
description: Decide where and how to add an extension point in a Xylem app: adapter versus plugin, configuration versus code, seam placement, deterministic registration, diagnostics and fake-implementation tests. Use before adding a seam, a contribution point or a new provider to an existing product.
---

# Xylem extension points

An extension point is a **slot defined by the owner of a stable contract**. Eclipse's formulation is the one Xylem adopts: "the extension point declares a contract ... that extensions must conform to" and "the plug-in being extended knows nothing about the plug-in that is connecting to it beyond the scope of that extension point contract" (https://www.eclipse.org/articles/Article-Plug-in-architecture/plugin_architecture.html). This skill owns the *where and how* decision; it does not restate plugin mechanics (`xylem-plugin-architecture`), port injection (`xylem-platform-ports/SKILL.md:8,21-34`), contract identity (`xylem-platform-api-design/SKILL.md:10-48`) or conformance fixtures (`xylem-platform-testing/SKILL.md:26-32`).

## Adapter or plugin? (MUST)

**MUST** choose before writing code, using this decision rule:

| Situation | Use |
|---|---|
| One known target/provider implements an existing owned port; no negotiation needed | **Adapter** behind the port — e.g. a GTK L4b adapter implementing the L4a rendering port (DESKTOP.md:146-202; SHARED_UI.md:93-113) |
| Several interchangeable providers must be selected by manifest/capability, or a third party supplies one | **Plugin** with manifest, negotiation and lifecycle (`xylem-plugin-architecture`) |
| Behaviour is data (a route, theme token, key binding, lint severity) and needs no code or state | **Configuration**, not a code seam — Eclipse's declarative extensions contribute no code; VS Code `contributes.*` are JSON declarations in the extension manifest (https://code.visualstudio.com/api/references/contribution-points) |
| No consumer can be named | **Do not add a seam at all** |

**MUST NOT** add indirection "for future flexibility" without a present consumer (D-002:46-49; `xylem-platform-module-layout/SKILL.md:66-74`). The maintenance cost of a pluggable seam is justified only when several inputs/outputs or a changing technology actually exist (AWS hexagonal, https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/hexagonal-architecture.html).

## Seam placement (MUST)

**MUST** place the seam at a stable versioned contract owned by the layer that owns the abstraction: rendering in L4a, substrate in L3, capabilities in L2; an adapter that merely mirrors its implementation is not a port (D-001:72-83). **MUST** give each seam a `family/vN` identity and a deterministic extension-point contract in the design record: id, owning layer, exact signature/shape, version, capability requirements, registration order rule, refusal codes and out-of-scope cases (SHARED_UI.md:149-167; GRAPHICS.md:154-181; SERVER_RUNTIME.md:125-132). **MUST** keep the contract single-focus and composable — "a relatively small unit of functionality" (WebAssembly Component Model, Interfaces: https://component-model.bytecodealliance.org/design/interfaces.html). **MUST NOT** put a DOM, widget, GPU-handle or server-only type in an L4a-facing signature (SHARED_UI.md:149-167; SERVER_RUNTIME.md:62-69). **MUST NOT** mirror the seam in the adapter, add a second UI/capability/plugin system, or make L3 depend on L4a (D-001:63,77; D-005:192-193).

## Registration, order and discovery (MUST)

**MUST** make registration and discovery deterministic: prefer an explicit compile-time table, and where contributions are collected, define a total order (declaration order, explicit numeric `order`/`priority`, or sorted id) so two runs produce byte-identical output (`lotus/contracts/plugin.xy:117-135`; `lotus/contracts/manifest.xy:317-322`; VS Code contribution points, `order`/`priority`). **MUST** refuse an unknown contribution, a duplicate id and a missing or ambiguous provider with a registered code rather than silently picking one (`lotus/contracts/manifest.xy:354-365`; `xylem-platform-api-design/SKILL.md:27-33`). **MUST NOT** rely on filesystem enumeration, wall-clock time, Map iteration order, reflection or a global mutable registry for discovery (D-001:95-103; D-002:48-57; Eclipse `IExtensionRegistry` is a host-owned registry, not a global clients implement: https://help.eclipse.org/latest/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/core/runtime/IExtensionRegistry.html).

## Diagnostics and testing (MUST)

**MUST** emit a typed diagnostic for an unsupported extension, unmappable element or ungranted capability, and degrade gracefully — never fabricate support or drop the request silently (D-001:107-114; SHARED_UI.md:136-147). **MUST** include a **fake-implementation test** for every extension point: a host-free function value with a fixed result (a stub port, a fixed clock, an in-memory table) that proves the accept path, plus a negative case proving the refusal path (`xylem-platform-ports/SKILL.md:30-34`; WEB_FRAMEWORK.md:82-99). **MUST** verify that the fake is substituted at the seam without an upper-layer or adapter dependency, and record the pinned check that ran; other claims stay `PENDING_INDEPENDENT_VERIFICATION` (workspace `AGENTS.md:57-63`). **MUST** avoid plugin sprawl: a second seam for a second provider of the same capability is refused when one versioned port already covers it (D-002:9-12,48-50).

## Done when

- [ ] The adapter/plugin/configuration decision is recorded with a named consumer or an explicit "no seam" outcome.
- [ ] An extension-point contract names the owning layer, `family/vN` identity, order rule, refusal codes and out-of-scope cases.
- [ ] Contributions are discovered deterministically; duplicates and ambiguous/missing providers are refused.
- [ ] Unsupported extensions emit typed diagnostics; no silent fallback or fabricated support.
- [ ] A fake-implementation test and a negative refusal fixture pass with the pinned compiler.

## References

- Web (fetched 2026-11-25): https://www.eclipse.org/articles/Article-Plug-in-architecture/plugin_architecture.html ; https://eclipse.dev/eclipse/markdown?file=eclipse-platform%2Feclipse.platform%2Fmaster%2Fdocs%2FFAQ%2FFAQ_What_are_extensions_and_extension_points.md ; https://help.eclipse.org/latest/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/core/runtime/IExtensionRegistry.html ; https://code.visualstudio.com/api/references/contribution-points ; https://component-model.bytecodealliance.org/design/interfaces.html ; https://component-model.bytecodealliance.org/design/worlds.html ; https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/hexagonal-architecture.html ; https://semver.org/spec/v2.0.0.html .
- Local: `docs/decisions/D-001-platform-layering.md:72-83,95-114` ; `docs/decisions/D-002-plugin-centric-platform.md:9-12,34-65` ; `docs/decisions/D-003-platform-app-conformance.md:18-29` ; `docs/decisions/D-005-lotus-port-strategy.md:188-196` ; `ecosystem-readiness/DESIGN/DESKTOP.md:146-202` ; `ecosystem-readiness/DESIGN/SHARED_UI.md:93-167` ; `ecosystem-readiness/DESIGN/WEB_FRAMEWORK.md:82-99,167-197` ; `ecosystem-readiness/DESIGN/GRAPHICS.md:154-181,215-227` ; `ecosystem-readiness/DESIGN/SERVER_RUNTIME.md:62-69,125-132` ; `lotus/contracts/manifest.xy:317-370` ; `lotus/contracts/plugin.xy:117-135` ; `.agents/skills/xylem-plugin-architecture/SKILL.md` ; `.agents/skills/xylem-platform-ports/SKILL.md:8,21-34` ; `.agents/skills/xylem-platform-api-design/SKILL.md:10-48` ; `.agents/skills/xylem-platform-testing/SKILL.md:26-32` ; `.agents/skills/xylem-platform-module-layout/SKILL.md:66-74`. D-00x paths are relative to the `version_2` root; other paths are worktree-relative.
