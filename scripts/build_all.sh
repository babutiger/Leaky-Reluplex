#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

JOBS=""
RECORD_ENVIRONMENT=1

usage() {
    cat <<'EOF'
Usage: ./scripts/build_all.sh [--jobs N] [--skip-env]

Build GLPK, the Leaky-Reluplex core, and all property binaries.
EOF
}

require_cmd() {
    local cmd="$1"
    if ! command -v "${cmd}" >/dev/null 2>&1; then
        echo "Missing required command: ${cmd}" >&2
        exit 1
    fi
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        -j|--jobs)
            JOBS="$2"
            shift 2
            ;;
        --skip-env)
            RECORD_ENVIRONMENT=0
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

require_cmd bash
require_cmd make
require_cmd gcc
require_cmd g++
require_cmd tee

if [ -z "${JOBS}" ]; then
    if command -v nproc >/dev/null 2>&1; then
        JOBS="$(nproc)"
    else
        JOBS=1
    fi
fi

mkdir -p "${REPO_ROOT}/logs"

if [ "${RECORD_ENVIRONMENT}" -eq 1 ]; then
    "${SCRIPT_DIR}/record_environment.sh" "${REPO_ROOT}/logs/repro_environment.txt" >/dev/null
fi

echo "[1/3] Building GLPK into glpk-4.60/installed"
(
    cd "${REPO_ROOT}/glpk-4.60"
    ./configure_glpk.sh
    make -j"${JOBS}"
    make install
)

echo "[2/3] Building Leaky-Reluplex core"
(
    cd "${REPO_ROOT}/reluplex"
    make -j"${JOBS}"
)

echo "[3/3] Building property binaries"
(
    cd "${REPO_ROOT}/check_properties"
    make
)

echo "Build complete."
