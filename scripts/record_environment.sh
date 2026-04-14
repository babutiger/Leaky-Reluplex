#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_PATH="${1:-${REPO_ROOT}/logs/repro_environment.txt}"

mkdir -p "$(dirname "${OUTPUT_PATH}")"

get_version_line() {
    local cmd="$1"
    if ! command -v "${cmd}" >/dev/null 2>&1; then
        echo "not found"
        return
    fi

    local first_line
    first_line="$("${cmd}" --version 2>/dev/null | head -n 1 || true)"
    if [ -n "${first_line}" ]; then
        echo "${first_line}"
    else
        command -v "${cmd}"
    fi
}

{
    echo "Leaky-Reluplex reproducibility environment"
    echo "timestamp_utc: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    echo "repo_root: ${REPO_ROOT}"
    echo "uname: $(uname -a)"

    if command -v lsb_release >/dev/null 2>&1; then
        echo "lsb_release: $(lsb_release -ds)"
    fi

    if command -v git >/dev/null 2>&1; then
        echo "git_commit: $(git -C "${REPO_ROOT}" rev-parse HEAD 2>/dev/null || echo unavailable)"
        echo "git_branch: $(git -C "${REPO_ROOT}" rev-parse --abbrev-ref HEAD 2>/dev/null || echo unavailable)"
    fi

    echo "bash: $(get_version_line bash)"
    echo "gcc: $(get_version_line gcc)"
    echo "g++: $(get_version_line g++)"
    echo "make: $(get_version_line make)"
    echo "timeout: $(get_version_line timeout)"
} | tee "${OUTPUT_PATH}"
