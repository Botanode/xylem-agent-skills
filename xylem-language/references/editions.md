# Editions: frozen 1.0 vs development line

`docs/language/contract.md:19-20,110-134` defines two surfaces:

- **Edition 2026 (frozen 1.0)**: normative; deliberately rejects FFI, bare
  `dyn`, `Vec.new()`, macros, `throw`, operator overloading, named-payload enum
  variants. Stable rejection codes exist in the conformance corpus.
- **Editions 2027/2028 (development line)**: accept `extern "C"`, `&dyn T`,
  `Box<dyn T>`, `vec_new()`, advanced generics (GATs, HRTB), structured
  concurrency, capabilities and authority parameters.

Check `xylem.toml` (`edition`) before using any edition-sensitive construct.
Backends and tools differ: some features work only in the interpreter or only
in the development compiler; a feature working in one backend does not prove
cross-backend support. Always validate with `xylem check` and run on the LLVM
release backend for any performance claim.

Conformance pins both surfaces: `dynamic-dispatch` is accepted
(`manifest.json:184-200`) while `unsupported-dyn-dispatch` is rejected E1101
(`manifest.json:1950-1966`). The distinction is bare `dyn T` vs `&dyn T`.
