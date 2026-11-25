# Ranked opportunities (verified status)

| # | Opportunity | Insertion / file | Status | Prerequisite |
|---|---|---|---|---|
| 1 | Integrate dormant aggregate read folding | `optimize_fold_agg.xy`; call at `optimize.xy:221,255`; re-key to FoldFacts | Dormant | close invalidation gaps at :114-119 |
| 2 | Generalize induction/trip-count proofs | `optimize_induction.xy:12-19,47-116` | Partial | dominator matrix already available |
| 3 | Pure-read/Index CSE | `optimize_cse_table.xy:43-79`; extend CseKey with field/variant identity | Missing (ADR claims present) | effect summaries; conservative invalidation |
| 4 | Wire merge_once | `optimize_merge.xy:183-239` near `optimize.xy:230,268` | Missing | audit exits/labels |
| 5 | Slice bounds proof | `ir_slice.xy:31`, `ir_slice_json.xy:24-31` | Planned (ADR-0103) | host parser pin change |
| 6 | Arithmetic proven flag | `checked-arithmetic-ir-flag-draft.md:42-95`; `ir_json.xy:58-77` | Blocked by pin | activation checklist :127-143 |
| 7 | Range/interval analysis | new `optimize_range.xy` near `optimize.xy:236-241` | Missing | absence under opt-level none |
| 8 | Loop unrolling | new `optimize_unroll.xy` in non-size branch :244-246 | Missing | trip-count fact; code-growth budget |
| 9 | Target-aware pass policy | thread target into `optimize_program` (:279) | Low value today | no cost model; measurements forbidden by AGENTS.md |
| 10 | Vectorization / SVE | mostly `xylem-rust` backend + repr | Not feasible here now | non-SSA IR, boxed AValue, no fast-math |

Backend-side opportunities (see `xylem-rust/.agents/skills/xylem-native-codegen/references/target-features.md`): opt-in `-march`/`-mcpu`, ThinLTO, triple/datalayout in IR, `!range`/`nsw/nuw`, typed GEPs, native float, multiversioning last. All are HYPOTHESIS until paired A/B under LLVM release with exact identities.
