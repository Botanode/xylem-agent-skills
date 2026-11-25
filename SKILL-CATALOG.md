# Xylem engineering skill catalog

77 specialist skills in 6 domains. Load the smallest applicable set using the native skill tool. The always-on rules belong in AGENTS.md.

## Engineering governance (12)

| Skill ID | Purpose |
|---|---|
| `xylem-mission-ownership` | Own a compiler task through integration and verification, including cross-repository dependencies. |
| `xylem-source-truth` | Establish current source and specification truth before implementing or diagnosing. |
| `xylem-architecture-boundaries` | Prevent compiler subsystems from becoming duplicated or tightly coupled projects. |
| `xylem-architecture-decision` | Make durable architecture decisions with explicit tradeoffs and migration gates. |
| `xylem-scope-and-change-control` | Keep implementation bounded and avoid speculative rewrites or silent requirement changes. |
| `xylem-dependency-closure` | Resolve missing symbols, stubs, outdated registries and unimplemented prerequisites. |
| `xylem-technical-debt` | Identify architectural shortcuts and prevent them from becoming permanent compiler infrastructure. |
| `xylem-review-and-integration` | Review a change as an integrated compiler product rather than an isolated patch. |
| `xylem-mission-state` | Persist a dependency-aware mission ledger across sessions, agents and context compaction. |
| `xylem-agent-coordination` | Coordinate multiple agents without overlapping edits, builds or false delegation claims. |
| `xylem-blocker-triage` | Distinguish resolvable engineering work from genuine external blockers. |
| `xylem-regression-control` | Prevent regressions from being ignored because they predate a change. |

## Language and compiler correctness (16)

| Skill ID | Purpose |
|---|---|
| `xylem-language-semantics` | Implement language behavior from explicit semantics rather than C or Rust assumptions. |
| `xylem-lexer-parser` | Maintain robust lexing, parsing, syntax recovery and source spans. |
| `xylem-name-resolution` | Implement correct binding, scope, imports and symbol identity. |
| `xylem-type-system` | Implement sound type checking, inference, coercions and type errors. |
| `xylem-generics-specialization` | Implement generics with correct substitution, representation and bounded compilation cost. |
| `xylem-compiler-diagnostics` | Produce precise actionable diagnostics without panic or silent recovery. |
| `xylem-ir-design` | Define typed IR contracts and avoid lowering semantics into unstructured helper calls prematurely. |
| `xylem-ir-verification` | Detect malformed compiler IR before optimization, code generation or linking. |
| `xylem-control-flow` | Lower branches, loops, calls and exits without changing evaluation or cleanup semantics. |
| `xylem-numeric-semantics` | Preserve integer widths, overflow, shifts, casts, comparisons and floating-point rules. |
| `xylem-layout-and-alignment` | Maintain correct target-aware type sizes, padding, alignment and discriminants. |
| `xylem-aggregate-lowering` | Lower structs, tuples, enums and composite values to sound native storage. |
| `xylem-reference-aliasing` | Preserve reference lifetimes, provenance, mutability and alias guarantees. |
| `xylem-ownership-and-cleanup` | Maintain correct ownership transfers, drops and cleanup across every path. |
| `xylem-capabilities-and-effects` | Preserve capability or effect guarantees where they are specified by Xylem. |
| `xylem-concurrency-semantics` | Implement and validate supported concurrency, atomics and asynchronous behavior. |

## Native representation and performance (17)

| Skill ID | Purpose |
|---|---|
| `xylem-native-representation` | Prevent a dynamic boxed representation from becoming the default for statically typed values. |
| `xylem-scalar-native-lowering` | Emit machine-level scalar operations with correct types and edge semantics. |
| `xylem-call-abi` | Maintain efficient and compatible native call, return and foreign-function conventions. |
| `xylem-allocation-engineering` | Find and reduce unnecessary allocation traffic without changing object lifetimes. |
| `xylem-refcount-engineering` | Reduce retain/release overhead without breaking ownership or concurrency. |
| `xylem-string-representation` | Implement efficient strings and byte buffers with correct encoding and lifetime semantics. |
| `xylem-vector-array-lowering` | Implement typed contiguous arrays/vectors without per-element boxing where semantics permit. |
| `xylem-map-hash-table` | Design and optimize maps without compromising hashing, equality or collision safety. |
| `xylem-compiler-interning` | Optimize identifier/string interning and compiler symbol lookups safely. |
| `xylem-escape-analysis` | Use escape and lifetime facts to eliminate unnecessary heap storage or copies. |
| `xylem-optimization-legality` | Require a semantic proof or conservative condition for every optimization transformation. |
| `xylem-optimization-pipeline` | Maintain an effective and predictable optimization pipeline rather than indiscriminate pass additions. |
| `xylem-simd-vectorization` | Introduce vector operations only when target support and scalar equivalence are established. |
| `xylem-intrinsic-contracts` | Keep intrinsic definitions, semantics, lowering and benchmark registries synchronized. |
| `xylem-cpu-microarchitecture` | Diagnose CPU performance with evidence instead of guessing from instruction counts. |
| `xylem-performance-root-cause` | Prioritize physical execution costs over speculative optimizer work. |
| `xylem-compile-time-performance` | Improve compiler throughput and memory use without conflating compilation with program speed. |

## Backend, runtime and toolchain (11)

| Skill ID | Purpose |
|---|---|
| `xylem-backend-parity` | Keep LLVM, Cranelift and other supported backends semantically aligned. |
| `xylem-llvm-lowering` | Lower Xylem IR into legal LLVM IR with correct target data, attributes and semantics. |
| `xylem-cranelift-lowering` | Lower Xylem IR into valid Cranelift IR with native representations and ABI consistency. |
| `xylem-native-backend` | Develop the native code generation path without assuming completeness from repository naming. |
| `xylem-runtime-contracts` | Maintain runtime helper contracts and prevent runtime fallbacks from swallowing compiler responsibilities. |
| `xylem-ffi-and-linking` | Validate foreign calls, symbol resolution, object generation and linker compatibility. |
| `xylem-debug-info` | Investigate debug metadata failures instead of dismissing them as unrelated noise. |
| `xylem-toolchain-provenance` | Prevent stale compiler/backend binaries and misleading measurements. |
| `xylem-reproducible-builds` | Make compiler and lab builds repeatable within known environment constraints. |
| `xylem-cross-repo-integration` | Integrate compiler, language spec, platform, backend and lab changes as one compatible product. |
| `xylem-fixture-driver-integration` | Implement benchmark fixture hooks as real runtime/compiler integrations, not stubs. |

## Verification and security (10)

| Skill ID | Purpose |
|---|---|
| `xylem-minimal-reproducer` | Reduce compiler failures to a stable, actionable test case. |
| `xylem-differential-testing` | Compare semantics across compiler versions, backends and independent reference implementations. |
| `xylem-property-and-fuzz-testing` | Discover compiler defects with bounded generative and metamorphic tests. |
| `xylem-test-design` | Build meaningful unit, integration, negative and end-to-end tests rather than superficial coverage. |
| `xylem-compiler-torture-tests` | Exercise adversarial but bounded programs across the full compiler pipeline. |
| `xylem-translation-validation` | Check transformations or lowering against source-level semantics using bounded formal or executable models. |
| `xylem-unsafe-code-review` | Review unsafe compiler/runtime code for soundness rather than trusting successful tests. |
| `xylem-compiler-security` | Protect the compiler/runtime and benchmark harness against malformed input and unsafe defaults. |
| `xylem-host-execution-safety` | Preserve benchmark host authorization, isolation, locking and resource limits. |
| `xylem-resource-aware-builds` | Control CPU, memory, disk and process concurrency during compiler work. |

## Benchmark evidence and measurement (11)

| Skill ID | Purpose |
|---|---|
| `xylem-benchmark-admissibility` | Decide whether each benchmark result is valid before computing ratios or aggregates. |
| `xylem-workload-equivalence` | Ensure Xylem, Rust and C perform the same meaningful work before timing. |
| `xylem-benchmark-catalog` | Maintain a meaningful, representative benchmark suite rather than cherry-picked passing cases. |
| `xylem-benchmark-protocol` | Freeze and validate benchmark methodology before collecting timed samples. |
| `xylem-benchmark-statistics` | Compute honest performance comparisons from admissible raw samples. |
| `xylem-benchmark-fixtures-and-oracles` | Make deterministic shared fixtures and independently justified expected outputs. |
| `xylem-benchmark-execution-pipeline` | Integrate build, verify, run, cancellation, sample persistence and reporting into a real workflow. |
| `xylem-profiling-and-counters` | Use hardware/software profiling to locate actual bottlenecks without inventing measurements. |
| `xylem-performance-regression-gates` | Prevent speed improvements in one area from hiding correctness, resource or other workload regressions. |
| `xylem-evidence-and-claims` | Make every performance, correctness and completion claim auditable. |
| `xylem-benchmark-readiness-review` | Independently determine whether the compiler and lab can start the full benchmark campaign. |

## Platform ecosystem (12)

| Skill ID | Purpose |
|---|---|
| `xylem-platform-orientation` | Place a Xylem platform product in the L0–L7 stack and apply the dependency, port and version-identity rules. |
| `xylem-platform-code-style` | Apply Xylem platform source conventions for naming, effect rows, errors and ownership. |
| `xylem-platform-module-layout` | Create and review the canonical folder/file layout for Xylem platform libraries, Lotus kernel modules and example applications. |
| `xylem-platform-api-design` | Design and evolve versioned Xylem platform contracts with explicit refusal and a stable error taxonomy. |
| `xylem-platform-ports` | Add or change a host-injected Xylem platform port and its deterministic tests. |
| `xylem-lotus-kernel` | Work in the Xylem-native Lotus kernel at L2b — contracts, ports, pure modules and schemas — without importing the Rust runtime. |
| `xylem-platform-testing` | Verify Lotus/Xylem platform contract changes with the pinned compiler; add byte-exact tests, negative fixtures, metamorphic checks and validator tests. |
| `xylem-platform-performance-guardrails` | Translate verified Xylem compiler inefficiencies into design-time rules for platform products. |
| `xylem-platform-review` | Review a Xylem platform/ecosystem change against the v2 layering contract, port ownership, refusal codes, fixtures, doc gates, protected paths and verification evidence. |
| `xylem-platform-app-archetypes` | Create or review a Xylem platform example app for the web, server, desktop or mobile product family. |
| `xylem-platform-documentation` | Maintain Xylem platform documentation using the project's README/phase-log/decision-record surface, honest status and evidence labels, doc-gate snapshots and archive discipline. |
| `xylem-agent-workflow` | Operate as an in-house Xylem agent — isolated worktree and branch, ownership verification, protected areas, pinned compiler, focused verification, A004 integration gate, merge ordering, push policy, defect handover and evidence-bearing final reports. |

Total unified in-house library: 106 skills (77 pack + 12 platform + 17 existing compiler/quality).

## Existing compiler and quality (17)

| Skill ID | Purpose |
|---|---|
| `xylem-code-review` | Review Xylem application or compiler changes for correctness, maintainability and evidence-backed performance. |
| `xylem-collections-and-strings` | Use Xylem's Vec, Map, Set and String APIs correctly and efficiently. |
| `xylem-compiler-architecture` | Navigate and safely modify the Xylem compiler — stage order, frontend, IR, optimizer, lowering, backend selection, runtime integration, diagnostics and tests. |
| `xylem-compiler-optimization` | Propose and implement Xylem compiler optimizations with correctness proofs and measured evidence. |
| `xylem-concurrency-and-determinism` | Understand Xylem's implemented deterministic concurrency model and its current limitations. |
| `xylem-debugging` | Systematically debug Xylem programs and the Xylem compiler — syntax/type errors, unsupported features, compiler crashes, runtime traps, wrong output, backend inconsistencies, optimization-dependent failures, linking and performance anomalies. |
| `xylem-efficient-code` | Write and review performance-sensitive Xylem source for the compiler that exists today. |
| `xylem-hot-paths-and-abi` | Trace high-frequency Xylem operations through representation, ABI, runtime calls and generated machine code. |
| `xylem-language` | Write valid Xylem source using the implemented grammar, semantics and edition rules. |
| `xylem-optimizer` | Xylem compiler changes in xylem-lang must be true, proven, efficient. |
| `xylem-orientation` | Explain what Xylem is, why it exists, its design objectives, repository responsibilities, compiler/runtime/backend architecture, current capabilities and limitations, and where authoritative information lives. |
| `xylem-performance-analysis` | Investigate and explain real Xylem performance, classify root causes, and design fair experiments. |
| `xylem-pipeline-inspector` | Trace a specific piece of Xylem source through every compiler stage to its final machine code. |
| `xylem-standard-library-development` | Add and maintain Xylem standard-library modules with correct API contracts, allocation behavior, prelude integration and tests. |
| `xylem-testing-and-benchmarking` | Add and run Xylem correctness tests, compiler regressions, differential checks and fair performance benchmarks. |
| `xylem-tooling-and-workflows` | Use the verified Xylem build, run, test, benchmark and inspection commands. |
| `xylem-types-and-memory` | Understand Xylem's actual type system, value representation, allocation, copy/move/drop behavior, ownership and runtime memory management. |

## Application delivery (6)

| Skill ID | Purpose |
|---|---|
| `xylem-app-research` | Establish revision-pinned, citation-backed facts before designing or building a Xylem application. |
| `xylem-app-design` | Design a high-quality Xylem application with measurable consumer-level acceptance criteria, L0-L7 placement, module and effect ownership, versioned contracts, refusal codes, fixtures and an ADR for durable tradeoffs. |
| `xylem-app-implementation` | Write Xylem application source under strict delivery method - smallest coherent end-to-end change, one canonical implementation, pinned-compiler idioms, explicit effects and Result/refusals, incremental checks, deterministic output and an evidence-bearing completion record with the exact check command and output. |
| `xylem-app-build` | Compile and build a Xylem application rigorously with a pinned compiler, bounded subprocesses and a hash-identified artifact. |
| `xylem-app-verification` | Prove a Xylem application works using positive and negative fixtures, byte-exact output, pinned-compiler execution and an independent verifier before any PASS claim. |
| `xylem-app-delivery` | Top-level strict delivery method for high-quality Xylem applications: ordered gates, explicit exit criteria, a delivery ledger and a STOP condition. |

Total unified in-house library: 112 skills.

