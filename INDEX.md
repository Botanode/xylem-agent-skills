# Xylem agent skills index

Canonical source repository: `https://github.com/Botanode/xylem-agent-skills`.
This directory is an installed copy; regenerate from that repository after changes.

**Unified catalog:** `SKILL-CATALOG.md` is the single list of all 106 in-house
skills (77 engineering pack + 12 platform/ecosystem + 17 existing compiler and
quality skills). Register new skills there. Validate the whole library with
`python3 .agents/skills/validate.py`. The pack's `AGENTS.md` routing rules are
summarized in the repository `AGENTS.md` under "Skill routing". Backend work rooted in
`xylem-rust` keeps its skill at `xylem-rust/.agents/skills/xylem-native-codegen`.
Both repositories' AGENTS.md should point to this index.

## Skills

| Skill | Purpose | When to activate | Status of core claims |
|---|---|---|---|
| `xylem-orientation` | What Xylem is, objectives, architecture, current capabilities | First contact with the project; explaining Xylem | Needs language-facts research |
| `xylem-language` | Valid syntax and semantics; examples; diagnostics | Writing or reading Xylem source | Needs language-facts research |
| `xylem-types-and-memory` | Type system, representation, allocation, ownership, lifetime | Reasoning about values/copies/allocations | Needs runtime research |
| `xylem-efficient-code` | Writing efficient Xylem for the compiler that exists today | Performance-sensitive application code | Needs runtime/collections research |
| `xylem-collections-and-strings` | Map/Vec/String APIs and their real costs | Collection-heavy code | Needs collections research |
| `xylem-hot-paths-and-abi` | Source → representation → ABI → runtime calls → machine code | Hot-path or ABI investigation | Needs runtime research |
| `xylem-compiler-architecture` | Stage map and safe compiler modification workflows | Changing the compiler | Verified from source |
| `xylem-native-codegen` (xylem-rust) | LLVM/Cranelift lowering, runtime, target features | Backend/runtime changes | Verified from source |
| `xylem-compiler-optimization` | Propose/implement optimizer changes with correctness gates | Compiler optimization work | Verified from source |
| `xylem-optimizer` | Source-facing true → proven → efficient gates for frontend/IR/optimizer/lowering changes | Compiler/optimizer change safety gates | Source-backed; pending independent verification |
| `xylem-pipeline-inspector` | Trace a construct through every stage to assembly | "What does this compile to?" | Verified from source |
| `xylem-performance-analysis` | Root-cause attribution and fair experiments | Slow workload or regression | Verified from records |
| `xylem-testing-and-benchmarking` | Correctness tests, regressions, fair benchmarks | Adding tests/benchmarks | Verified commands |
| `xylem-debugging` | Systematic failure diagnosis | Anything broken | Verified gates/codes |
| `xylem-code-review` | Evidence-supported review | Reviewing changes | Verified criteria |
| `xylem-tooling-and-workflows` | Verified CLI/build/env commands | Any tooling question | Verified commands |
| `xylem-concurrency-and-determinism` | Concurrency status (currently FUTURE) | Asked about threads/tasks | To create; status UNKNOWN/FUTURE |
| `xylem-standard-library-development` | stdlib API/implementation workflow | Adding stdlib functionality | To create if justified |
| `xylem-platform-orientation` | L0–L7 product placement, dependency and version-identity rules | Naming/locating a platform product or crossing a layer boundary | Source-backed; pending independent verification |
| `xylem-platform-code-style` | Opinionated naming, effect-row order, refusals and ownership idioms | Writing or reviewing `.xy` platform source | Source-backed; pending independent verification |
| `xylem-platform-module-layout` | Canonical folder/file layout for libraries, Lotus kernel and apps | Adding/splitting a module, naming tests, placing fixtures | Source-backed; pending independent verification |
| `xylem-platform-api-design` | Versioned contracts, explicit refusals, additive-only evolution | Designing or changing a platform API | Source-backed; pending independent verification |
| `xylem-platform-ports` | Host-injected effectful function ports and their rules | Defining/using a port or a deterministic stub | Source-backed; pending independent verification |
| `xylem-lotus-kernel` | Xylem-native Lotus port structure, pin and substitutions | Working in `lotus/` | Source-backed; pending independent verification |
| `xylem-platform-testing` | Pinned-compiler fixtures, negative cases and independent verification | Adding or certifying platform tests | Source-backed; pending independent verification |
| `xylem-platform-performance-guardrails` | Anti-boxing, single-pass and stable-boundary rules | Reviewing platform hot paths or structure | Source-backed; pending independent verification |
| `xylem-platform-review` | Platform-change review checklist | Reviewing a platform/app/ecosystem change | Source-backed; pending independent verification |
| `xylem-platform-app-archetypes` | Canonical web/server/desktop/mobile app shapes | Creating or reviewing a platform example | Source-backed; pending independent verification |
| `xylem-platform-documentation` | README/phase-log/decision-record policy and doc gates | Writing or reconciling project docs | Source-backed; pending independent verification |
| `xylem-agent-workflow` | Worktrees, ownership, pinned verification and integration gates | Dispatched task or completion record | Source-backed; pending independent verification |
| `xylem-app-research` | Evidence-ranked research before app design | Researching a Xylem app's problem domain and constraints | Source-backed; pending independent verification |
| `xylem-app-design` | Opinionated app architecture and acceptance criteria | Designing a Xylem application | Source-backed; pending independent verification |
| `xylem-app-implementation` | Write Xylem source incrementally with pinned checks | Implementing an app unit | Source-backed; pending independent verification |
| `xylem-app-build` | Compile/build with pinned tool identity and build record | Building or compiling an app | Source-backed; pending independent verification |
| `xylem-app-verification` | Prove app correctness with fixtures and independent verifier | Verifying an app | Source-backed; pending independent verification |
| `xylem-app-delivery` | Seven-gate app delivery method with STOP conditions | Taking an app from research to integration | Source-backed; pending independent verification |
| `xylem-modular-design` | Opinionated module boundaries and dependency direction | Splitting modules or reviewing boundaries | Source-backed; pending independent verification |
| `xylem-plugin-architecture` | Plugin-centric core/plugin contracts, lifecycle and trust | Designing a plugin system | Source-backed; pending independent verification |
| `xylem-extension-points` | Where and how to add extension points without sprawl | Adding an extension seam to an app | Source-backed; pending independent verification |
| `xylem-web-framework` | Aurelia-like Xylem web authoring and L4a/WASM build path | Authoring or reviewing web components, views, bindings, hooks or plugins | Source-backed; pending independent verification |

## Coverage matrix

| Area | Skills |
|---|---|
| Language semantics | orientation, language, types-and-memory |
| Compiler internals | compiler-architecture, compiler-optimization, pipeline-inspector |
| Backend/codegen | native-codegen, hot-paths-and-abi |
| Performance | efficient-code, collections-and-strings, performance-analysis |
| Quality engineering | testing-and-benchmarking, debugging, code-review |
| Environment | tooling-and-workflows |
| Concurrency / stdlib | optional skills, status depends on verified support |
| Platform architecture | platform-orientation, lotus-kernel |
| Platform source conventions | platform-code-style, platform-module-layout, platform-api-design, platform-ports |
| Platform quality | platform-testing, platform-performance-guardrails, platform-review |
| Platform products | platform-app-archetypes, platform-documentation, agent-workflow |
| Application delivery | app-research, app-design, app-implementation, app-build, app-verification, app-delivery |
| Modular / plugin design | modular-design, plugin-architecture, extension-points |
| Web framework | web-framework |

## Rules for all skills

- Policy lives in each repository's `AGENTS.md`; skills execute it, never restate it.
- LLVM is the release backend; Cranelift is development-only.
- Three milestones: implemented → proven correct → demonstrated improvement.
- No box ticked and no gain claimed without an independent verifier.
- Evidence labels: VERIFIED / MEASURED / INFERRED / HYPOTHESIS / PLANNED / UNKNOWN.
- Source-of-truth hierarchy is in `xylem-lang/docs/development/SKILLS_IMPLEMENTATION_INVENTORY.md`.

## Maintenance

See `MAINTENANCE.md` in this directory. Update the skills when the compiler,
runtime, CLI, stdlib, or performance evidence changes; re-validate examples and
remove obsolete workarounds.
