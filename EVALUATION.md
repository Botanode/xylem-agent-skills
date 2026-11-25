# Agent evaluation scenarios

Scenarios to test whether the skills change agent behavior. `EXECUTED` means a
real check was run in this workspace; `NOT EXECUTED` means the scenario is
specified for a future agent run. These map to the canonical evidence labels at
`.agents/skills/INDEX.md:47`: the executed part is VERIFIED/MEASURED, the
unrun part is PLANNED/UNKNOWN. Neither token claims skill effectiveness (the
fresh-agent A/B has not run).

## Discovery (NOT EXECUTED — fresh-agent A/B pending)

1. Ask "Explain Xylem" → expect `xylem-orientation` activation and no Rust assumptions.
2. Ask "Write a Xylem function with a map lookup" → expect `xylem-language` +
   `xylem-collections-and-strings`.
3. Ask "Optimize this Xylem loop" → expect `xylem-efficient-code` and a request for evidence.
4. Ask "Diagnose this compiler crash" → expect `xylem-debugging` + `xylem-compiler-architecture`.
5. Ask "What does this compile to?" → expect `xylem-pipeline-inspector`.
6. Ask "Compare with Rust" → expect `xylem-performance-analysis` + fairness rules.
7. Ask "Add a benchmark" → expect `xylem-testing-and-benchmarking`.
8. Ask "Review this change" → expect `xylem-code-review`.

## Correctness

9. Valid scalar/arithmetic program compiles and runs under LLVM release — **EXECUTED** (benchmark lab 86/86 Xylem cases; liveness only — all 86 `.xy` bodies are template stubs, see `research-fleet/SYNTHESIS.md:10`; not semantic validation).
10. Invalid `^` operator is identified as unsupported, not fabricated — **EXECUTED** (earlier failure: E1001 lexical).
11. Effects row required for allocation — **EXECUTED** (E4001 during template validation).
12. Typed literals for struct fields — **EXECUTED** (E3002 during template validation).
13. No lifetime elision / E3104 — specification in capability matrix; NOT EXECUTED (no oracle run).
14. Edition sensitivity (2026 vs 2027/2028) — conformance cases verified in source; NOT EXECUTED (no oracle run).

## Performance reasoning

15. Recognize unnecessary map lookups → pattern P03; evidence in `.agents/skills/xylem-collections-and-strings/references/cost-map.md`.
16. Identify cell/refcount overhead → `.agents/skills/xylem-hot-paths-and-abi/references/compiler-vs-source.md:7` and `.agents/skills/xylem-performance-analysis/references/attribution.md:7`; **VERIFIED** (source audit); **NOT EXECUTED** (fresh-agent A/B).
17. Inspect IR/assembly → `.agents/skills/xylem-pipeline-inspector/SKILL.md:31` (`xylem ir <file> --json`) and `:52-54` (wire request); **VERIFIED** (commands used in this workspace).
18. Reject invalid benchmark (different opt levels / checksums) → rule tested in analysis; NOT EXECUTED (fresh-agent A/B).
19. Distinguish compiler defect from hardware limit → attribution reference; NOT EXECUTED (fresh-agent A/B).
20. Reject stale advice (Cranelift "near-term") → stale text in `docs/development/_archive/XYLEM_AGGRESSIVE_OPTIMIZATION_RESEARCH.md.bak:333-335`; corrected at `docs/development/PERFORMANCE.md:113` and the AGENTS.md backend policy; **EXECUTED**.

## Compiler development (NOT EXECUTED — fresh-agent A/B pending)

21. Locate correct stage for a lowering bug — stage map provided.
22. Find where runtime calls originate — ABI map provided.
23. Propose a regression test — procedures provided.
24. Explain semantic risks of bounds-check removal — `xylem-optimizer/references/proof-discipline.md` provided (this skill owns the proof-discipline gate model; `xylem-compiler-optimization` is the technique catalog).
25. Final acceptance scenario: map-lookup + aggregation program with fair Rust comparison — skill coverage complete, full agent run NOT EXECUTED (fresh-agent A/B).

Record results in `docs/development/AGENT_SKILLS_VALIDATION.md` when fresh-agent runs happen.
