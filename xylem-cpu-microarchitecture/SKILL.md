---
name: xylem-cpu-microarchitecture
description: "Diagnose CPU performance with evidence instead of guessing from instruction counts."
---

# Cpu Microarchitecture

## When to use

Diagnose CPU performance with evidence instead of guessing from instruction counts.

## Procedure

1. Record CPU model/features and workload shape; inspect instruction dependencies, branch behavior, memory access and cache locality.
2. Use authorized counters or disassembly to form bounded hypotheses; account for latency, throughput and cache effects without assuming all targets match.
3. Compare candidate changes against equivalent work; distinguish unavailable counters from measured zero and avoid ungrounded claims.

## Exit evidence

A hypothesis, code/counter evidence, target constraints and a controlled validation plan or result.

## Guardrails

Apply the repository rules and current mission authorization. Do not invent source facts, bypass security controls, or claim checks that were not run. If verification is unavailable, mark the result pending or blocked with the exact reason and continue independent in-scope work.
