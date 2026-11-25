#!/usr/bin/env bash
# Regression guard for semantic/citation drift in xylem-types-and-memory
# (SKILL.md + references/ownership-rules.md). Doc-only structural check; no
# build, no benchmark. Fails on the pre-fix text, passes once the trap/drop
# rule matches the contract, the ABI claim is backend-scoped, and stale spans
# are repointed. Usage: check-citations.sh [skill_dir]
set -uo pipefail

repo_root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
dir="${1:-$(cd "$(dirname "$0")" && pwd)}"
skill="$dir/SKILL.md"
rules="$dir/references/ownership-rules.md"
repr="$dir/references/representation-map.md"
for f in "$skill" "$rules" "$repr"; do
    [[ -f "$f" ]] || { echo "FAIL missing: $f" >&2; exit 1; }
done

fail=0
absent() { local f; for f in "$skill" "$rules" "$repr"; do
    if grep -qF -- "$1" "$f"; then echo "FAIL stale token in $(basename "$f"): $1"; fail=1; fi
done; }
present() { if grep -qF -- "$1" "$skill"; then echo "OK present: $1"
    else echo "FAIL missing: $1"; fail=1; fi; }
present_any() { local f; for f in "$skill" "$rules" "$repr"; do
    grep -qF -- "$1" "$f" && { echo "OK present (any): $1"; return 0; }
done; echo "FAIL missing (any): $1"; fail=1; }
resolves() {
    if [[ -e "$repo_root/$1" || -e "$repo_root/../$1" || -e "$repo_root/../../$1" || -e "$repo_root/../../../$1" ]]; then
        echo "OK path resolves: $1"
    else echo "FAIL dangling path: $1"; fail=1; fi
}

# --- F1: trap/drop wording must match contract.md:905-918 ---
absent 'NOT on trap unwind'
present 'does not execute user `Drop` hooks'
present 'releases their owned storage and refcounts'
resolves docs/language/contract.md

# --- F2: ABI claim scoped per backend ---
absent 'Every generated function takes I64 parameters and at most one I64 result;'
present 'ptr %runtime'
present 'Cranelift'
present 'LLVM'

# --- F3: repr_plan demotion scoped to call args / returns ---
absent 'repr.rs:162-191'
present 'repr.rs:158-193'
resolves xylem-rust/crates/xylem-llvm/src/repr.rs

# --- F4: stale spans repointed ---
absent 'cranelift_runtime.c:11775-11807'
absent 'cranelift_runtime.c:896-939'
absent 'cranelift_runtime.c:943-947'
absent 'full_lower.rs:5060-5079'
absent 'cranelift_full.rs:7421-7441'
absent 'full_lower.rs:5046-5057'
absent 'cranelift_runtime.c:2177-2185'
absent 'cranelift_runtime.c:1933-1939'
absent 'cranelift_runtime.c:1944-2047'
absent 'cranelift_runtime.c:4345-4351'
absent 'cranelift_runtime.c:3422-3497'
absent 'cranelift_runtime.c:2555-2633'
present 'cranelift_runtime.c:11255-11257'
present 'cranelift_runtime.c:904-947'
present 'cranelift_runtime.c:951-955'
present 'full_lower.rs:6308-6346'
present 'cranelift_full.rs:7043-7057'
present 'cranelift_runtime.c:2148-2156'
present 'cranelift_runtime.c:1924-1930'
present 'cranelift_runtime.c:1935'
present 'cranelift_runtime.c:4371-4377'
present 'cranelift_runtime.c:3393'
present 'cranelift_runtime.c:2526'
present_any 'CF:5351-5420'
present_any 'CF:7202-7277'

if (( fail != 0 )); then echo "CITATION GUARD: FAIL"; exit 1; fi
echo "CITATION GUARD: PASS"
