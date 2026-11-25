# Where changes live in xylem-lang

| Concern | Files |
|---|---|
| Driver / stage order | `compiler/src/driver.xy`, `pipeline.xy` |
| Canonical IR and wire format | `ir.xy`, `ir_json.xy`, `ir_array_json.xy`, `ir_place_json.xy`, `validate.xy` |
| Optimizer driver | `optimize.xy:213-311` (per-function pass order) |
| Copy / CSE / reachability | `optimize_copies.xy`, `optimize_cse*.xy`, `optimize_reachable.xy` |
| Folding / constants | `optimize_fold.xy`, `optimize_const.xy`, `optimize_fold_agg.xy` (dormant) |
| Bounds / induction / modulus | `optimize_bounds.xy`, `optimize_induction*.xy`, `optimize_vec_proof.xy`, `optimize_modulus.xy` |
| LICM / CFG / dominators | `optimize_hoist.xy`, `optimize_hoist_cfg.xy`, `optimize_cfg.xy` |
| Inlining / merging | `optimize_inline.xy`, `optimize_merge.xy` |
| Lowering | `lower*.xy` (~90 modules); start from `lower_expr.xy`, `lower_vec_access.xy`, `lower_field_place.xy` |
| Types / names | `common.xy` (`Ty.Raw(String)`), `type_name.xy`, `name_index.xy` |
| Frontend scans | `typecheck_if.xy`, `typecheck_expr.xy`, `safety.xy`, `resolver.xy`, `typecheck_signature_scope.xy`, `interface_scope.xy` |
| Loader / prelude | `loader.xy`, `prelude*.xy` |
| Collections / strings | `stdlib/src/std/{collections,hash,strings}.xy` |
| Gates | `scripts/check-*.xy`, `scripts/check.sh` |
| Benchmarks / reproducers | `tests/perf/`, `tests/perf/reproducers/`, `tests/perf/probe/` |
| Canonical performance record | `docs/development/PERFORMANCE.md` |
| Evidence state | `docs/development/EVIDENCE_LEDGER.md` |
