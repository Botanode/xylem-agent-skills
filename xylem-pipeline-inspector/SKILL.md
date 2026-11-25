---
name: xylem-pipeline-inspector
description: Trace a specific piece of Xylem source through every compiler stage to its final machine code. Use when an agent needs to know how high-level Xylem code becomes IR, how the optimizer changes it, how the LLVM backend lowers it, and what machine instructions result; when investigating a performance gap, a trap, a boxing site, or a lowering decision; or when asked "what does this code compile to" / "where does the overhead appear".
---

# Xylem pipeline inspector

Turn one high-level construct into a **verified, stage-by-stage evidence chain**:
source → canonical IR → optimized IR → wire request → backend lowering →
LLVM IR → assembly → measured behaviour. Nothing here is a performance claim;
every stage ends in an artifact an agent can inspect.

## Ground rules

- LLVM is the release backend; use `--backend llvm --release` for every trace.
  Cranelift is development-only and appears only in explicit cross-backend diffs.
- Do not guess what a pass did. Emit the IR before and after, diff it, and name
  the exact pass from the pipeline order.
- Do not attribute a machine-code property to a compiler defect before checking
  language semantics, runtime representation and the hardware model.
- Every artifact must be recorded with compiler/host hashes, flags, seed and
  the command that produced it.

## The trace (each stage ends on a checkable completion criterion)

1. **Pin the source construct.** Extract the smallest standalone `.xy` program
   containing the construct, with a deterministic checksum and fixed input.
   *Done when:* the program compiles and prints a checksum under `xylem run`
   and under `xylem build --release --backend llvm`.

2. **Frontend and canonical IR.** Dump `xylem ir <file> --json`. Identify the
   `IrInstrKind` records produced for the construct using
   `compiler/src/ir.xy:4-60` as the inventory; note the `checked` flag and the
   temp types (`common.xy` `Ty.Raw` strings).
   *Done when:* each source operation is mapped to named IR instructions with
   exact instruction indices and the JSON fields that carry its semantics.

3. **Pipeline position.** Find where those instructions enter the 20-step
   per-function pipeline at `compiler/src/optimize.xy:213-272`. Use the timing
   slots at `:294-308` and the pass modules in
   `references/pipeline-stages.md` to name every pass that can rewrite them.
   *Done when:* the pass sequence affecting the construct is listed in order,
   with the file:line of each pass and what it may change.

4. **Before/after optimization.** Produce optimized IR and diff it against the
   unoptimized dump. Name the pass responsible for each deletion or rewrite;
   check the dormant-pass and ADR backlog before calling something "missing".
   *Done when:* every difference is attributed to a specific pass, and any
   remaining `checked` flag or helper call is explained by a documented
   blocker (`references/pipeline-stages.md`).

5. **Wire request.** Inspect `xylem ir --json` request envelope
   (`ir_json.xy:400-435`): schema, ABI, target triple, profile, opt level,
   backend, sources and program. Confirm the backend host revalidates it
   (`xylem-rust/crates/xylem-backend-host/src/lib.rs`), and that no proof bit is silently
   dropped (`toolchain.toml:15-20`).
   *Done when:* the request's identities and wire members are recorded, and
   any unsupported proof bit is explicitly named.

6. **Backend lowering.** In `xylem-rust/crates/xylem-llvm/src/full_lower.rs`,
   locate the lowering of each surviving IR kind (the map is in
   `references/pipeline-stages.md`). Record which fast paths apply, which
   helper calls remain, and whether a guard/cold trap path is emitted.
   *Done when:* each IR instruction has a named lowering function and its
   emitted LLVM construct (GEP, `llvm.*` intrinsic, helper call, branch).

7. **LLVM IR and machine code.** Emit textual IR with `clang -S -emit-llvm`
   from the host or the backend's own dump; then `objdump -d` the release
   binary. Assert the presence/absence of the mechanism under investigation
   (allocator calls, refcount ops, bounds branches, vector registers, spill
   slots, indirect calls) with grep counts.
   *Done when:* numeric assembly evidence is recorded, with the exact command
   and artifact path.

8. **Behaviour and cost.** Run the binary with `XYLEM_MEMORY_STATS=1` for
   allocation counts; measure with the paired-A/B protocol in
   `xylem-benchmarks/research/methodology.md` if a performance question is
   being asked. Classify each observation as semantic / runtime / optimizer /
   backend / hardware using the investigation handbook.
   *Done when:* a written trace states where the work happens, why, and which
   layer could legally remove it — with evidence paths, not assertions.

## References

- `references/pipeline-stages.md` — stage-by-stage file:line map and the exact
  commands/artifacts for each stage.
- `references/evidence-format.md` — the trace record schema.
