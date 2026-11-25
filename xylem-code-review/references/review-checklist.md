# Detailed evidence requirements

Source claim → file:line. Behavior claim → test or verified execution.
Performance claim → baseline, paired A/B, at least 3 samples, checksum equality,
exact compiler/host hashes, noise floor, and the attribution bucket
(semantic/runtime/optimizer/backend/hardware).

Compiler change → IR verifier clean; `optimizer_equivalence` and
`llvm_backend` pass; proof-discipline reference satisfied; regression test
landed; code size and compile time within budget.

Never accept: "looks faster", "should inline", "the backend probably optimizes
it", or a speedup from a non-equivalent workload. See
`xylem-optimizer/references/proof-discipline.md`.
