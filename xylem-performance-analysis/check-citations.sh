#!/usr/bin/env bash
# Regression guard for citation/command drift in xylem-performance-analysis/SKILL.md.
# Doc-only structural check (no build, no benchmark). Fails on the pre-fix text,
# passes once stale citations, the wrong command description, and unqualified
# cross-repo paths are corrected. Usage:
#   check-citations.sh [path/to/SKILL.md]   # default: this skill's SKILL.md
set -uo pipefail

repo_root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
skill="${1:-$(cd "$(dirname "$0")" && pwd)/SKILL.md}"
if [[ ! -f "$skill" ]]; then
    echo "FAIL missing skill file: $skill" >&2
    exit 1
fi

fail=0
absent() { # stale token must be gone
    if grep -qF -- "$1" "$skill"; then echo "FAIL stale token present: $1"; fail=1
    else echo "OK absent: $1"; fi
}
present() { # corrected token must be present
    if grep -qF -- "$1" "$skill"; then echo "OK present: $1"
    else echo "FAIL missing token: $1"; fail=1; fi
}
resolves() { # cited path must exist in the repo or the sibling workspace repo
    if [[ -e "$repo_root/$1" || -e "$repo_root/../$1" || -e "$repo_root/../../$1" || -e "$repo_root/../../../$1" ]]; then
        echo "OK path resolves: $1"
    else echo "FAIL dangling path: $1"; fail=1; fi
}

# --- F1: wrong full_lower.rs ranges ---
absent 'full_lower.rs:303-335,5103-5108'
present 'docs/development/PERFORMANCE.md:51,60-66'
resolves docs/development/PERFORMANCE.md
resolves docs/development/performance-execution-record.md

# --- F2: emit.rs:82-103 is clang command construction, not absence evidence ---
absent 'emit.rs:82-103'
present 'performance-execution-record.md:2455'
present 'xylem-rust/crates/xylem-llvm/src'
resolves xylem-rust/crates/xylem-llvm/src/emit.rs

# --- F3: xylem ir --json prints only optimized IR ---
absent 'Canonical IR before/after optimization (`xylem ir --json`).'
present 'prints only the optimized'
resolves compiler/src/cli_ir.xy

# --- F4: cross-repo paths qualified; archive labelled superseded ---
present 'docs/development/_archive/native-runtime-profile.md.bak'
present 'superseded'

if (( fail != 0 )); then
    echo "CITATION GUARD: FAIL"
    exit 1
fi
echo "CITATION GUARD: PASS"
