# Representation map (source-traced, not independently verified)

All spans below are `PENDING_INDEPENDENT_VERIFICATION` until an independent
verifier reproduces them.

Abbreviations: RT=`crates/xylem-native/src/cranelift_runtime.c`, CF=`cranelift_full.rs`, FL=`crates/xylem-llvm/src/full_lower.rs`, RP=`crates/xylem-llvm/src/repr.rs`.

| Xylem operation | Representation | Runtime calls / inline path | Semantic vs implementation |
|---|---|---|---|
| unboxed int/bool/char scalar | I64 word / `Repr::Scalar` | none on fast path; box only at ABI boundary (RT:11255-11257) | implementation |
| `+ - *` on ints | raw I64 | `sadd_overflow` + cold helper (CF:3023-3126) | semantic R6002; impl inline fast path |
| `/ %` on ints | raw I64 | zero/MIN guards + `sdiv` (CF:3127-3189) | semantic R6001/R6002 |
| float ops | IEEE bits in I64 | `fadd` etc + exponent test, cold helper (CF:2891-2948) | semantic finite trap; impl inline |
| checked cast | word + range proof | helper only when needed (CF:2734-2824) | semantic R6002 |
| read/write boxed temp | AValue cell | `cell_get_fast`/`cell_set_fast` inline tag test, fallback helper (CF:5351-5420) | semantic copy/drop; impl fast path |
| `&local`, shared field borrow | tagged direct ref (`cell|1`) | no allocation (RT:1040-1065, 3517-3536) | semantic borrow; impl tagging |
| owning/path ref | AValue(A_REF) | `a_ref_append_segment` allocates path node (RT:3393) | impl allocation |
| Vec<i64> element | native buffer `A_VEC_I64_KIND` | data+index*8, bounds only when checked (RT:884-891, FL:1870-1880) | semantic R6004; impl native buffer |
| generic Vec<T>/struct | boxed AValue + AField arrays | a_vec_new/push, a_field, copy_value, a_free_value; COW a_unshare (RT:1935) | semantic value semantics; impl boxing/COW |
| scalar struct (non-escaping) | one native var per leaf / `[N x i64]` alloca | none per field (CF:800-813, FL:2237-2291) | impl SROA |
| string | interned AValue(A_STRING) | pool hit = refcount increment (RT:2526) | semantic length-aware; impl interning |
| drop / frame exit | owning AValue cell | a_free_value recursion, frame arenas (RT:1691-1746,1769-1834) | semantic deterministic drop |
| scalar-only direct call | words in I64 params | no boxing when callee in `scalar_functions` (CF:1616-1679) | impl ABI fast path |
| C export | wrapper boxes/unboxes + runtime lifecycle (CF:7202-7277) | implementation |
