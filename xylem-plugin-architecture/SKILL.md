---
name: xylem-plugin-architecture
description: Design plugin-centric Xylem systems where the core owns contracts and ports and versioned plugins implement them. Use for capability negotiation, lifecycle, trust levels, budgets, provider ambiguity, plugin manifests and decisions about adding a plugin to an existing platform seam.
---

# Xylem plugin architecture

The platform is a **small core plus versioned plugins**: the core owns only the contracts that must be identical everywhere, and every target, backend, service or tool is an optional plugin behind a stable interface (D-002:9-12). This skill states the plugin-system rules; defer contract identity and refusal depth to `xylem-platform-api-design` (`.agents/skills/xylem-platform-api-design/SKILL.md:10-48`), host-injected port mechanics to `xylem-platform-ports` (`:8,21-34`), Lotus's minimal manifest to `xylem-lotus-kernel` (`:10-17`), placement to `xylem-app-design` (`:14-24`) and verification to `xylem-platform-testing` (`:26-32`).

## Ownership and no second system (MUST)

**MUST** put each port in the layer that owns the abstraction: rendering in L4a, readiness/input/surface in L3, capabilities in L2; a plugin implements the port and never defines or mirrors it (D-001:72-83). The existing `UiApplication`/capability seam **is** the plugin host — "do not build a second one" (D-002:15-23). **MUST** include a **plugin-boundary map** in every design record, listing each core seam, each plugin, the versioned contract it implements, its capabilities, dependencies and lifecycle per plugin (D-002:34-45; `xylem-app-design/SKILL.md:14-24`). **MUST NOT** create a parallel plugin registry, capability catalog, UI model, CLI/LSP or distribution layer alongside an existing one (D-005:188-196; `xylem-app-delivery/SKILL.md:49-53`).

## Versioned manifest and negotiation (MUST)

**MUST** give every plugin a manifest with `id`, `version`, `contract`, `capabilities` and declared dependencies; this mirrors `lotus/contracts/plugin.xy:14-19` and the `lotus.plugin/v1` schema (`lotus/schemas/lotus.plugin/v1.schema.json`: namespaced `id`, `x.y.z` `version`, exact `contract`, closed capability enum). **MUST** parse identity through one grammar (`contract_id`/`parse_contract_id`) and refuse a wrong family as malformed and a known family with any other major as unsupported — never default or substitute (D-005:194-196; `xylem-platform-api-design/SKILL.md:16-20`). **MUST** negotiate declared capabilities against host-supplied providers with exactly one match: zero providers and duplicate/conflicting providers are both explicit refusals with registered codes, and the resolved list keeps declaration order (`lotus/contracts/manifest.xy:317-370`; `lotus/contracts/plugin.xy:75-107`). **MUST NOT** sniff features, upgrade/downgrade a major, or fabricate support; unsupported capabilities produce a typed diagnostic and graceful degradation (D-002:62-63; D-001:107-114). SemVer makes the contract meaningful: a released version is immutable and incompatible changes ship as a new major (https://semver.org/spec/v2.0.0.html).

## Lifecycle, trust and budgets (MUST)

**MUST** define `register`/`start`/`stop`/`shutdown` with explicit error paths for every plugin (D-002:43-45; Eclipse plug-in architecture, activation/deactivation via `startup`/`shutdown` at https://www.eclipse.org/articles/Article-Plug-in-architecture/plugin_architecture.html). **MUST** prefer static/compile-time registration tables; dynamic loading is a later, separately gated capability, and lazy instantiation is permitted only after the contract is validated (D-002:48-50; Eclipse extension processing, §3.3). **MUST** declare trust level and resource budget explicitly — capabilities are granted, not ambient: "a component without a filesystem import cannot read files; a component without a network import cannot open sockets" (https://wasi.dev/security). Deny-by-default is the reference shape: "--deny-* flags take precedence over the allow flags" (https://docs.deno.com/runtime/reference/permissions/). A plugin with no import for a resource cannot reach it, even in the same process (WASM Component Model, Worlds: https://component-model.bytecodealliance.org/design/worlds.html). **MUST** treat untrusted code as outside the trust boundary: "Untrusted code cannot be safely loaded into a trusted .NET process" (https://learn.microsoft.com/en-us/dotnet/core/tutorials/creating-app-with-plugin-support). **MUST NOT** exceed the declared budget silently or hide a fallback; an exhausted budget is a typed refusal, and this campaign makes no benchmark or performance claim (D-005:199-200).

## State, IO and hot paths (MUST)

**MUST** keep all state in the core or an explicit plugin instance, passed by borrow; **MUST NOT** use a global mutable plugin registry, hidden singleton or sideways plugin call (D-002:51-57; D-001:95-103). **MUST** inject OS/IO as host-owned function ports; no plugin compiles in a host intrinsic, concrete adapter, socket, clock or RNG (`xylem-platform-ports/SKILL.md:27-28`; `lotus/README.md:129-148`). **MUST** route plugin-to-plugin communication through core interfaces; cycles are rejected at load/init (D-002:56-57). **MUST NOT** box per call or use reflection in a hot path: typed versioned interfaces keep hot loops in the core or plugin, not behind a generic dispatcher (D-002:51-53).

## Negative fixtures and completion (MUST)

**MUST** supply negative fixtures for a **missing provider** and an **ambiguous/conflicting provider**, plus a wrong-major manifest and an unknown capability, each asserting its registered code and byte-exact output (`lotus/contracts/manifest.xy:354-365`; `xylem-platform-api-design/SKILL.md:29-33`; `xylem-app-design/SKILL.md:10-12`). **MUST** give each plugin focused correctness fixtures runnable without the full platform (D-002:64-65).

## Done when

- [ ] Every plugin appears in a boundary map with versioned contract, capabilities, dependencies and lifecycle.
- [ ] The manifest uses one identity grammar; wrong family, wrong major and unknown capability are refused.
- [ ] Missing and ambiguous providers each have a negative fixture with a registered refusal code.
- [ ] Lifecycle, trust level and budget are explicit; static registration is the default.
- [ ] No global mutable registry, second plugin system, sideways call, host IO in a plugin or unrun check remains.

## References

- Web (fetched 2026-11-25): https://www.eclipse.org/articles/Article-Plug-in-architecture/plugin_architecture.html ; https://eclipse.dev/eclipse/markdown?file=eclipse-pde%2Feclipse.pde%2Fmaster%2Fdocs%2FUser_Guide.md ; https://component-model.bytecodealliance.org/design/worlds.html ; https://github.com/WebAssembly/WASI/blob/main/docs/DesignPrinciples.md ; https://wasi.dev/security ; https://learn.microsoft.com/en-us/dotnet/core/tutorials/creating-app-with-plugin-support ; https://semver.org/spec/v2.0.0.html ; https://docs.deno.com/runtime/reference/permissions/ .
- Local: `docs/decisions/D-001-platform-layering.md:72-83,95-114` ; `docs/decisions/D-002-plugin-centric-platform.md:9-65` ; `docs/decisions/D-003-platform-app-conformance.md:14-29` ; `docs/decisions/D-005-lotus-port-strategy.md:188-203` ; `lotus/contracts/plugin.xy:14-19,60-135` ; `lotus/contracts/manifest.xy:317-370` ; `lotus/schemas/lotus.plugin/v1.schema.json` ; `lotus/README.md:129-148` ; `.agents/skills/xylem-platform-api-design/SKILL.md:10-48` ; `.agents/skills/xylem-platform-ports/SKILL.md:8,21-34` ; `.agents/skills/xylem-lotus-kernel/SKILL.md:10-17` ; `.agents/skills/xylem-app-design/SKILL.md:10-24` ; `.agents/skills/xylem-app-delivery/SKILL.md:49-53`. D-00x paths are relative to the `version_2` root; other paths are worktree-relative.
