#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

usage() {
    cat <<'EOF'
Usage:
  ./scripts/check_reproduction_outputs.sh [full]
  ./scripts/check_reproduction_outputs.sh target [target ...]

Targets:
  test
  property1 property2 property3 property4 property5
  property6 property7 property8 property9 property10
  adversarial
  full
EOF
}

TARGETS=()

while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        full)
            TARGETS=(test property1 property2 property3 property4 property5 property6 property7 property8 property9 property10 adversarial)
            shift
            ;;
        test|property1|property2|property3|property4|property5|property6|property7|property8|property9|property10|adversarial)
            TARGETS+=("$1")
            shift
            ;;
        *)
            echo "Unknown target: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

if [ "${#TARGETS[@]}" -eq 0 ]; then
    TARGETS=(test property1 property2 property3 property4 property5 property6 property7 property8 property9 property10 adversarial)
fi

missing=0

check_file() {
    local label="$1"
    local path="$2"
    if [ -s "${path}" ]; then
        echo "OK   ${label}: ${path}"
    else
        echo "MISS ${label}: ${path}"
        missing=$((missing + 1))
    fi
}

check_pattern() {
    local label="$1"
    local pattern="$2"
    local count
    count=$(find "${REPO_ROOT}" -path "${REPO_ROOT}/${pattern}" -type f 2>/dev/null | wc -l | tr -d ' ')
    if [ "${count}" -gt 0 ]; then
        echo "OK   ${label}: ${pattern} (${count} files)"
    else
        echo "MISS ${label}: ${pattern}"
        missing=$((missing + 1))
    fi
}

for target in "${TARGETS[@]}"; do
    case "${target}" in
        test)
            check_file "smoke test output" "${REPO_ROOT}/reluplex/test.txt"
            ;;
        property1|property2|property3|property4|property5|property7|property8|property9|property10)
            check_file "${target} summary" "${REPO_ROOT}/logs/${target}_summary.txt"
            check_pattern "${target} stats" "logs/${target}_stats_*.txt"
            ;;
        property6)
            check_file "property6 summary" "${REPO_ROOT}/logs/property6_summary.txt"
            check_pattern "property6 lower stats" "logs/property6_lower_stats_*.txt"
            check_pattern "property6 upper stats" "logs/property6_upper_stats_*.txt"
            ;;
        adversarial)
            check_file "adversarial summary" "${REPO_ROOT}/logs/adversarial_summary.txt"
            check_file "adversarial stats" "${REPO_ROOT}/logs/adversarial_stats.txt"
            ;;
    esac
done

if [ "${missing}" -gt 0 ]; then
    echo "Reproduction output check failed: ${missing} expected outputs missing." >&2
    exit 1
fi

echo "All expected reproduction outputs are present."
