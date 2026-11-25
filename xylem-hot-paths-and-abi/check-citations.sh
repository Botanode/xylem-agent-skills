#!/usr/bin/env bash
# Regression guard for citation/span and verification-label drift in
# xylem-hot-paths-and-abi (SKILL.md + references/abi-map.md).
# Doc-only structural check (no build, no benchmark). Fails on the pre-fix
# text; passes once stale spans, labels, backend tags and the correctness
# guardrail are corrected. Usage:
#   check-citations.sh [skill_dir]   # default: this skill's directory
set -uo pipefail

repo_root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
dir="${1:-$(cd "$(dirname "$0")" && pwd)}"
skill="$dir/SKILL.md"
abi="$dir/references/abi-map.md"
for f in "$skill" "$abi"; do
    [[ -f "$f" ]] || { echo "FAIL missing: $f" >&2; exit 1; }
done

fail=0
absent() { # stale token must be gone from both files
    local f
    for f in "$skill" "$abi"; do
        if grep -qF -- "$1" "$f"; then echo "FAIL stale token in $(basename "$f"): $1"; fail=1; fi
    done
}
present() { # corrected token must appear in SKILL.md
    if grep -qF -- "$1" "$skill"; then echo "OK present: $1"
    else echo "FAIL missing: $1"; fail=1; fi
}
resolves() {
    if [[ -e "$repo_root/$1" || -e "$repo_root/../$1" || -e "$repo_root/../../$1" || -e "$repo_root/../../../$1" ]]; then
        echo "OK path resolves: $1"
    else echo "FAIL dangling path: $1"; fail=1; fi
}

# --- F1/F2/F3/F4: wrong spans (must be gone from both files) ---
absent 'cranelift_full.rs:7421-7441'
absent 'full_lower.rs:5046-5057'
absent 'cranelift_full.rs:7524-7552'
absent 'cranelift_full.rs:7580-7656'
absent 'CF:5710-5785'
absent 'perf README :762-782'

# --- corrected spans (present in SKILL.md) ---
present 'cranelift_full.rs:7043-7057'
present 'cranelift_full.rs:1616-1669'
present 'cranelift_full.rs:7202-7277'
present 'cranelift_full.rs:5351-5420'
present 'tests/perf/README.md:770-790'
resolves tests/perf/README.md
resolves xylem-rust/crates/xylem-native/src/cranelift_full.rs
resolves xylem-rust/crates/xylem-llvm/src/full_lower.rs

# --- F5/F6/F8: honest labels and backend tagging ---
absent '## The actual ABI (verified)'
absent '## Hot-path mechanisms (verified)'
present 'PENDING_INDEPENDENT_VERIFICATION'
present 'Cranelift numbers are development diagnostics'

# --- F9: correctness guardrail in the decision guide ---
present 'map_remove'

# --- F10: path-qualified evidence with the known conflict noted ---
present 'docs/development/performance-execution-record.md:1346-1363'
present '109,968,292'

if (( fail != 0 )); then echo "CITATION GUARD: FAIL"; exit 1; fi
echo "CITATION GUARD: PASS"
