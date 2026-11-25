# Benchmark protocol (summary)

Full protocol: `xylem-benchmarks/research/methodology.md`.

- Build each configuration ≥3 times; warm up; ≥10 process launches × ≥5
  in-process iterations; interleave order; seed recorded.
- Prefer instruction counts (`instructions:u`) as low-variance primary metric;
  wall time as sanity. Noise floor: typical ±0.2%, worst ±1.3% for instructions;
  wall outliers around ±9%.
- Statistics: median, MAD, min/max, percentiles, 95% bootstrap CI; classify
  significance as CI excluding 1.0 AND effect above noise AND reproducible.
- Aggregation: geometric mean of ratios plus total/harmonic speedup; never a
  single unqualified number.
- Attribution: semantic / runtime / optimizer / backend / hardware, each with
  evidence. Implemented ≠ proven correct ≠ demonstrated improvement.
