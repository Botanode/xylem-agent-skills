# What the compiler does to source constructs (source-verified; see row evidence)

Abbreviations (as in `xylem-types-and-memory/references/representation-map.md:3`;
paths relative to `xylem-rust`): RT=`crates/xylem-native/src/cranelift_runtime.c`,
CF=`cranelift_full.rs`, FL=`crates/xylem-llvm/src/full_lower.rs`,
RP=`crates/xylem-llvm/src/repr.rs`.

Representation facts for most rows below are maintained in
`xylem-types-and-memory/references/representation-map.md:7-20`; keep the two in
sync (`MAINTENANCE.md:36-40`).

| Source construct | Compiler behavior | Evidence |
|---|---|---|
| unboxed scalar temp | machine word; arithmetic inline with overflow guards | CF:2891-3189 |
| managed temp | runtime cell from 64-slot frame arena; fast get/set | RT:71-88,2105-2172; CF:5710-5785 |
| `&local` / shared field borrow | tagged direct reference, no allocation | RT:1032-1065,3517-3536 |
| owning/path reference | A_REF path node allocation | RT:3422-3497 |
| Vec<i64> element | native i64 buffer, inline address, bounds only when checked | RT:884-891,3665-3690; FL:1870-1880 |
| generic Vec/struct | boxed AValue + fields; COW unshare on mutation | RT:909-923,1944-2047 |
| string literal | interned pool, one refcount increment on hit | RT:2555-2633 |
| drop/scope exit | recursive refcount release in reverse order | RT:1683-1746; contract.md:905-918 |
| direct scalar-only call | unboxed ABI words | CF:1623-1679 |
| call/task/dynamic/return with non-scalar | demoted to Managed, cell allocated | RP:162-191; FL:4911-4938 |
| if/guard/bounds proofs | checked bits cleared only for provable cases | optimize_bounds.xy:86-99; optimize_induction.xy:47-116; optimize_vec_proof.xy:124-189 |
| LLVM release | textual IR + clang -O2 + full LTO; no target datalayout, LLVM IR `<N x T>` vector types, nsw/nuw, !range | `xylem-rust/crates/xylem-llvm/src/emit.rs:81-103` (clang flags), `xylem-rust/crates/xylem-llvm/src/optimize.rs:14-19` (-O2); absence checked by searching `xylem-rust/crates/xylem-llvm/src` for `nsw|nuw|!range|datalayout` (no hits) |

COMP-002 historically measured ~45× compile time for 10× source
(`xylem-lang/AGENTS.md:50-52`; PENDING_INDEPENDENT_VERIFICATION). The four
scans formerly cited here have since been indexed/bucketed and are no longer an
open author-facing workaround: `typecheck_if.xy:13-20` (ReturnSpanIndex),
`safety.xy:409-413` (256-bucket chain), `optimize_cse.xy:6-10` (counting sort),
`optimize_hoist_cfg.xy:147-153` (cached popcount).

All claims PENDING_INDEPENDENT_VERIFICATION until reproduced by another agent.
