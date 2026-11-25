---
name: xylem-web-framework
description: Build and review Xylem-native web applications with Aurelia-like .xylem/.view pairs, lifecycle hooks, binding modes, static service plugins and the L4a-to-WASM build path. Use when authoring or reviewing a Xylem web component, view template, binding, lifecycle hook, service plugin, router, or the framework adapter itself; defer compiler performance and browser HTML work.
---

# Xylem web framework

This is the **single source of truth** for Xylem web framework authoring. It is
Aurelia-like in *ergonomics* only: Xylem owns the UI model, the binding rules and
the build path. Read `docs/decisions/D-001`, `D-002`, and
`ecosystem-readiness/DESIGN/WEB_FRAMEWORK.md` for the architecture rationale.
`framework/web/{component,services,router,app}.xy` is the canonical API.

## Authoring surface — DEFAULT TO pairs and conventions

- **Pair by basename.** A component MUST have `<name>.xylem` for state, bindings,
  hooks and handlers, and `<name>.view` for declarative structure. Both MUST
  live in `components/<name>/`. A missing pair is a build error, never a warning.
- **`.view` is Xylem source, not browser HTML.** It MUST use only the declared
  tag subset (`view`, `column`, `row`, `button`, `input`, `text`) and
  `data-xylem-*` attributes. Browser DOM, CSS, JavaScript, `<script>`, `<style>`,
  hydration markers and arbitrary HTML tags are outside the language.
- **Bindings are declared twice and checked once.** A binding path in the
  `.xylem` component MUST appear as a `data-xylem-*` attribute in the `.view`,
  and vice versa. The L7 checker (`examples/web-framework-aurelia/tools/check_components.py`)
  MUST reject undeclared or unused bindings with a typed diagnostic.
- **Binding modes are closed.** Use only `one-time`, `to-view`, `from-view` and
  `two-way`. Each mode MUST be represented as a closed write set on contiguous
  state; no runtime observer, proxy or change-tracking object is permitted.

## Styling — MUST be token-first

The portable styling contract is L4a `UiLayout` + `UiStyle.tokens` + theme tokens,
not CSS. The web adapter maps tokens to inline custom properties; native adapters
map the same tokens to native widget styling. Tailwind is an **L4b web styling
tool**: `xylem-web/styles.rs` compiles `app.css` with a pinned Tailwind v4 engine
and `tailwind.lock` for the web build only.

- MUST express shared styling as semantic tokens (`surface`, `accent`, spacing,
  typography roles) in the component model and `.view` metadata.
- MUST treat Tailwind utility names as token-producing conveniences only; a
  utility that cannot map to a token is web-only and marked DEFERRED.
- MUST NOT put raw CSS, selectors, pseudo-classes, media queries, animations or
  browser-only layout rules in `.view`. Those are web-only escape hatches and are
  DEFERRED for desktop/mobile.
- MUST NOT claim styling parity across web/desktop/mobile. Only the token subset
  is portable; native adapters decide how each token renders.

## Lifecycle — MUST be explicit and ordered

The canonical order is `created, binding, bound, attaching, attached, detaching,
unbinding, disposed`. A component declares a subset by name; the framework runs
only declared hooks, in canonical order, and emits a deterministic trace. A hook
MUST be a pure, effect-typed handler over the component state. No Promise, async
runtime, timer or hidden callback registration is allowed. An unknown hook name
is refused; it is never silently ignored.

## Plugins and services — MUST be static

- Services and plugins MUST register in a compile-time, versioned table via
  `framework/web/services.xy`. Never add a runtime DI container, `resolve()`
  discovery, reflection or a global mutable registry.
- Each plugin carries a namespaced id, exact major version, capabilities and a
  trust label. A missing or ambiguous provider MUST be refused explicitly.
- Route definitions are declarative data using `framework/web/router.xy` and
  `std/web/navigation`. Browser History, regex guards and async route hooks are
  deferred; do not imitate them locally.

## Build path — KEEP THE BOUNDARY HONEST

```text
.xylem + .view -> framework model -> L4a UiDocument -> xylem web build --ui -> WASM + runtime.js + generated HTML
```

- The `.view` → `UiDocument` adapter (`framework/web/tools/emit_l4a.py`) MUST emit
  a bare `UiDocument { root, theme }`, because `xylem-web::load_ui_document`
  deserializes that exact shape. Do not emit the outer `UiApplication` fixture.
- L4a has five element kinds (`Column`, `Row`, `Button`, `TextInput`, `Canvas`)
  and five event kinds (`Click`, `Input`, `Submit`, `Change`, `KeyDown`). A view
  construct that cannot map MUST be reported as DEFERRED with a typed diagnostic;
  never invent a new L4a kind or silently drop a binding.
- Element bindings are named `text`, `show` and `value` — these become
  `data-xylem-text`, `data-xylem-show` and `data-xylem-bind` in the generated
  HTML. `Conditional` produces `data-xylem-if`. `Collection` produces keyed rows.
- The orchestrator (`framework/web/tools/build_web.py`) validates pairs, emits
  the `UiDocument` and prepares the exact `xylem web build --ui <file>` invocation.
  It MUST NOT execute browser builds, install dependencies or contact a network.
- WASM stays numeric-only: one state pointer, numeric exports, no JS object
  handles and no `wasm-bindgen` heap. DOM mutation remains in the existing
  `runtime.js` adapter. No VDOM, HTML parser, hydration or component-private
  runtime state.

## Verification — NEVER claim unrun passes

Run pinned-compiler `check`/`run`/`test` for every new Xylem module and fixture;
diff every expected-output file byte-for-byte; run the Python checker's unit
tests and the full ecosystem sweep. Record exact commands, exit codes and
artifact hashes. Self-produced evidence is `PENDING_INDEPENDENT_VERIFICATION`
until another agent reproduces it. No performance number may be asserted here;
the protected compiler campaign owns benchmarking.

## Done when

- Every component has a validated `.xylem`/`.view` pair and deterministic trace.
- Bindings, modes, hooks, services and routes have positive and negative fixtures.
- The adapter emits a schema-valid `UiDocument` and lists every DEFERRED construct.
- The orchestrator prepares a build command without executing a browser build.
- All verification commands actually ran and their outputs are recorded.

## References

- Local: `docs/decisions/D-001-platform-layering.md`; `D-002-plugin-centric-platform.md`;
  `ecosystem-readiness/DESIGN/WEB_FRAMEWORK.md:82,112,167`;
  `framework/web/{component,services,router,app}.xy`;
  `framework/web/tools/{emit_l4a,build_web}.py`;
  `examples/web-framework-aurelia/README.md`;
  `xylem-platform/crates/xylem-web/src/{lib.rs:478-494,ui.rs:173-206}`;
  `xylem-rust/crates/xylem-wasm/src/lib.rs:1256-1259,2024`.
- External (official; fetched 2026-11-25):
  https://docs.aurelia.io/introduction/the-aurelia-philosophy ;
  https://docs.aurelia.io/components/component-lifecycles ;
  https://docs.aurelia.io/templates/overview/attribute-binding ;
  https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules ;
  https://rustwasm.github.io/book/reference/js-ffi.html ;
  https://webassembly.org/docs/faq/ .
