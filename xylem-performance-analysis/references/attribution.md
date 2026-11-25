# Five-way attribution

- **A — Semantic**: required by checked arithmetic, finite traps, bounds,
  ownership/drop, trap locations. Evidence: changing to wrapping/sentinel form
  removes the cost AND changes documented behavior.
- **B — Runtime/representation**: boxing, RC, helper calls, library algorithm.
  Evidence: allocation counter, call census, preallocated-variant A/B.
- **C — Optimizer**: legal transformation not performed. Evidence: pass remarks,
  IR before/after, flag toggle changes both IR and timing with same checksum.
- **D — Backend/codegen**: instruction selection, ABI, register allocation,
  layout. Evidence: assembly diff with identical IR.
- **E — Hardware**: bandwidth, latency, cache/TLB, predictor. Evidence: model +
  counters, same code shape across languages.

Minimum evidence before blaming the compiler: assembly diff, hardware model
predicting the ranking on the tested core, counter evidence, assembly-only
control, and replication on a second core family. Without these, you measured
the machine, not a compiler defect.
