# Measured cost map (diagnostic, not release-certified)

| Operation | Evidence | Mechanism |
|---|---|---|
| Map lookup hit | 12,434.9→11,692.7 ns (6%, 18/21 pairs; earlier 19,023→16,813). **Directional only**: the unchanged `get_mut` control moved 17.5% and `map-count` was 3.3% slower; host load 21.4, checksums 3,630,600/2,420,400, compiler `a47c16a8…`→`dae9aca5…` (`xylem-rust/docs/performance-parity.md:212-227`). 3.15→0.03 allocations/LLVM lookup uses an unlanded patch (`tests/perf/README.md:782-790`) | hash + bucket chain + Option construction; `loader.rs:414-433,346-364` |
| Map lookup miss | 1,047 ns on empty map; map-flat 74,585 ns/key vs hit 26,807 | full probe chain |
| Map insert new/replace | 14,461→12,453 / 5,732→5,276 ns | `loader.rs:385-400,464-497`; 16 buckets allocated on first insert |
| Map remove | NO speedup; historical nondeterministic checksums (398093072/530288458/685998038 vs 201837219, §18.1); working-tree probe since deterministic in §23.2 (`performance-execution-record.md:1688-1703`) | pre-revert generic values handle recycled; current owned-`MapEntry` prelude at `loader.rs:544-553` |
| Vector push | single IR `VecPush`; growth in runtime | `lower_expr_tails.xy:27-30` |
| Vector index | direct 387,019 / vec_get 698,661 / vec_get_mut 981,250 / vec_len-in-loop 308,594 ns per 4096 pass | Option variants + bounds branch |
| String concat | string-ops 193,298 vs Rust 166,482 vs C 21,186 ns/op | prefix recopy |
| String byte scan | compiler-intern: out-of-line byte_length call + per-byte `string_byte_at` | `compiler-intern.md:119-150` |
| Boxed representation | native struct-ops allocations 5,295→217 with native repr | parity doc :229-249 |

Sources: xylem-lang/tests/perf/README.md, results/compiler-{ast,intern}.md,
xylem-rust/docs/performance-parity.md, docs/development/performance-execution-record.md.
All entries PENDING_INDEPENDENT_VERIFICATION under the AGENTS.md rule.
