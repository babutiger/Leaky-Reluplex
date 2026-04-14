#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

SKIP_BUILD=0
JOBS=""

usage() {
    cat <<'EOF'
Usage:
  ./scripts/reproduce_paper.sh [--skip-build] [--jobs N] [full]
  ./scripts/reproduce_paper.sh [--skip-build] [--jobs N] target [target ...]

Targets:
  test
  property1 property2 property3 property4 property5
  property6 property7 property8 property9 property10
  adversarial
  full

Examples:
  ./scripts/reproduce_paper.sh full
  ./scripts/reproduce_paper.sh property1 property6 adversarial
EOF
}

run_target() {
    local target="$1"

    case "${target}" in
        test)
            echo "Running reluplex smoke test"
            (
                cd "${REPO_ROOT}/reluplex"
                ./test.sh
            )
            ;;
        property1|property2|property3|property4|property5|property6|property7|property8|property9|property10|adversarial)
            echo "Running ${target}"
            (
                cd "${REPO_ROOT}"
                "./scripts/run_${target}.sh"
            )
            ;;
        *)
            echo "Unknown target: ${target}" >&2
            exit 1
            ;;
    esac
}

TARGETS=()

while [ "$#" -gt 0 ]; do
    case "$1" in
        --skip-build)
            SKIP_BUILD=1
            shift
            ;;
        -j|--jobs)
            JOBS="$2"
            shift 2
            ;;
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
            echo "Unknown argument or target: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

if [ "${#TARGETS[@]}" -eq 0 ]; then
    TARGETS=(test property1 property2 property3 property4 property5 property6 property7 property8 property9 property10 adversarial)
fi

if [ "${SKIP_BUILD}" -eq 0 ]; then
    BUILD_ARGS=()
    if [ -n "${JOBS}" ]; then
        BUILD_ARGS+=(--jobs "${JOBS}")
    fi
    "${SCRIPT_DIR}/build_all.sh" "${BUILD_ARGS[@]}"
fi

"${SCRIPT_DIR}/record_environment.sh" "${REPO_ROOT}/logs/repro_environment.txt" >/dev/null

{
    echo "Leaky-Reluplex reproduction manifest"
    echo "timestamp_utc: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    printf 'targets:'
    for target in "${TARGETS[@]}"; do
        printf ' %s' "${target}"
    done
    printf '\n'
} | tee "${REPO_ROOT}/logs/reproduction_manifest.txt" >/dev/null

for target in "${TARGETS[@]}"; do
    echo "=== ${target} ==="
    run_target "${target}"
done

echo "Reproduction run complete."
echo "Environment log: logs/repro_environment.txt"
echo "Manifest: logs/reproduction_manifest.txt"
